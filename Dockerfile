FROM node:14-alpine

# Create and set the working directory
WORKDIR /app

# Copy the application file
COPY server.js /app/

# If you have dependencies, you would run something like:
# RUN npm init -y && npm install <your-dependencies>
# For now, since we're using only 'http' which is built-in, this step is optional.
# RUN npm init -y

# Expose the port the application runs on
EXPOSE 8080

# Run the application
CMD ["node", "server.js"]

