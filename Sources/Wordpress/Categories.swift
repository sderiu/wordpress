//
//  File.swift
//  
//
//  Created by Simone Deriu on 21/12/2020.
//

import Vapor

public class Categories{
    
    var domain: String
    var request: Request
    
    init(_ req: Request) {
        self.domain = req.application.wordpress.domain
        self.request = req
    }
        
    public func list() throws -> EventLoopFuture<[WordpressCategory]>{
        let baseUrl = URI(string: "\(self.domain)\(Endpoints.categories.rawValue)")
        return self.request.client.get(baseUrl, headers: self.request.headers).flatMapThrowing{ response in
            guard [.ok].contains(response.status) else {
                throw Abort(response.status)
            }
            return try response.content.decode([WordpressCategory].self)
        }
    }
    
    public func get(id: Int) throws -> EventLoopFuture<WordpressCategory>{
        let baseUrl = URI(string: "\(self.domain)\(Endpoints.categories.rawValue)")
        return self.request.client.get(baseUrl, headers: self.request.headers).flatMapThrowing{ response in
            guard [.ok].contains(response.status) else {
                throw Abort(response.status)
            }
            return try response.content.decode(WordpressCategory.self)
        }
    }
    
    public func create(name: String,
                       slug: String?,
                       count: Int?,
                       description: String?,
                       link: String?,
                       taxonomy: String?,
                       parent: Int?) throws -> EventLoopFuture<WordpressCategory>{
        let baseUrl = URI(string: "\(self.domain)\(Endpoints.categories.rawValue)")
        return self.request.client.post(baseUrl, headers: self.request.headers, beforeSend: { (request) in
            let category = WordpressCategory(name: name,
                                             slug: slug,
                                             count: count,
                                             description: description,
                                             link: link,
                                             taxonomy: taxonomy,
                                             parent: parent)
            try request.content.encode(category)
        }).flatMapThrowing{ response in
            guard [.ok].contains(response.status) else {
                throw Abort(response.status)
            }
            return try response.content.decode(WordpressCategory.self)
        }
    }
    
    public func delete(id: Int, force: Bool? = false) throws -> EventLoopFuture<DeletedCategory>{
        let baseUrl = URI(string: "\(self.domain)\(Endpoints.categories.rawValue)")
        return self.request.client.get(baseUrl, headers: self.request.headers).flatMapThrowing{ response in
            guard [.ok].contains(response.status) else {
                throw Abort(response.status)
            }
            return try response.content.decode(DeletedCategory.self)
        }
    }
    
}

public struct WordpressCategory: Content{
    public let id: Int?
    public let name: String?
    public let count: Int?
    public let slug: String?
    public let description: String?
    public let link: String?
    public let taxonomy: String?
    public let parent: Int?
    
    public init(id: Int? = nil,
                name: String? = nil,
                slug: String? = nil,
                count: Int? = nil,
                description: String? = nil,
                link: String? = nil,
                taxonomy: String? = nil,
                parent: Int? = nil){
        self.id = id
        self.name = name
        self.count = count
        self.slug = slug
        self.description = description
        self.link = link
        self.taxonomy = taxonomy
        self.parent = parent
    }
}

public struct DeletedCategory: Content{
    public let deleted: Bool?
    public let previous: WordpressCategory?
}
