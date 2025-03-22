# Use the official Nginx image as the base image
FROM nginx:latest

# Copy custom configuration file (if any)
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80 to the outside world
EXPOSE 80

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
