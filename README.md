# MongoManager
A simple [Swift](https://www.swift.org) library to interact with [MongDB Atlas](https://www.mongodb.com/atlas) via their [Data API](https://www.mongodb.com/docs/atlas/api/data-api/) for [Compute](https://github.com/swift-cloud/Compute)

This can all be easily hosted on [Swift Cloud](https://swift.cloud)

## Getting Started
Install MongoManager

```swift
.package(url: "https://github.com/SparrowTek/MongoManager", from: "1.0.4")
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

Now in your route,

```swift
struct MongoDBAtlasRoutes {
    static func regiser(_ router: Router) {
        router.post("/mongo/user", createUser)
    }
    
    static func createUser(req: IncomingRequest, res: OutgoingResponse) async throws {
        // create the Codable user object from the req body
        let user = try await req.body.decode(User.self)
        
        do {
            // use static insertOne method on MongoManager struct 
            _ = try await MongoManager.insertOne(mongoData: mongoData, collection: mongoCollection, document: user)
            // report back to API
            try await res.status(.created).send(user)
        } catch {
            // handle error
            try await res.status(.internalServerError).send(error.localizedDescription)
        }
    }
}
```

This `POST` route will create a `User` object from the request body and insert it into your MongoDB `users` collection. 
