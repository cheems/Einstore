//
//  Auth.swift
//  Boost
//
//  Created by Ondrej Rafaj on 27/11/2016.
//  Copyright © 2016 manGoweb UK Ltd. All rights reserved.
//

import Foundation
import Vapor
import Fluent


final class Auth: Model {
    
    var exists: Bool = false
    
    var id: Node?
    var token: String?
    var created: Date?
    var userId: Node?
    var user: User?
    
    
    // MARK: Initialization
    
    init(user: User) {
        self.token = UUID().uuidString
        self.created = Date()
        self.user = user
        self.userId = self.user?.id
    }
    
    init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.token = try node.extract("token")
        self.created = try Date(rfc1123: node.extract("created"))
        
        self.userId = try node.extract("user_id")
        let user = try User.query().filter("user_id", self.userId!).first()
        self.user = user
    }
    
    func makeNode(context: Context) throws -> Node {
        // It's important we only save a hashed token to the DB
        let tokenHash = try drop.hash.make(self.token!)
        return try Node(node: [
            "id": self.id,
            "token": tokenHash,
            "created": self.created?.rfc1123,
            "user_id": self.userId
            ])
    }
    
    func makeJSON() throws -> JSON {
        let user: User = self.user!
        user.password = nil
        return JSON(["token": self.token!.makeNode(), "user": try user.makeNode()])
    }
    
}

extension Auth: Preparation {
    
    static func prepare(_ database: Database) throws {
        
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("users")
    }
    
}


// MARK: - Helpers

extension Auth {
    
    // MARK: Get
    
    static func getOne(tokenString token: String) throws -> User? {
        return try User.query().filter("token", token).first()
    }
    
    static func getOne(token: Node) throws -> User? {
        return try User.query().filter("token", token).first()
    }
    
    // MARK: Delete
    
    static func delete(userId id: Node) throws {
        try Auth.query().filter("user_id", id).delete()
    }
    
    static func delete(token: String) throws {
        try Auth.query().filter("token", token).delete()
    }
    
}
