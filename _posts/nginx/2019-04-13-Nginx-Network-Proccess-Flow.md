---
layout: post
title: "Nginx Network Process Flow"
date: 2019-04-13 17:50:00 +0800
comments: true
categories: "Nginx"
---

This article will describe how nginx network process works.

##### Nginx Call Flow Diagram 


![](/images/blog/nginx/nginx-network-proccess.png)


##### Nginx Call Flow Functions

(1).  main()
 
main() in "nginx.c" function will be called to startup nginx proccess. 
- It will call ngx_init_cycle() to init nginx process. 
- It will call ngx_master_process_cycle() to fork worker processes.

```
int ngx_cdecl
main(int argc, char *const *argv){
......
    cycle = ngx_init_cycle(&init_cycle);
    if (cycle == NULL) {
        if (ngx_test_config) {
            ngx_log_stderr(0, "configuration file %s test failed",
                           init_cycle.conf_file.data);
        }

        return 1;
    }
}
```

```
ngx_use_stderr = 0;
if (ngx_process == NGX_PROCESS_SINGLE) {
    ngx_single_process_cycle(cycle);
} else {
    *ngx_master_process_cycle(cycle);*
}
```

(2).  ngx_init_cycle()

ngx_init_cycle() in "ngx_cycle.c" function will be called to init nginx process including load configuration, network bind and listen, init connection memory pool etc. 
- It will call ngx_open_listening_sockets() to bind and listen port for network handle.

```
    if (*ngx_open_listening_sockets(cycle)* != NGX_OK) {
        goto failed;
    }

    if (!ngx_test_config) {
        ngx_configure_listening_sockets(cycle);
    }
```

(3).  ngx_open_listening_sockets() 

ngx_open_listening_sockets() in "ngx_connection.c" will be called to bind and listen port for network handle, it will bind and listen port and save socket listen file descritors ngx_listening_t list. Number of listening list depends on number of workers configured.  Since nginx 1.9.1(Linux Kernel >=3.9.0), it support SO_REUSEPORT flag and multiple socket listen fd can bind to same addr and port. 

```
if (setsockopt(ls[i].fd, SOL_SOCKET, SO_REUSEPORT_LB,
               (const void *) &reuseport, sizeof(int))
    == -1)
{
    ngx_log_error(NGX_LOG_ALERT, cycle->log, ngx_socket_errno,
                  "setsockopt(SO_REUSEPORT_LB) %V failed, "
                  "ignored",
                  &ls[i].addr_text);
}

...

if (bind(s, ls[i].sockaddr, ls[i].socklen) == -1) {
                err = ngx_socket_errno;

                if (err != NGX_EADDRINUSE || !ngx_test_config) {
                    ngx_log_error(NGX_LOG_EMERG, log, err,
                                  "bind() to %V failed", &ls[i].addr_text);
                }

                if (ngx_close_socket(s) == -1) {
                    ngx_log_error(NGX_LOG_EMERG, log, ngx_socket_errno,
                                  ngx_close_socket_n " %V failed",
                                  &ls[i].addr_text);
                }

                if (err != NGX_EADDRINUSE) {
                    return NGX_ERROR;
                }

                if (!ngx_test_config) {
                    failed = 1;
                }

                continue;
            }

...

if (listen(s, ls[i].backlog) == -1) {
                err = ngx_socket_errno;

                /*
                 * on OpenVZ after suspend/resume EADDRINUSE
                 * may be returned by listen() instead of bind(), see
                 * https://bugzilla.openvz.org/show_bug.cgi?id=2470
                 */

                if (err != NGX_EADDRINUSE || !ngx_test_config) {
                    ngx_log_error(NGX_LOG_EMERG, log, err,
                                  "listen() to %V, backlog %d failed",
                                  &ls[i].addr_text, ls[i].backlog);
                }

                if (ngx_close_socket(s) == -1) {
                    ngx_log_error(NGX_LOG_EMERG, log, ngx_socket_errno,
                                  ngx_close_socket_n " %V failed",
                                  &ls[i].addr_text);
                }

                if (err != NGX_EADDRINUSE) {
                    return NGX_ERROR;
                }

                if (!ngx_test_config) {
                    failed = 1;
                }

                continue;
            }

```

(4).  ngx_master_process_cycle()

ngx_master_process_cycle() in "ngx_process_cycle.c" will be called to init worker processes. 

```
ccf = (ngx_core_conf_t *) ngx_get_conf(cycle->conf_ctx, ngx_core_module);
*ngx_start_worker_processes*(cycle, ccf->worker_processes,
                           NGX_PROCESS_RESPAWN);
ngx_start_cache_manager_processes(cycle, 0);
```

(5).  ngx_start_worker_processes()

ngx_start_worker_processes() in "unix/ngx_process_cycle.c" will be called to init worker processes depends on now many workers configured. 
```
ch.command = NGX_CMD_OPEN_CHANNEL;
for (i = 0; i < n; i++) {
    *ngx_spawn_process*(cycle, ngx_worker_process_cycle,
                      (void *) (intptr_t) i, "worker process", type);
    ch.pid = ngx_processes[ngx_process_slot].pid;
    ch.slot = ngx_process_slot;
    ch.fd = ngx_processes[ngx_process_slot].channel[0];
    ngx_pass_open_channel(cycle, &ch);
```

(6).  ngx_spawn_process()

ngx_spawn_process() in "unix/ngx_process_cycle.c" will be called to fork worker process, and worker process start up. 

```
pid = fork();
switch (pid) {
case -1:
    ngx_log_error(NGX_LOG_ALERT, cycle->log, ngx_errno,
                  "fork() failed while spawning \"%s\"", name);
    ngx_close_channel(ngx_processes[s].channel, cycle->log);
    return NGX_INVALID_PID;
case 0:
    ngx_parent = ngx_pid;
    ngx_pid = ngx_getpid();
    proc(cycle, data);
    break;
default:
    break;
}
```

(7).  ngx_worker_process_cycle()

ngx_worker_process_cycle() in "unix/ngx_process_cycle.c" will be called to accept connections and handle requests and responses.

```
ngx_worker_process_init(cycle, worker);
ngx_setproctitle("worker process");
for ( ;; ) {
    if (ngx_exiting) {
        if (ngx_event_no_timers_left() == NGX_OK) {
            ngx_log_error(NGX_LOG_NOTICE, cycle->log, 0, "exiting");
            ngx_worker_process_exit(cycle);
        }
    }
    ngx_log_debug0(NGX_LOG_DEBUG_EVENT, cycle->log, 0, "worker cycle");
    *ngx_process_events_and_timers*(cycle);

...

}
```

(8).  ngx_process_events_and_timers()

ngx_process_events_and_timers() in "ngx_event.c" will be called to accept connections and request messages. Please note that "ngx_process_events()" is hook function and it will call ngx_epoll_process_events().

```
if (ngx_use_accept_mutex) {
    if (ngx_accept_disabled > 0) {
        ngx_accept_disabled--;
    } else {
        if (ngx_trylock_accept_mutex(cycle) == NGX_ERROR) {
            return;
        }
        if (ngx_accept_mutex_held) {
            flags |= NGX_POST_EVENTS;
        } else {
            if (timer == NGX_TIMER_INFINITE
                || timer > ngx_accept_mutex_delay)
            {
                timer = ngx_accept_mutex_delay;
            }
        }
    }
}
delta = ngx_current_msec;
(void) *ngx_process_events*(cycle, timer, flags);
delta = ngx_current_msec - delta;
```

(9).  ngx_epoll_process_events()

ngx_epoll_process_events() in "ngx_epoll_module.c" will be called to accept connection and read/write TCP messages.

```
events = epoll_wait(ep, event_list, (int) nevents, timer);
err = (events == -1) ? ngx_errno : 0;
if (flags & NGX_UPDATE_TIME || ngx_event_timer_alarm) {
    ngx_time_update();
}
...
```






 


