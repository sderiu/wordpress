//
//  File.swift
//  
//
//  Created by Simone Deriu on 20/12/2020.
//

import Vapor

class Media: Wordpress {
    
    /// Upload a media on wordpress.
    ///
    /// - parameters:
    ///    - req: a http `Request`.
    ///    - file: a media to upload.
    /// - returns: the media wordpress identifier.
    public func upload(file: File) -> EventLoopFuture<Int>{
        let data = file.data
        let name = file.filename
        do {
            let url = URI(string:"\(self.domain)/wp-json/wp/v2/media")
            return self.request.client.post(url, headers: self.request.headers, beforeSend: { (request) in
                request.headers.add(name: "Content-Type", value: "image/png")
                request.headers.add(name: "Content-Disposition", value: "attachment; filename=\"\(name)\"")
                request.body = data
            }).map{ response in
                do{
                    let media = try response.content.decode(WordpressMedia.self)
                    return media.id
                }
                catch{
                    self.request.logger.error("Wordpress media upload failed!")
                    self.request.logger.error("\(response.content)")
                    return 0
                }
            }
        }
    }
    
}
