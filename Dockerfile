FROM ubuntu:18.04

## Setup Basic Ubuntu 18.04
ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 && \
    apt-get update -yqq && \
    apt-get install -y curl expect git libc6:i386 libgcc1:i386 libncurses5:i386 libstdc++6:i386 zlib1g:i386 openjdk-8-jdk openjdk-11-jdk wget unzip vim python2.7 && \
    apt-get clean
    
# create a link to python
RUN ln -s /usr/bin/python2.7 /usr/bin/python

## Setup Android command line tools and folders.
## Note: in newer command line tools, must move all of extracted contents
##       to a folder named 'latest'.
RUN mkdir -p /opt/android-sdk-linux/cmdline-tools

## Change working directory to /opt/android-sdk-linux/cmdline-tools
WORKDIR /opt/android-sdk-linux/cmdline-tools

## Download latest command line tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-7302050_latest.zip
RUN unzip commandlinetools-linux-7302050_latest.zip
RUN mv cmdline-tools tools

## Change working directory to /opt/android-sdk-linux/cmdline-tools
WORKDIR /opt/android-sdk-linux

## Setup Android environment variables
ENV ANDROID_HOME      /opt/android-sdk-linux
ENV ANDROID_SDK_HOME  ${ANDROID_HOME}
ENV ANDROID_SDK_ROOT  ${ANDROID_HOME}
ENV ANDROID_SDK       ${ANDROID_HOME}

ENV PATH "${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin"
ENV PATH "${PATH}:${ANDROID_HOME}/cmdline-tools/tools/bin"
ENV PATH "${PATH}:${ANDROID_HOME}/tools/bin"
ENV PATH "${PATH}:${ANDROID_HOME}/build-tools/31.0.0"
ENV PATH "${PATH}:${ANDROID_HOME}/platform-tools"
ENV PATH "${PATH}:${ANDROID_HOME}/emulator"
ENV PATH "${PATH}:${ANDROID_HOME}/bin"


# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/

## Precreate the license
RUN mkdir licenses
RUN echo "\n24333f8a63b6825ea9c5514f83c2829b004d1fee" > licenses/android-sdk-license

## Install
RUN /opt/android-sdk-linux/cmdline-tools/tools/bin/sdkmanager "cmdline-tools;latest"
RUN /opt/android-sdk-linux/cmdline-tools/tools/bin/sdkmanager "build-tools;30.0.3"
RUN /opt/android-sdk-linux/cmdline-tools/tools/bin/sdkmanager "platform-tools"
RUN /opt/android-sdk-linux/cmdline-tools/tools/bin/sdkmanager "platforms;android-31"
RUN /opt/android-sdk-linux/cmdline-tools/tools/bin/sdkmanager "ndk-bundle"
RUN /opt/android-sdk-linux/cmdline-tools/tools/bin/sdkmanager "cmake;3.18.1"
