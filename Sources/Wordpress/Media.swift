//
//  File.swift
//  
//
//  Created by Simone Deriu on 20/12/2020.
//

import Vapor

public class Medias: Wordpress {
    
    public func upload(file: File) throws -> EventLoopFuture<WordpressMedia>{
        let data = file.data
        let name = file.filename
            let url = URI(string:"\(self.domain)\(Endpoints.media.rawValue)")
            return self.request.client.post(url, headers: self.request.headers, beforeSend: { (request) in
                request.headers.add(name: "Content-Type", value: "image/png")
                request.headers.add(name: "Content-Disposition", value: "attachment; filename=\"\(name)\"")
                request.body = data
            }).flatMapThrowing{ response in
                guard [.ok, .created].contains(response.status) else {
                    throw Abort(response.status)
                }
                return try response.content.decode(WordpressMedia.self)
            }
    }
    
    public func list() throws -> EventLoopFuture<[WordpressMedia]>{
        let url = URI(string:"\(self.domain)\(Endpoints.media.rawValue)")
        return self.request.client.get(url, headers: self.request.headers).flatMapThrowing{ response in
            guard [.ok, .created].contains(response.status) else {
                throw Abort(response.status)
            }
            return try response.content.decode([WordpressMedia].self)
        }
    }
    
    public func get(id: Int) throws -> EventLoopFuture<WordpressMedia>{
        let url = URI(string:"\(self.domain)\(Endpoints.media.rawValue)/\(id)")
        return self.request.client.get(url, headers: self.request.headers).flatMapThrowing{ response in
            guard [.ok, .created].contains(response.status) else {
                throw Abort(response.status)
            }
            return try response.content.decode(WordpressMedia.self)
        }
    }
    
    public func delete(id: Int, force: Bool? = false) throws -> EventLoopFuture<DeletedMedia>{
        let url = URI(string:"\(self.domain)\(Endpoints.media.rawValue)/\(id)?force=\(force ?? false)")
        return self.request.client.get(url, headers: self.request.headers).flatMapThrowing{ response in
            guard [.ok, .created].contains(response.status) else {
                throw Abort(response.status)
            }
            return try response.content.decode(DeletedMedia.self)
        }
    }
}


public struct WordpressMedia: Content {
    let id: Int?
    let date, date_gmt: Date?
    let guid: Object?
    let modified, modified_gmt: Date?
    let slug, status: String?
    let type: String?
    let link: String?
    let description: Object?
    let author, featured_media: Int?
    let comment_status, ping_status: String?
    let sticky: Bool?
    let template, format: String?
    let media_type, mime_type: String?
    let source_url: String?
    let post: Int?
    let caption: Object?
    
    init(id: Int? = nil,
         date: Date? = nil,
         date_gmt: Date? = nil,
         guid: Object? = nil,
         modified: Date? = nil,
         modified_gmt: Date? = nil,
         slug: String? = nil,
         status: String? = nil,
         type: String? = nil,
         link: String? = nil,
         description: Object? = nil,
         caption: Object? = nil,
         author: Int? = nil,
         featured_media: Int? = nil,
         comment_status: String? = nil,
         ping_status: String? = nil,
         sticky: Bool? = nil,
         template: String? = nil,
         format: String? = nil,
         media_type: String? = nil,
         mime_type: String? = nil,
         source_url: String? = nil,
         post: Int? = nil) {
        self.id = id
        self.date = date
        self.date_gmt = date_gmt
        self.guid = guid
        self.modified = modified
        self.modified_gmt = modified_gmt
        self.slug = slug
        self.status = status
        self.type = type
        self.link = link
        self.description = description
        self.author = author
        self.featured_media = featured_media
        self.comment_status = comment_status
        self.ping_status = ping_status
        self.sticky = sticky
        self.template = template
        self.format = format
        self.media_type = media_type
        self.mime_type = mime_type
        self.source_url = source_url
        self.post = post
        self.caption = caption
    }
}

public struct DeletedMedia: Content{
    let deleted: Bool?
    let previous: WordpressMedia?
}
