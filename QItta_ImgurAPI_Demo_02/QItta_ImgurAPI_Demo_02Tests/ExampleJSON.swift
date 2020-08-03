//
//  ExampleJSON.swift
//  QItta_ImgurAPI_Demo_02Tests
//
//  Created by HIROKI IKEUCHI on 2020/08/03.
//  Copyright © 2020 hikeuchi. All rights reserved.
//

import Foundation
@testable import QItta_ImgurAPI_Demo_02

extension GenerateAccessTokenResponse {
    static var exampleJSON: String {
        return """
        {
            "access_token": "e0d1b6af7b3f498dab549e9c9dafce2708081764",
            "expires_in": 315360000,
            "token_type": "bearer",
            "scope": null,
            "refresh_token": "e5bbc2c2bc29543470cc9e126d77397240b91040",
            "account_id": 104356397,
            "account_username": "IKEH1024"
        }
        """
    }    
}
