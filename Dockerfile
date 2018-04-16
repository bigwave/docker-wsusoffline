FROM phusion/baseimage:latest
MAINTAINER bigwave

RUN apt-get update
RUN apt-get install -y wget cabextract hashdeep xmlstarlet trash-cli unzip iputils-ping genisoimage
RUN apt-get clean -y
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV SYSTEMS="w100-x64"
#ENV OFFICE="o2k16-x64"
ENV OFFICE="" 
ENV LANGUAGE="enu"
#ENV PARAMS="-includesp -includecpp -includedotnet -includewddefs8"
ENV PARAMS="-includesp -includecpp -includedotnet"
ENV ISO="no"
ENV SLEEP=48h

# WSUSOFFLINE
ADD update.sh /wsus/
ADD run.sh /wsus/
ADD download.sh /wsus/
RUN mkdir /etc/service/wsusoffline
RUN ln -s /wsus/run.sh /etc/service/wsusoffline/run
RUN ln -s /wsus/wsusoffline/client /client
VOLUME ["/client"]

ADD StaticDownloadLink-recent.txt /wsus/static/
RUN cp /wsus/static/StaticDownloadLink-recent.txt /wsus/static/StaticDownloadLink-this.txt
ADD wsusoffline1121.zip /wsus/
RUN unzip -q /wsus/wsusoffline1121.zip -d /wsus/
RUN find /wsus/ -name '*.bash' -print0 | xargs -0 chmod +x
RUN find /wsus/ -name '*.sh' -print0 | xargs -0 chmod +x
RUN find /wsus/ -name '*.exe' -print0 | xargs -0 chmod +x

#Enable SSH
RUN rm -f /etc/service/sshd/down
RUN /usr/sbin/enable_insecure_key
EXPOSE 22

CMD ["/sbin/my_init"]
