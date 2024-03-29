# Use an official Node.js runtime as the base image
FROM node:latest AS build

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json (if available) to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Build the React app for production
RUN npm run build

FROM nginx:1.13-alpine
COPY --from=build /app/build /usr/share/nginx/html

COPY <<EOF /start.sh
echo "{\\"API_URL\\": \\"\$API_URL\\"}" > /usr/share/nginx/html/config.json
echo "Starting..."
nginx -g 'daemon off;'
EOF

CMD ["sh", "/start.sh"]