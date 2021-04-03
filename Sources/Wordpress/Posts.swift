//
//  File.swift
//  
//
//  Created by Simone Deriu on 20/12/2020.
//

import Vapor

public class Posts {
    
    var domain: String
    var request: Request
    
    init(_ req: Request) {
        self.domain = req.application.wordpress.domain
        self.request = req
    }
    
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
                       slug: String? = nil,
                       status: String? = nil,
                       type: String? = nil,
                       link: String? = nil,
                       title: String,
                       content: String,
                       excerpt: String? = nil,
                       author: Int? = nil,
                       featured_media: Int? = nil,
                       comment_status: String? = nil,
                       ping_status: String? = nil,
                       sticky: Bool? = nil,
                       template: String? = nil,
                       format: String? = nil,
                       categories: [Int]? = nil,
                       tags: [Int]? = nil,
                       yoast_wpseo_title: String? = nil,
                       yoast_wpseo_focuskw: String? = nil,
                       yoast_wpseo_metadesc: String? = nil) throws
    -> EventLoopFuture<WordpressPost> {
        let yoast = yoast_meta(yoast_wpseo_focuskw: yoast_wpseo_focuskw,
                               yoast_wpseo_title: yoast_wpseo_title,
                               yoast_wpseo_metadesc: yoast_wpseo_metadesc)
        let post = WordpressPostCreateRequest(slug: slug,
                                              status: status,
                                              type: type,
                                              link: link,
                                              title:  title,
                                              content: content,
                                              featured_media: featured_media,
                                              categories: categories,
                                              tags: tags,
                                              yoast_meta: yoast)
        let url = URI(string:"\(self.domain)\(Endpoints.posts.rawValue)")
        return self.request.client
            .post(url, headers: self.request.headers) { (request) in
                try request.content.encode(post)
            }.flatMapThrowing{ response in
                guard [.ok, .created].contains(response.status) else {
                    throw Abort(response.status, reason: String(buffer: response.body!))
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

public struct WordpressPostCreateRequest: Content {
    public let title: String
    public let content: String
    public let categories, tags: [Int]?
    public let featured_media: Int?
    public let slug: String?
    public let link: String?
    public let status: String?
    public let yoast_meta: yoast_meta?
    
    public init(
         slug: String? = nil,
         status: String? = nil,
         type: String? = nil,
         link: String? = nil,
         title: String,
         content: String,
         featured_media: Int? = nil,
         categories: [Int]? = nil,
         tags: [Int]? = nil,
        yoast_meta: yoast_meta? = nil) {
        self.slug = slug
        self.status = status
        self.link = link
        self.title = title
        self.content = content
        self.featured_media = featured_media
        self.categories = categories
        self.tags = tags
        self.yoast_meta = yoast_meta
    }
}

public struct yoast_meta: Content{
    
    public let yoast_wpseo_focuskw: String?
    public let yoast_wpseo_title: String?
    public let yoast_wpseo_metadesc: String?
    
    public init(yoast_wpseo_focuskw: String? = nil,
        yoast_wpseo_title: String? = nil,
        yoast_wpseo_metadesc: String? = nil){
        self.yoast_wpseo_title = yoast_wpseo_title
        self.yoast_wpseo_focuskw = yoast_wpseo_focuskw
        self.yoast_wpseo_metadesc = yoast_wpseo_metadesc
    }
}

public struct WordpressPost: Content {
    public let id: Int?
    public let password: String?
    public let guid: Object?
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
         guid: Object? = nil,
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
        self.guid = guid
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
