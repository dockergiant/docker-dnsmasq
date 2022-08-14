FROM debian:bullseye-slim
LABEL maintainer="rick@dockergiant.com"

ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETVARIANT

# webproc release settings
ENV WEBPROC_VERSION 0.4.0
ENV WEBPROC_URL https://github.com/jpillora/webproc/releases/download/v${WEBPROC_VERSION}/webproc_${WEBPROC_VERSION}_linux_${TARGETARCH}.gz
# fetch dnsmasq and webproc binary
RUN apt-get update \
	&& apt-get install -y dnsmasq curl \
	&& curl -sL $WEBPROC_URL | gzip -d - > /usr/local/bin/webproc \
	&& chmod +x /usr/local/bin/webproc \
    && rm -rf /var/lib/apt/lists/*
#configure dnsmasq
RUN mkdir -p /etc/default/
RUN echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq
COPY dnsmasq.conf /etc/dnsmasq.conf
#run!
ENTRYPOINT ["webproc","--configuration-file","/etc/dnsmasq.conf","--","dnsmasq","--no-daemon"]
