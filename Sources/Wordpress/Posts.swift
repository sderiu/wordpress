//
//  File.swift
//  
//
//  Created by Simone Deriu on 20/12/2020.
//

import Vapor

public class Posts: Wordpress {
    
    public func list() throws -> EventLoopFuture<[WordpressPost]>{
        let url = URI(string:"\(self.domain)\(Endpoints.posts.rawValue)")
        return self.request.client
            .get(url, headers: self.request.headers).flatMapThrowing{ response in
                guard response.status == .ok else {
                    self.request.logger.debug("\(response.content)")
                    throw Abort(response.status)
                }
                return try response.content.decode([WordpressPost].self)
            }
    }
    
    public func get(id: Int) throws -> EventLoopFuture<WordpressPost>{
        let url = URI(string:"\(self.domain)\(Endpoints.posts.rawValue)/\(id)")
        return self.request.client
            .get(url, headers: self.request.headers).flatMapThrowing{ response in
                guard response.status == .ok else {
                    self.request.logger.debug("\(response.content)")
                    throw Abort(response.status)
                }
                return try response.content.decode(WordpressPost.self)
            }
    }

    public func create(id: Int? = nil,
                       password: String? = nil,
                       modified: Date? = nil,
                       modified_gmt: Date? = nil,
                       slug: String? = nil,
                       status: String? = nil,
                       type: String? = nil,
                       link: String? = nil,
                       title: String,
                       content: String? = nil,
                       excerpt: String? = nil,
                       author: Int? = nil,
                       featured_media: Int? = nil,
                       comment_status: String? = nil,
                       ping_status: String? = nil,
                       sticky: Bool? = nil,
                       template: String? = nil,
                       format: String? = nil,
                       categories: [Int]? = nil,
                       tags: [Int]? = nil) throws
    -> EventLoopFuture<WordpressPost> {
        let post = WordpressPost(id:id,
                                 password: password,
                                 slug: slug,
                                 status: status,
                                 type: type,
                                 link: link,
                                 title: Object(rendered: title),
                                 content: Object(rendered: content),
                                 excerpt: Object(rendered: excerpt),
                                 author: author,
                                 featured_media: featured_media,
                                 comment_status: comment_status,
                                 ping_status: ping_status,
                                 sticky: sticky,
                                 template: template,
                                 format: format,
                                 categories: categories,
                                 tags: tags)
        let url = URI(string:"\(self.domain)\(Endpoints.posts.rawValue)")
        return self.request.client
            .post(url, headers: self.request.headers) { (request) in
                try request.content.encode(post)
            }.flatMapThrowing{ response in
                guard [.ok, .created].contains(response.status) else {
                    throw Abort(response.status)
                }
                return try response.content.decode(WordpressPost.self)
            }
    }
    
    public func update(id: Int,
                       password: String? = nil,
                       modified: Date? = nil,
                       modified_gmt: Date? = nil,
                       slug: String? = nil,
                       status: String? = nil,
                       type: String? = nil,
                       link: String? = nil,
                       title: String? = nil,
                       content: String? = nil,
                       excerpt: String? = nil,
                       author: Int? = nil,
                       featured_media: Int? = nil,
                       comment_status: String? = nil,
                       ping_status: String? = nil,
                       sticky: Bool? = nil,
                       template: String? = nil,
                       format: String? = nil,
                       categories: [Int]? = nil,
                       tags: [Int]? = nil) throws
    -> EventLoopFuture<WordpressPost> {
        let post = WordpressPost(id:id,
                                 password: password,
                                 slug: slug,
                                 status: status,
                                 type: type,
                                 link: link,
                                 title: Object(rendered: title),
                                 content: Object(rendered: content),
                                 excerpt: Object(rendered: excerpt),
                                 author: author,
                                 featured_media: featured_media,
                                 comment_status: comment_status,
                                 ping_status: ping_status,
                                 sticky: sticky,
                                 template: template,
                                 format: format,
                                 categories: categories,
                                 tags: tags)
        let url = URI(string:"\(self.domain)\(Endpoints.posts.rawValue)/\(id)")
        return self.request.client
            .put(url, headers: self.request.headers) { (request) in
                try request.content.encode(post)
            }.flatMapThrowing{ response in
                guard [.ok, .created].contains(response.status) else {
                    throw Abort(response.status)
                }
                return try response.content.decode(WordpressPost.self)
            }
    }
    
    public func delete(id: Int, force: Bool? = false) throws -> EventLoopFuture<WordpressPost>{
        let url = URI(string:"\(self.domain)\(Endpoints.posts.rawValue)/\(id)?force=\(force ?? false)")
        return self.request.client
            .delete(url, headers: self.request.headers).flatMapThrowing{ response in
                guard response.status == .ok else {
                    self.request.logger.debug("\(response.content)")
                    throw Abort(response.status)
                }
                return try response.content.decode(WordpressPost.self)
            }
    }

}

public struct WordpressPost: Content {
    public let id: Int?
    public let password: String?
    public let date, date_gmt: Date?
    public let guid: Object?
    public let modified, modified_gmt: Date?
    public let slug, status: String?
    public let type: String?
    public let link: String?
    public let title: Object?
    public let content, excerpt: Object?
    public let author, featured_media: Int?
    public let comment_status, ping_status: String?
    public let sticky: Bool?
    public let template, format: String?
    public let categories, tags: [Int]?
    public let featured_image_url: String?
    
    public init(id: Int? = nil,
         password: String? = nil,
         date: Date? = nil,
         date_gmt: Date? = nil,
         guid: Object? = nil,
         modified: Date? = nil,
         modified_gmt: Date? = nil,
         slug: String? = nil,
         status: String? = nil,
         type: String? = nil,
         link: String? = nil,
         title: Object? = nil,
         content: Object? = nil,
         excerpt: Object? = nil,
         author: Int? = nil,
         featured_media: Int? = nil,
         comment_status: String? = nil,
         ping_status: String? = nil,
         sticky: Bool? = nil,
         template: String? = nil,
         format: String? = nil,
         categories: [Int]? = nil,
         tags: [Int]? = nil,
         featured_image_url: String? = nil) {
        self.id = id
        self.password = password
        self.date = date
        self.date_gmt = date_gmt
        self.guid = guid
        self.modified = modified
        self.modified_gmt = modified_gmt
        self.slug = slug
        self.status = status
        self.type = type
        self.link = link
        self.title = title
        self.content = content
        self.excerpt = excerpt
        self.author = author
        self.featured_media = featured_media
        self.comment_status = comment_status
        self.ping_status = ping_status
        self.sticky = sticky
        self.template = template
        self.format = format
        self.categories = categories
        self.tags = tags
        self.featured_image_url = featured_image_url
    }
}

// MARK: - Content
public struct Object: Content {
    public let rendered: String?
    public let protected: Bool?
    
    public init(rendered: String? = nil,
         protected: Bool? = nil) {
        self.rendered = rendered
        self.protected = protected
    }
}
