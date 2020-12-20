//
//  File.swift
//  
//
//  Created by Simone Deriu on 20/12/2020.
//

import Vapor

class Post: Wordpress {
    
    /// Create a post on wordpress
    ///
    /// - parameters:
    ///    - post: the post to be created.
    /// - returns: the created post, nil if the post is not created.
    public func create(title: String,
                content: String,
                featured_media: Int,
                status: String,
                categories: [Int],
                tags: [Int],
                slug: String)
    -> EventLoopFuture<WordpressPostResponse?> {
        let post = WordpressPost(title: title,
                                    content: content,
                                    featured_media: featured_media,
                                    status: status,
                                    categories: categories,
                                    tags: tags,
                                    slug: slug)
        return self.request.client
            .post(URI(string:"\(self.request.application.wordpress.domain)/wp-json/wp/v2/posts"), headers: self.request.headers) { (request) in
                try request.content.encode(post)
            }.map{ response in
                do{
                    guard [.ok, .created].contains(response.status) else {
                        return nil
                    }
                    return try response.content.decode(WordpressPostResponse.self)
                }
                catch
                {
                    self.request.logger.error("Wordpress post creation failed!")
                    self.request.logger.debug("\(response.content)")
                    return nil
                }
            }
    }

}
