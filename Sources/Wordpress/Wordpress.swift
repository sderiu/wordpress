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

    public var posts: Posts
    public var media: Medias
    
    init(_ req: Request) {
        self.domain = req.application.wordpress.domain
        self.posts = Posts(req)
        self.media = Medias(req)
        self.request = req
    }

}


