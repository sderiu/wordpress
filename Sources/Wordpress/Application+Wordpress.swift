//
//  File.swift
//
//
//  Created by Simone Deriu on 20/12/2020.
//

import Vapor

extension Application {

    public struct WordpressConfiguration{
        var user: String
        var password: String
        var domain: String
    }
    
    public struct WordpressConfigurationKey: StorageKey {
        public typealias Value = WordpressConfiguration
    }
    
    public var wordpress: WordpressConfiguration {
        get {
            guard let key = self.storage[WordpressConfigurationKey.self] else{
                fatalError("Wordpress credentials missing")
            }
            return key
        }
        set {
            self.storage[WordpressConfigurationKey.self] = newValue
        }
    }
}
