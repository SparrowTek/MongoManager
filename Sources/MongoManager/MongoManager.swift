import Foundation
import Compute

/// An object passed as a parameter to all `MongoManager` methods with infomation about your MongoDB Atlas instance
public struct MongoData {
    public let baseURL: String
    public let database: String
    public let dataSource: String
    public let apiKey: String?
    public let contentType: String
    public let accessControlRequestHeaders: String
    public let accept: String
    
    public init(baseURL: String,
                database: String,
                dataSource: String,
                apiKey: String?,
                contentType: String = "application/json",
                accessControlRequestHeaders: String = "*",
                accept: String = "application/json") {
        self.baseURL = baseURL
        self.database = database
        self.dataSource = dataSource
        self.apiKey = apiKey
        self.contentType = contentType
        self.accessControlRequestHeaders = accessControlRequestHeaders
        self.accept = accept
    }
}

public struct MongoManager {
    
    /// unwrap your `Codable` object from the MongoDB Document object
    public static func unwrapDocument<C: Codable>(_ document: MongoDocument<C>) -> C {
        document.document
    }
    
    private static func headers(for data: MongoData) -> [String : String] {
        [
            "Content-Type" : data.contentType,
            "Access-Control-Request-Headers" : data.accessControlRequestHeaders,
            "Accept" : data.accessControlRequestHeaders,
            "api-key" : data.apiKey ?? ""
        ]
    }
    
    /// Query the MongoDB Data API findOne action
    /// - Parameter mongoData: A `MongoData` object with all the credentials for your MongoDB Atlas instance
    /// - Parameter collection: A `String` of the MongoDB collection name to be used
    /// - Parameter filter: An optional `Codable` object to be passed as a filter
    /// - Parameter projection: An optional `Codable` object to be passed as a projection
    /// - Returns a `FetchResponse` from the `Compute` framework
    public static func findOne<F: Codable, P: Codable>(mongoData: MongoData, collection: String, filter: F? = nil, projection: P? = nil) async throws -> FetchResponse {
        try await fetch("\(mongoData.baseURL)/action/findOne", .options(
            method: .post,
            body: .json(FindOneRequest<F, P>(collection: collection, database: mongoData.database, dataSource: mongoData.dataSource, filter: filter, projection: projection)),
            headers: headers(for: mongoData)
        ))
    }
    
    /// Query the MongoDB Data API find action
    /// - Parameter mongoData: A `MongoData` object with all the credentials for your MongoDB Atlas instance
    /// - Parameter collection: A `String` of the MongoDB collection name to be used
    /// - Parameter filter: An optional `Codable` object to be passed as a filter
    /// - Parameter projection: An optional`Codable` object to be passed as a projection
    /// - Parameter sort: An optional `Codable` object to be passed as a sort
    /// - Parameter limit: An optional `Int` to be passed as a limit
    /// - Parameter skip: An optional `Int` to be passed as a skip
    /// - Returns a `FetchResponse` from the `Compute` framework
    public static func find<F: Codable, P: Codable, S: Codable>(mongoData: MongoData,
                                                                collection: String,
                                                                filter: F? = nil,
                                                                projection: P? = nil,
                                                                sort: S? = nil,
                                                                limit: Int? = nil,
                                                                skip: Int? = nil) async throws -> FetchResponse {
        try await fetch("\(mongoData.baseURL)/action/find", .options(
            method: .post,
            body: .json(FindRequest<F, P, S>(collection: collection, database: mongoData.database, dataSource: mongoData.dataSource, filter: filter, projection: projection, sort: sort, limit: limit, skip: skip)),
            headers: headers(for: mongoData)
        ))
    }
    
    /// Query the MongoDB Data API insertOne action
    /// - Parameter mongoData: A `MongoData` object with all the credentials for your MongoDB Atlas instance
    /// - Parameter collection: A `String` of the MongoDB collection name to be used
    /// - Parameter document: A `Codable` object to be passed as a document
    /// - Returns a `FetchResponse` from the `Compute` framework
    public static func insertOne<C: Codable>(mongoData: MongoData, collection: String, document: C) async throws -> FetchResponse{
        try await fetch("\(mongoData.baseURL)/action/insertOne", .options(
            method: .post,
            body: .json(InsertOneRequest(collection: collection, database: mongoData.database, dataSource: mongoData.dataSource, document: document)),
            headers: headers(for: mongoData)
        ))
    }
    
    /// Query the MongoDB Data API insertMany action
    /// - Parameter mongoData: A `MongoData` object with all the credentials for your MongoDB Atlas instance
    /// - Parameter collection: A `String` of the MongoDB collection name to be used
    /// - Parameter documents: An array of `Codable` objects to be passed as documents
    /// - Returns a `FetchResponse` from the `Compute` framework
    public static func insertMany<C: Codable>(mongoData: MongoData, collection: String, documents: [C]) async throws -> FetchResponse{
        try await fetch("\(mongoData.baseURL)/action/insertMany", .options(
            method: .post,
            body: .json(InsertRequest(collection: collection, database: mongoData.database, dataSource: mongoData.dataSource, documents: documents)),
            headers: headers(for: mongoData)
        ))
    }
    
    ///  Query the MongoDB Data API updateOne action
    /// - Parameter mongoData: A `MongoData` object with all the credentials for your MongoDB Atlas instance
    /// - Parameter collection: A `String` of the MongoDB collection name to be used
    /// - Parameter filter: A `Codable` object to be passed as a filter
    /// - Parameter update: A `Codable` object to be passed as an update
    /// - Parameter upsert: An optional `Bool` to be passed as an upsert
    /// - Returns a `FetchResponse` from the `Compute` framework
    public static func updateOne<F: Codable, U: Codable>(mongoData: MongoData, collection: String, filter: F, update: U, upsert: Bool? = nil) async throws -> FetchResponse {
        try await fetch("\(mongoData.baseURL)/action/updateOne", .options(
            method: .post,
            body: .json(UpdateRequest<F, U>(collection: collection, database: mongoData.database, dataSource: mongoData.dataSource, filter: filter, update: update, upsert: upsert)),
            headers: headers(for: mongoData)
        ))
    }
    
    /// Query the MongoDB Data API updateMany action
    /// - Parameter mongoData: A `MongoData` object with all the credentials for your MongoDB Atlas instance
    /// - Parameter collection: A `String` of the MongoDB collection name to be used
    /// - Parameter filter: A `Codable` object to be passed as a filter
    /// - Parameter update: A `Codable` object to be passed as an update
    /// - Parameter upsert: An optional `Bool` to be passed as an upsert
    /// - Returns a `FetchResponse` from the `Compute` framework
    public static func updateMany<F: Codable, U: Codable>(mongoData: MongoData, collection: String, filter: F, update: U, upsert: Bool? = nil) async throws -> FetchResponse {
        try await fetch("\(mongoData.baseURL)/action/updateMany", .options(
            method: .post,
            body: .json(UpdateRequest<F, U>(collection: collection, database: mongoData.database, dataSource: mongoData.dataSource, filter: filter, update: update, upsert: upsert)),
            headers: headers(for: mongoData)
        ))
    }
    
    /// Query the MongoDB Data API replaceOne action
    /// - Parameter mongoData: A `MongoData` object with all the credentials for your MongoDB Atlas instance
    /// - Parameter collection: A `String` of the MongoDB collection name to be used
    /// - Parameter filter: A `Codable` object to be passed as a filter
    /// - Parameter replacement: A `Codable` object to be passed as the replacement
    /// - Parameter upsert: An optional `Bool` to be passed as an upsert
    /// - Returns a `FetchResponse` from the `Compute` framework
    public static func replaceOne<F: Codable, R: Codable>(mongoData: MongoData, collection: String, filter: F, replacement: R, upsert: Bool? = nil) async throws -> FetchResponse {
        try await fetch("\(mongoData.baseURL)/action/replaceOne", .options(
            method: .post,
            body: .json(ReplaceRequest<F, R>(collection: collection, database: mongoData.database, dataSource: mongoData.dataSource, filter: filter, replacement: replacement, upsert: upsert)),
            headers: headers(for: mongoData)
        ))
    }
    
    /// Query the MongoDB Data API deleteOne action
    /// - Parameter mongoData: A `MongoData` object with all the credentials for your MongoDB Atlas instance
    /// - Parameter collection: A `String` of the MongoDB collection name to be used
    /// - Parameter filter: A `Codable` object to be passed as a filter
    /// - Returns a `FetchResponse` from the `Compute` framework
    public static func deleteOne<F: Codable>(mongoData: MongoData, collection: String, filter: F) async throws -> FetchResponse {
        try await fetch("\(mongoData.baseURL)/action/deleteOne", .options(
            method: .post,
            body: .json(DeleteRequest<F>(collection: collection, database: mongoData.database, dataSource: mongoData.dataSource, filter: filter)),
            headers: headers(for: mongoData)
        ))
    }
    
    /// Query the MongoDB Data API aggregate action
    /// - Parameter mongoData: A `MongoData` object with all the credentials for your MongoDB Atlas instance
    /// - Parameter collection: A `String` of the MongoDB collection name to be used
    /// - Parameter pipeline: An array of `Codable` objects to be passed as a pipeline
    /// - Returns a `FetchResponse` from the `Compute` framework
    public static func aggregate<P: Codable>(mongoData: MongoData, collection: String, pipeline: [P]) async throws -> FetchResponse {
        try await fetch("\(mongoData.baseURL)/action/aggregate", .options(
            method: .post,
            body: .json(AggregateRequest<P>(collection: collection, database: mongoData.database, dataSource: mongoData.dataSource, pipeline: pipeline)),
            headers: headers(for: mongoData)
        ))
    }
    
    // MARK: Codable objects
    public struct MongoDocument<C: Codable>: Codable {
        let document: C
    }
    
    struct InsertOneRequest<C: Codable>: Codable {
        let collection: String
        let database: String
        let dataSource: String
        let document: C
    }
    
    struct InsertRequest<C: Codable>: Codable {
        let collection: String
        let database: String
        let dataSource: String
        let documents: [C]
    }
    
    struct FindOneRequest<F: Codable, P: Codable>: Codable {
        let collection: String
        let database: String
        let dataSource: String
        let filter: F?
        let projection: P?
    }
    
    struct FindRequest<F: Codable, P: Codable, S: Codable>: Codable {
        let collection: String
        let database: String
        let dataSource: String
        let filter: F?
        let projection: P?
        let sort: S?
        let limit: Int?
        let skip: Int?
    }
    
    struct UpdateRequest<F: Codable, U: Codable>: Codable {
        let collection: String
        let database: String
        let dataSource: String
        let filter: F
        let update: U
        let upsert: Bool?
    }
    
    struct ReplaceRequest<F: Codable, R: Codable>: Codable {
        let collection: String
        let database: String
        let dataSource: String
        let filter: F
        let replacement: R
        let upsert: Bool?
    }
    
    struct DeleteRequest<F: Codable>: Codable {
        let collection: String
        let database: String
        let dataSource: String
        let filter: F
    }
    
    struct AggregateRequest<P: Codable>: Codable {
        let collection: String
        let database: String
        let dataSource: String
        let pipeline: [P]
    }
}

