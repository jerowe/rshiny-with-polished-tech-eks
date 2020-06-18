#!/bin/sh

# Make sure that we add our Polished to our /home/shiny/.Renviron
env | grep POLISHED > /home/shiny/.Renviron
chown shiny:shiny /home/shiny/.Renviron

# Make sure the directory for individual app logs exists
mkdir -p /var/log/shiny-server
chown shiny.shiny /var/log/shiny-server

if [ "$APPLICATION_LOGS_TO_STDOUT" != "false" ];
then
    # push the "real" application logs to stdout with xtail in detached mode
    exec xtail /var/log/shiny-server/ &
fi

# start shiny server
exec shiny-server 2>&1
