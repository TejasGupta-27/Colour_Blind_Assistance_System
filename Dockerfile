# Use the official Flutter Docker image as the base image
FROM cirrusci/flutter:stable

# Set the working directory inside the container
WORKDIR /app

# Copy the `pubspec.yaml` and `pubspec.lock` files to leverage Docker cache
COPY pubspec.* ./

# Install dependencies
RUN flutter pub get

# Copy the rest of the application code
COPY . .

# Build the Flutter app for release
RUN flutter build apk --release

# Specify the command to run your Flutter app
CMD ["flutter", "run", "--release"]
