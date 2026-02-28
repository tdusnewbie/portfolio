# Simple Nginx stage for serving the single-page portfolio
FROM nginx:alpine

# Copy the core portfolio page
COPY index.html /usr/share/nginx/html/index.html

# Copy the assets for PDF downloads and images
COPY assets/ /usr/share/nginx/html/assets/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
