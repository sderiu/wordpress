//
//  File.swift
//
//
//  Created by Simone Deriu on 20/12/2020.
//

import Vapor

public class Wordpress{
    
    internal var domain: String
    internal var request: Request

    public var posts: Post
    public var media: Media
    
    init(_ req: Request) {
        self.domain = req.application.wordpress.domain
        self.posts = Post(req)
        self.media = Media(req)
        self.request = req
    }

}


struct WordpressMedia: Content {
    var id: Int
}

/// Wordpress post to send as payload in wordpress REST API
struct WordpressPost: Content {
    var title: String
    var content: String
    var featured_media: Int?
    var status: String
    var categories: [Int]
    var tags: [Int]
    var slug: String?
    
    init(title: String, content: String, featured_media: Int, status: String? = "draft", categories: [Int], tags: [Int], slug: String? = nil) {
        self.title = title
        self.content = content
        self.featured_media = featured_media
        self.status = status ?? "draft"
        self.categories = categories
        self.tags = tags
        self.slug = slug
    }
}

public struct WordpressPostResponse: Content {
    var title: WordpressTitle
    var content: WordpressTitle
    var featured_media: Int
    var status: String
    var categories: [Int]
    var tags: [Int]
    var link: String?
    var slug: String?
    var featured_image_url: String?
    var optimized_link: String?
}

struct WordpressTitle: Content {
    var rendered: String
}
