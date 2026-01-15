# Stage 1: Build
FROM debian:bookworm-slim AS build
RUN apt-get update && apt-get install -y curl git unzip xz-utils libglu1-mesa
WORKDIR /app

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable /flutter
ENV PATH="/flutter/bin:$PATH"
RUN flutter doctor

# Copy source code
COPY . .

# Build Arguments
ARG COMMIT_HASH=dev
ARG BUILD_VERSION=1.0.0

# Install dependencies
RUN flutter pub get
RUN dart run build_runner build --delete-conflicting-outputs



# Analyze and Test
RUN flutter analyze
RUN flutter test

# Build Web
RUN flutter build web --release \
    --dart-define=COMMIT_HASH=$COMMIT_HASH \
    --dart-define=BUILD_VERSION=$BUILD_VERSION

# Stage 2: Serve
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf.template /etc/nginx/templates/default.conf.template
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
