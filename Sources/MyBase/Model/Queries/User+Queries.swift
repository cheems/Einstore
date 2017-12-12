//
//  User+Queries.swift
//  MyBase
//
//  Created by Ondrej Rafaj on 11/12/2017.
//

import Foundation
import Vapor
import Crypto


extension User: Queryable, HasForeignId {
    
    public static var tableName: String = "users"
    public static var foreignIdName: String = "user_id"
    
    public static func login(with login: String, password: String) -> String {
        let login = sanitize(login).lowercased()
        let password = sanitize(password)
        let passwordHash = SHA256.hash(password)
        return "SELECT * FROM \(tableName) WHERE (`email` = '\(login)') AND `password` == '\(passwordHash)' AND `disabled` = 0;"
    }
    
    public static func delete(userId: Int) -> String {
        return "DELETE FROM \(tableName) WHERE `id` = \(userId) AND `su` = 0;"
    }
    
    public static func disable(userId: Int) -> String {
        return "UPDATE \(tableName) SET `disabled` = 1 WHERE `id` = \(userId) AND `su` = 0;"
    }
    
    public static var superUser: String {
        let password: String = "password123"
        let passwordHash = SHA256.hash(password)
        return "INSERT INTO `users` (`firstname`, `lastname`, `email`, `password`, `registered`, `su`) VALUES ('Super', 'Admin', 'admin@liveui.io', '\(passwordHash)', NOW(), 1);"
    }
    
    public static var create: String = """
    CREATE TABLE `\(tableName)` (
        `id` int(11) UNSIGNED NOT NULL,
        `firstname` varchar(80) NOT NULL,
        `lastname` varchar(80) NOT NULL,
        `email` varchar(140) NOT NULL,
        `password` varchar(64) NOT NULL,
        `token` varchar(64) NOT NULL,
        `expires` datetime NOT NULL,
        `registered` datetime NOT NULL,
        `disabled` tinyint(1) NOT NULL DEFAULT '0',
        `su` tinyint(1) NOT NULL DEFAULT '0'
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
    
    ALTER TABLE `users`
        ADD PRIMARY KEY (`id`),
        ADD KEY `strings` (`email`,`password`);
    
    ALTER TABLE `users`
        MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;
    
    \(superUser)
    
    COMMIT;
    """
    
}