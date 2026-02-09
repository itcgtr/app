# Use lightweight nginx
FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy Flutter web build
COPY build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]


# docker build -t flutter-web .
# docker run -d -p 8080:80 flutter-web


# CONTAINER=mongodb_dev
# docker stop $CONTAINER
# docker rm -f $CONTAINER

