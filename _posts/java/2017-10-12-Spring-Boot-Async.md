---
layout: post
title: "Spring Boot Async"
date: 2017-10-12 17:30:00 +0800
comments: true
categories: "Java"
---


This article will show how spring boot async works. 


##### Use Spring Boot Async

1. Add @Async annotation on method.

```
    @Async
    public Future<String> getAboutPage() throws InterruptedException {
        String string = "This is just a test";
        Thread.sleep(10000);
        return new AsyncResult<>(string);
    }
```

2. Add @EnableAsync Annotation on Startup class. 

```
@SpringBootApplication()
@EnableAsync
public class MbpVideoApplication {

    public static void main(String[] args) {
        SpringApplication.run(MbpVideoApplication.class, args);
    }
```

3. Callback Result

```
Method in service class:
@Async
    public Future<String> getAboutPage() throws InterruptedException {
        String string = "This is just a test";
        Thread.sleep(10000);
        return new AsyncResult<>(string);
    }
   
Method to call async function in controller class:
    @GetMapping(value = "async_website")
    public String asyncAccessWebsite() throws ExecutionException, InterruptedException, TimeoutException {
        Future<String>  stringFuture = iMbpVideoService.getAboutPage();

        return stringFuture.get(5000,TimeUnit.MILLISECONDS);
    } 
    
Future implementation class is FutureTask, get implementation:
    public V get(long timeout, TimeUnit unit)
        throws InterruptedException, ExecutionException, TimeoutException {
        if (unit == null)
            throw new NullPointerException();
        int s = state;
        if (s <= COMPLETING &&
            (s = awaitDone(true, unit.toNanos(timeout))) <= COMPLETING)
            throw new TimeoutException();
        return report(s);
    }
    
Blocking method awaitDone will wait till task is done.
    
private int awaitDone(boolean timed, long nanos)
        throws InterruptedException {
        final long deadline = timed ? System.nanoTime() + nanos : 0L;
        WaitNode q = null;
        boolean queued = false;
        for (;;) {
            if (Thread.interrupted()) {
                removeWaiter(q);
                throw new InterruptedException();
            }

            int s = state;
            if (s > COMPLETING) {
                if (q != null)
                    q.thread = null;
                return s;
            }
            else if (s == COMPLETING) // cannot time out yet
                Thread.yield();
            else if (q == null)
                q = new WaitNode();
            else if (!queued)
                queued = UNSAFE.compareAndSwapObject(this, waitersOffset,
                                                     q.next = waiters, q);
            else if (timed) {
                nanos = deadline - System.nanoTime();
                if (nanos <= 0L) {
                    removeWaiter(q);
                    return state;
                }
                LockSupport.parkNanos(this, nanos);
            }
            else
                LockSupport.park(this);
        }
    }    
``` 

##### ExecutorPool


1) Customize ExecutorPool

```
@Bean("taskExecutor")
    public Executor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(5);
        executor.setMaxPoolSize(20);
        executor.setQueueCapacity(2000);
        executor.setKeepAliveSeconds(60);
        executor.setThreadNamePrefix("taskExecutor-");
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        executor.setWaitForTasksToCompleteOnShutdown(true);
        executor.setAwaitTerminationSeconds(60);

        return executor;
    }
    
in AsyncExecutionAspectSupport class, it will get task executor bean named "taskExecutor".

	public static final String DEFAULT_TASK_EXECUTOR_BEAN_NAME = "taskExecutor";

@Nullable
	protected Executor getDefaultExecutor(@Nullable BeanFactory beanFactory) {
		if (beanFactory != null) {
			try {
				// Search for TaskExecutor bean... not plain Executor since that would
				// match with ScheduledExecutorService as well, which is unusable for
				// our purposes here. TaskExecutor is more clearly designed for it.
				return beanFactory.getBean(TaskExecutor.class);
			}
			catch (NoUniqueBeanDefinitionException ex) {
				logger.debug("Could not find unique TaskExecutor bean", ex);
				try {
					return beanFactory.getBean(DEFAULT_TASK_EXECUTOR_BEAN_NAME, Executor.class);
				}
				catch (NoSuchBeanDefinitionException ex2) {
					if (logger.isInfoEnabled()) {
						logger.info("More than one TaskExecutor bean found within the context, and none is named " +
								"'taskExecutor'. Mark one of them as primary or name it 'taskExecutor' (possibly " +
								"as an alias) in order to use it for async processing: " + ex.getBeanNamesFound());
					}
				}
			}
			catch (NoSuchBeanDefinitionException ex) {
				logger.debug("Could not find default TaskExecutor bean", ex);
				try {
					return beanFactory.getBean(DEFAULT_TASK_EXECUTOR_BEAN_NAME, Executor.class);
				}
				catch (NoSuchBeanDefinitionException ex2) {
					logger.info("No task executor bean found for async processing: " +
							"no bean of type TaskExecutor and no bean named 'taskExecutor' either");
				}
				// Giving up -> either using local default executor or none at all...
			}
		}
		return null;
	}
```   

##### How it works

```
TraceAsyncAspect will have around intercept for Async annotation methods.

@Around("execution (@org.springframework.scheduling.annotation.Async  * *.*(..))")
	public Object traceBackgroundThread(final ProceedingJoinPoint pjp) throws Throwable {
		String spanName = name(pjp);
		Span span = this.tracer.currentSpan();
		if (span == null) {
			span = this.tracer.nextSpan();
		}
		span = span.name(spanName);
		try (Tracer.SpanInScope ws = this.tracer.withSpanInScope(span.start())) {
			span.tag(CLASS_KEY, pjp.getTarget().getClass().getSimpleName());
			span.tag(METHOD_KEY, pjp.getSignature().getName());
			return pjp.proceed();
		}
		finally {
			span.finish();
		}
	}


Then AnnotationAsyncExecutionInterceptor will be called to execute this method and it's parent class
AsyncExecutionInterceptor implements invoke method to call object method. Obviously it will use 
AsyncTaskExecutor to call.

@Override
	@Nullable
	public Object invoke(final MethodInvocation invocation) throws Throwable {
		Class<?> targetClass = (invocation.getThis() != null ? AopUtils.getTargetClass(invocation.getThis()) : null);
		Method specificMethod = ClassUtils.getMostSpecificMethod(invocation.getMethod(), targetClass);
		final Method userDeclaredMethod = BridgeMethodResolver.findBridgedMethod(specificMethod);

		AsyncTaskExecutor executor = determineAsyncExecutor(userDeclaredMethod);
		if (executor == null) {
			throw new IllegalStateException(
					"No executor specified and no default executor set on AsyncExecutionInterceptor either");
		}

		Callable<Object> task = () -> {
			try {
				Object result = invocation.proceed();
				if (result instanceof Future) {
					return ((Future<?>) result).get();
				}
			}
			catch (ExecutionException ex) {
				handleError(ex.getCause(), userDeclaredMethod, invocation.getArguments());
			}
			catch (Throwable ex) {
				handleError(ex, userDeclaredMethod, invocation.getArguments());
			}
			return null;
		};

		return doSubmit(task, executor, invocation.getMethod().getReturnType());
	}
```