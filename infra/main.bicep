@description('Name of the Azure Cosmos DB account')
param accountName string = 'mongodb-account-${uniqueString(resourceGroup().id)}'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('The name of the database')
param databaseName string = 'myMongoDatabase'

resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2025-10-15' = {
    name: accountName
    location: location
    kind: 'MongoDB'
    properties: {
        databaseAccountOfferType: 'Standard'
        locations: [
            {
                locationName: location
                failoverPriority: 0
                isZoneRedundant: false
            }
        ]
        capabilities: [
            {
                name: 'EnableMongo'
            }
        ]
        apiProperties: {
            serverVersion: '7.0'
        }
    }
}

resource mongoDatabase 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2025-10-15' = {
    name: '${cosmosDbAccount.name}/${databaseName}'
    properties: {
        resource: {
            id: databaseName
        }
        options: {}
    }
}

resource importSampleData 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
    name: 'importSampleData'
    location: location
    kind: 'AzureCLI'
    properties: {
        azCliVersion: '2.30.0'
        timeout: 'PT30M'
        retentionInterval: 'P1D'
        environmentVariables: [
            {
                name: 'COSMOS_CONN'
                secureValue: cosmosDbAccount.listConnectionStrings().connectionStrings[0].connectionString
            }
        ]
        scriptContent: '''
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

          # Install Mongo tools (Ubuntu-based script env)
          apt-get update
          apt-get install -y mongodb-clients

          # Import into Cosmos DB Mongo API
          # sample_mflix database
          mongoimport --uri "$COSMOS_CONN" --db sample_mflix --collection movies --file movies.json --jsonArray
          mongoimport --uri "$COSMOS_CONN" --db sample_mflix --collection users --file users.json --jsonArray
          mongoimport --uri "$COSMOS_CONN" --db sample_mflix --collection comments --file comments.json --jsonArray
          mongoimport --uri "$COSMOS_CONN" --db sample_mflix --collection theaters --file theaters.json --jsonArray
          
          # sample_airbnb database
          mongoimport --uri "$COSMOS_CONN" --db sample_airbnb --collection listingsAndReviews --file listingsAndReviews.json --jsonArray
          
          # sample_supplies database
          mongoimport --uri "$COSMOS_CONN" --db sample_supplies --collection sales --file sales.json --jsonArray
          
          # sample_restaurants database
          mongoimport --uri "$COSMOS_CONN" --db sample_restaurants --collection restaurants --file restaurants.json --jsonArray
          
          # sample_training database
          mongoimport --uri "$COSMOS_CONN" --db sample_training --collection companies --file companies.json --jsonArray
          mongoimport --uri "$COSMOS_CONN" --db sample_training --collection inspections --file inspections.json --jsonArray
          mongoimport --uri "$COSMOS_CONN" --db sample_training --collection posts --file posts.json --jsonArray
          mongoimport --uri "$COSMOS_CONN" --db sample_training --collection trips --file trips.json --jsonArray
          mongoimport --uri "$COSMOS_CONN" --db sample_training --collection zips --file zips.json --jsonArray
          
          # sample_weatherdata database
          mongoimport --uri "$COSMOS_CONN" --db sample_weatherdata --collection data --file weatherdata.json --jsonArray
        '''
        cleanupPreference: 'OnSuccess'
        forceUpdateTag: '1'
    }
    dependsOn: [
        mongoDatabase
    ]
}

output connectionString string = cosmosDbAccount.properties.documentEndpoint
