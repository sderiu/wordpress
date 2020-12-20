//
//  File.swift
//  
//
//  Created by Simone Deriu on 20/12/2020.
//

import Vapor

extension Request{
    
    //MARK: - Wordpress
    public var wordpress: Wordpress{
        let cred = "\(self.application.wordpress.user):\(self.application.wordpress.password)"
            .data(using: .utf8)?.base64EncodedString() ?? ""
        let auth = "Basic \(cred)"
        self.headers = HTTPHeaders([])
        self.headers.add(name: "Authorization", value: auth)
        return Wordpress(self)
    }
    
}
