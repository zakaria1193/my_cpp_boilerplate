FROM debian:bookworm-slim

LABEL maintainer="zakaria1193@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive


# APT Update
RUN apt-get --allow-releaseinfo-change update
RUN apt-get update && apt-get upgrade -y
RUN apt-get install apt-utils

# APT install (base) packages
RUN apt-get install -y build-essential cmake libboost-all-dev pkg-config 

# APT install additional packages
RUN apt-get install -y --no-install-recommends locales

COPY ./first_setup.sh /

RUN /first_setup.sh
RUN apt-get clean

# Clean-up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Clean-up manual build(s)

# set the locale to en_US.UTF-8
RUN echo "en_US.UTF-8 UTF-8" >/etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    update-locale LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
