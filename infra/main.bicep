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
    name: databaseName
    parent: cosmosDbAccount
    properties: {
        resource: {
            id: databaseName
        }
        options: {}
    }
}

output accountName string = cosmosDbAccount.name
output databaseName string = databaseName
