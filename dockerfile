FROM cirrusci/flutter:latest

RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    lib32stdc++6 \
    libglu1-mesa \
    openjdk-11-jdk \
    && apt-get clean

# Set environment variables for Android SDK
ENV ANDROID_SDK_ROOT /opt/android-sdk
ENV PATH ${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/emulator

# Install Android SDK components
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" \
               "platforms;android-30" \
               "build-tools;30.0.3"

# Install CocoaPods for iOS dependencies
RUN gem install cocoapods


RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


WORKDIR /app

COPY . /app

RUN flutter doctor


EXPOSE 8080


CMD ["bash"]
