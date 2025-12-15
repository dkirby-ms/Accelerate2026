#!/bin/bash

# MongoDB Sample Data Import Script
# This script downloads and imports MongoDB sample datasets into Azure Cosmos DB for MongoDB
#
# Usage:
#   1. Get your Cosmos DB connection string from Azure Portal or run:
#      az cosmosdb keys list --name <account-name> --resource-group <resource-group> --type connection-strings --query "connectionStrings[0].connectionString" -o tsv
#   2. Run this script:
#      ./import-sample-data.sh "<your-connection-string>"

set -e

# Check if connection string is provided
if [ -z "$1" ]; then
    echo "Error: MongoDB connection string is required"
    echo "Usage: ./import-sample-data.sh \"<connection-string>\""
    echo ""
    echo "To get your connection string, run:"
    echo "  az cosmosdb keys list --name <account-name> --resource-group <resource-group> --type connection-strings --query \"connectionStrings[0].connectionString\" -o tsv"
    exit 1
fi

COSMOS_CONN="$1"

# Check if mongoimport is installed
if ! command -v mongoimport &> /dev/null; then
    echo "mongoimport not found. Installing MongoDB Database Tools..."
    
    # Download and install MongoDB Database Tools
    TOOLS_URL="https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2204-x86_64-100.9.5.deb"
    TOOLS_DEB="mongodb-database-tools.deb"
    
    wget -O "$TOOLS_DEB" "$TOOLS_URL"
    sudo dpkg -i "$TOOLS_DEB"
    rm "$TOOLS_DEB"
    
    echo "MongoDB Database Tools installed successfully!"
fi

# Create temporary directory for downloads
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "Downloading sample datasets..."

# Download sample datasets
curl -L https://raw.githubusercontent.com/neelabalan/mongodb-sample-dataset/main/sample_mflix/movies.json -o movies.json
curl -L https://raw.githubusercontent.com/neelabalan/mongodb-sample-dataset/main/sample_mflix/users.json -o users.json
curl -L https://raw.githubusercontent.com/neelabalan/mongodb-sample-dataset/main/sample_mflix/comments.json -o comments.json
curl -L https://raw.githubusercontent.com/neelabalan/mongodb-sample-dataset/main/sample_mflix/theaters.json -o theaters.json
curl -L https://raw.githubusercontent.com/neelabalan/mongodb-sample-dataset/main/sample_airbnb/listingsAndReviews.json -o listingsAndReviews.json
curl -L https://raw.githubusercontent.com/neelabalan/mongodb-sample-dataset/main/sample_supplies/sales.json -o sales.json
curl -L https://raw.githubusercontent.com/neelabalan/mongodb-sample-dataset/main/sample_restaurants/restaurants.json -o restaurants.json
curl -L https://raw.githubusercontent.com/neelabalan/mongodb-sample-dataset/main/sample_training/companies.json -o companies.json
curl -L https://raw.githubusercontent.com/neelabalan/mongodb-sample-dataset/main/sample_training/inspections.json -o inspections.json
curl -L https://raw.githubusercontent.com/neelabalan/mongodb-sample-dataset/main/sample_training/posts.json -o posts.json
curl -L https://raw.githubusercontent.com/neelabalan/mongodb-sample-dataset/main/sample_training/trips.json -o trips.json
curl -L https://raw.githubusercontent.com/neelabalan/mongodb-sample-dataset/main/sample_training/zips.json -o zips.json
curl -L https://raw.githubusercontent.com/neelabalan/mongodb-sample-dataset/main/sample_weatherdata/data.json -o weatherdata.json

echo ""
echo "Importing data into Cosmos DB..."
echo ""

# Import into Cosmos DB Mongo API
# sample_mflix database
echo "Importing sample_mflix database..."
mongoimport --uri "$COSMOS_CONN" --db sample_mflix --collection movies --file movies.json --numInsertionWorkers 1 --batchSize 1
mongoimport --uri "$COSMOS_CONN" --db sample_mflix --collection users --file users.json --numInsertionWorkers 1 --batchSize 1
mongoimport --uri "$COSMOS_CONN" --db sample_mflix --collection comments --file comments.json --numInsertionWorkers 1 --batchSize 1
mongoimport --uri "$COSMOS_CONN" --db sample_mflix --collection theaters --file theaters.json --numInsertionWorkers 1 --batchSize 1

# sample_airbnb database
echo "Importing sample_airbnb database..."
mongoimport --uri "$COSMOS_CONN" --db sample_airbnb --collection listingsAndReviews --file listingsAndReviews.json --numInsertionWorkers 1 --batchSize 1

# sample_supplies database
echo "Importing sample_supplies database..."
mongoimport --uri "$COSMOS_CONN" --db sample_supplies --collection sales --file sales.json --numInsertionWorkers 1 --batchSize 1

# sample_restaurants database
echo "Importing sample_restaurants database..."
mongoimport --uri "$COSMOS_CONN" --db sample_restaurants --collection restaurants --file restaurants.json --numInsertionWorkers 1 --batchSize 1

# sample_training database
echo "Importing sample_training database..."
mongoimport --uri "$COSMOS_CONN" --db sample_training --collection companies --file companies.json --numInsertionWorkers 1 --batchSize 1
mongoimport --uri "$COSMOS_CONN" --db sample_training --collection inspections --file inspections.json --numInsertionWorkers 1 --batchSize 1
mongoimport --uri "$COSMOS_CONN" --db sample_training --collection posts --file posts.json --numInsertionWorkers 1 --batchSize 1
mongoimport --uri "$COSMOS_CONN" --db sample_training --collection trips --file trips.json --numInsertionWorkers 1 --batchSize 1
mongoimport --uri "$COSMOS_CONN" --db sample_training --collection zips --file zips.json --numInsertionWorkers 1 --batchSize 1

# sample_weatherdata database
echo "Importing sample_weatherdata database..."
mongoimport --uri "$COSMOS_CONN" --db sample_weatherdata --collection data --file weatherdata.json --numInsertionWorkers 1 --batchSize 1

# Cleanup
cd -
rm -rf "$TEMP_DIR"

echo ""
echo "✅ Import complete!"
echo ""
echo "Imported databases:"
echo "  - sample_mflix (movies, users, comments, theaters)"
echo "  - sample_airbnb (listingsAndReviews)"
echo "  - sample_supplies (sales)"
echo "  - sample_restaurants (restaurants)"
echo "  - sample_training (companies, inspections, posts, trips, zips)"
echo "  - sample_weatherdata (data)"
