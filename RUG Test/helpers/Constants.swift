//
//  Constants.swift
//  RUG Test
//
//  Created by Kinney Kare on 5/15/22.
//

import Foundation
//NOTE: I made all properties static below so they can be shared with all objects. 

struct K {
    
    struct URL {
        static let urlString = "https://randomuser.me/api/"
    }
    struct ReusableIdentifier {
        static let userTableViewCell = "UserTableViewCell"
    }
    
    struct BarButtonTitle {
        static let save = "SAVE"
        static let generateUser = "Generate User"
    }
    
    struct ImageAssets {
        static let noImage = "no-image"
    }
}
