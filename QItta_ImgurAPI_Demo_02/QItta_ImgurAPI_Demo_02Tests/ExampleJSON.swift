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

extension ImgurBaseResponse where Item == ImgurAPIError {
    static var exampleJSON: String {
        return """
        {
            "data": {
                "error": "Invalid refresh token",
                "request": "/oauth2/token",
                "method": "POST"
            },
            "success": false,
            "status": 400
        }
        """
    }
}

extension ImgurBaseResponse where Item == Image {
    static var exampleJSON: String {
        return """
        {
            "data": {
                "id": "RsWSMHF",
                "title": null,
                "description": null,
                "datetime": 1596455626,
                "type": "image/png",
                "animated": false,
                "width": 468,
                "height": 308,
                "size": 28985,
                "views": 0,
                "bandwidth": 0,
                "vote": null,
                "favorite": false,
                "nsfw": null,
                "section": null,
                "account_url": null,
                "account_id": 104356397,
                "is_ad": false,
                "in_most_viral": false,
                "has_sound": false,
                "tags": [],
                "ad_type": 0,
                "ad_url": "",
                "edited": "0",
                "in_gallery": false,
                "deletehash": "HWl7S48dF4Y2Q3r",
                "name": "",
                "link": "https://i.imgur.com/RsWSMHF.png"
            },
            "success": true,
            "status": 200
        }
        """
    }
}

