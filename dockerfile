# Use the official Flutter image as a base image
FROM cirrusci/flutter:stable

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Set environment variables
ENV FLUTTER_ROOT=/sdks/flutter
ENV PATH=$FLUTTER_ROOT/bin:$PATH

# Change ownership of the Flutter SDK directory to avoid permission issues
RUN chown -R root:root /sdks/flutter

# Add the Flutter SDK to the safe directories in Git
RUN git config --global --add safe.directory /sdks/flutter

# Get Flutter dependencies
RUN flutter pub get

# Run tests (if you have any)
# RUN flutter test

# Build the app (for Android)
RUN flutter build apk --release

# Build the app (for iOS, requires macOS and is often done on a different agent)
# RUN flutter build ios --release
