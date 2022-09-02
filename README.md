# MongoManager
A simple [Swift](https://www.swift.org) library to interact with [MongDB Atlas](https://www.mongodb.com/atlas) via their [Data API](https://www.mongodb.com/docs/atlas/api/data-api/) for [Compute](https://github.com/swift-cloud/Compute)

This can all be easily hosted on [Swift Cloud](https://swift.cloud)

## Getting Started
Install MongoManager

```swift
.package(name: "MongoManager", url: "https://github.com/SparrowTek/MongoManager", from: "1.0.0")
```

Add it as a target dependency

```swift
.executableTarget(
name: "MyApp",
dependencies: ["MongoManager"]
)
```

## Sample implementation

Create a global `let` property

```swift
let mongoData = MongoData(baseURL: "https://data.mongodb-api.com/app/data-abcde/endpoint/data/v1",
                          database: "database",
                          dataSource: "dataSource",
                          apiKey: try? Dictionary(name: "mongoDB").get("dataAPI"))
```

Your `baseURL` will be provided to you by MongoDB Atlas. You will configure `database` and `dataSource` in Atlas. You will create an `apiKey` when you setup the MongoDB Atlas Data API. This sample code is extracting that key from a Dictionary hosted on [Swift Cloud](https://swift.cloud).

Now in your 

```swift
struct MongoDBAtlasRoutes {
    static func regiser(_ router: Router) {
        router.get("/mongo/user", createUser)
    }
    
    static func createUser(req: IncomingRequest, res: OutgoingResponse) async throws {
        let user = User()
        let mongo = try await MongoManager.insertOne(mongoData: mongoData, collection: "users", document: user)
        try await res.status(mongo.status).send(mongo.data)
    }
}
```

This `GET` route will create a `User` object and insert it into your MongoDB `users` collection. 
