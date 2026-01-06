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

# Build Web
RUN flutter build web --release

# Stage 2: Serve
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
