//
//  GenerateAccessTokenResponse.swift
//  QItta_ImgurAPI_Demo_02
//
//  Created by HIROKI IKEUCHI on 2020/08/03.
//  Copyright © 2020 hikeuchi. All rights reserved.
//

import Foundation

public struct GenerateAccessTokenResponse : Decodable {
    public var accountID        : Int
    public var scope            : String?
    public var refreshToken     : String
    public var tokenType        : String
    public var accessToken      : String
    public var accountUserName  : String
    public var expiresIn        : Int
    
    public enum CodingKeys : String, CodingKey {
        case accountID       = "account_id"
        case scope
        case refreshToken    = "refresh_token"
        case tokenType       = "token_type"
        case accessToken     = "access_token"
        case accountUserName = "account_username"
        case expiresIn       = "expires_in"
    }
}
