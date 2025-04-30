# Base image
FROM node:20-alpine AS base

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source files
COPY . .

# Build the application
RUN npm run build

# Production image
FROM node:20-alpine AS production

# Set working directory
WORKDIR /app

# Copy only necessary files from the base stage
COPY --from=base /app/package*.json ./
COPY --from=base /app/.next ./.next
COPY --from=base /app/public ./public
COPY --from=base /app/node_modules ./node_modules

# Expose the port
EXPOSE 3000

# Start the server
CMD ["npm", "start"]