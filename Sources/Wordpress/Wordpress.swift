//
//  File.swift
//
//
//  Created by Simone Deriu on 20/12/2020.
//

import Vapor

public class Wordpress{

    public var posts: Posts
    public var media: Medias
    public var categories: Categories
    public var tags: Tags
    
    init(_ req: Request) {
        self.posts = Posts(req)
        self.media = Medias(req)
        self.categories = Categories(req)
        self.tags = Tags(req)
    }

}


