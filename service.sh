#!/bin/bash

SERVICE_NAME=robinye.github.io
APP_HOME=/opt/app/blog/$SERVICE_NAME
LOG_HOME=/opt/logs/blog/$SERVICE_NAME

safemkdir(){
  if [ ! -d $1 ] ; then
    mkdir -p $1
  fi
}


PID_FILE=$APP_HOME/pid/$APP_NAME.pid
dateFormat=$(date '+%Y-%m-%d')

safemkdir $APP_HOME/pid/
safemkdir $LOG_HOME/$dateFormat

started="#################################################################\n
                 $SERVICE_NAME Started At  $(date)                     \n
        #################################################################\n"

stoped="#################################################################\n
                $SERVICE_NAME Stopped At  $(date)                     \n
        ###################################################################\n"

if [ "$1" == "start" ]; then
    if [ ! -f "$PID_FILE" ]; then
        export JEKYLL_ENV=production
        echo -e $started | tee -a $LOG_HOME/$dateFormat/$SERVICE_NAME.log
        bundle exec jekyll serve 1>> '$LOG_HOME'/'$dateFormat'/'$SERVICE_NAME'.log 2>> '$LOG_HOME'/'$dateFormat'/'$SERVICE_NAME'.log 2>&1 &"'echo "$!"' > $PID_FILE
        
	sleep 20
        tail -n 500 $LOG_HOME/$dateFormat/$SERVICE_NAME.log
    else
        echo "$SERVICE_NAME service already started, please stop first and try again"
    fi
elif [ "$1" == "stop" ]; then
    if [ -f "$PID_FILE" ]; then
        echo -e $stoped | tee -a $LOG_HOME/$dateFormat/$SERVICE_NAME.log
        cat $PID_FILE | xargs sudo kill -9
        rm $PID_FILE
        echo "$SERVICE_NAME stop : [OK]"
    else
        echo "$SERVICE_NAME service not started yet, please start first and try again"
    fi
elif [ "$1" == "log" ]
    then if [ "$2" == "error" ]
      then
       tail -f $LOG_HOME/$dateFormat/$SERVICE_NAME-error.log
      else
       tail -f $LOG_HOME/$dateFormat/$SERVICE_NAME.log
       fi
else
    echo "Usage: start|stop|log/error"
fi