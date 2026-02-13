FROM ubuntu:latest

RUN apt update && apt upgrade -y



# # Remove default nginx website
# RUN rm -rf /usr/share/nginx/html/*

# # Copy Flutter web build
# COPY build/web /usr/share/nginx/html

# # Expose port 80
EXPOSE 22

# # Install nginx

# # Start nginx
# CMD ["nginx", "-g", "daemon off;"]



