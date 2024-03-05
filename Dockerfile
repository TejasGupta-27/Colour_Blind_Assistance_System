# Use a lighter base image
FROM ubuntu:20.04

# Set up environment variables
ENV FLUTTER_HOME=/usr/local/flutter
ENV PATH="$PATH:$FLUTTER_HOME/bin"
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y tzdata \
    openjdk-11-jdk \
    git \
    curl \
    unzip \
    xz-utils \
    libglu1-mesa \
    cmake \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

# Download and install Flutter
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME && \
    $FLUTTER_HOME/bin/flutter config --no-analytics && \
    $FLUTTER_HOME/bin/flutter precache

# Set up Android SDK
ENV ANDROID_SDK_ROOT=/usr/local/android-sdk
ENV PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools"

# Print out the values of the environment variables
RUN echo "FLUTTER_HOME: $FLUTTER_HOME" && \
    echo "ANDROID_SDK_ROOT: $ANDROID_SDK_ROOT" && \
    echo "PATH: $PATH"

# Download and install Android SDK command-line tools
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools && \
    cd $ANDROID_SDK_ROOT/cmdline-tools && \
    curl -o sdk-tools-linux.zip https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip && \
    unzip sdk-tools-linux.zip && \
    rm sdk-tools-linux.zip && \
    yes | $ANDROID_SDK_ROOT/cmdline-tools/tools/bin/sdkmanager --licenses && \
    $FLUTTER_HOME/bin/flutter doctor

# Set up the working directory
WORKDIR /app

# Copy pubspec.yaml and install dependencies
COPY pubspec.* ./
RUN $FLUTTER_HOME/bin/flutter pub get

# Copy the rest of the Flutter project
COPY . .

# Build the Flutter app
RUN $FLUTTER_HOME/bin/flutter build apk --release

# Expose any necessary ports (if your app requires)
EXPOSE 8080

# Command to run the Flutter app when the container starts
CMD ["flutter", "run", "--release"]
