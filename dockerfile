# Use the official Flutter image as the base image
FROM cirrusci/flutter:latest

# Install additional dependencies for Android and iOS
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

# Set the working directory
WORKDIR /app

# Create a non-root user and set permissions
RUN useradd -ms /bin/bash flutteruser
RUN chown -R flutteruser:flutteruser /sdks/flutter

# Switch to the new user
USER flutteruser

# Copy the current directory contents into the container at /app
COPY . /app

# Run the Flutter doctor command to verify the installation
RUN flutter doctor

# Expose any necessary ports (optional)
EXPOSE 8080

# Set the default command to run when starting the container
CMD ["bash"]
