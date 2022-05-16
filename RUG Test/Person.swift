//
//  User.swift
//  RUG Test
//
//  Created by Kinney Kare on 5/14/22.
//

import Foundation


// MARK: - User
struct UserResponse: Codable {
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    var name: Name
    let picture: Picture
}

// MARK: - Name
struct Name: Codable {
    var first, last: String
}

// MARK: - Picture
struct Picture: Codable {
    let large: String
}
