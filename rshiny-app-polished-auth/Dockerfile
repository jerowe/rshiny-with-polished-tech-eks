# Dockerfile
FROM rocker/shiny:4.0.0

RUN apt-get update && apt-get install -y \
    libssl-dev
    
#RUN R -e "install.packages('devtools')"
RUN R -e "install.packages('remotes')"
RUN R -e "remotes::install_github('tychobra/polished')"
RUN rm -rf /srv/shiny-server/*
COPY app.R /srv/shiny-server/app.R

COPY shiny-server.sh /usr/bin/shiny-server.sh
CMD ["/usr/bin/shiny-server.sh"]
