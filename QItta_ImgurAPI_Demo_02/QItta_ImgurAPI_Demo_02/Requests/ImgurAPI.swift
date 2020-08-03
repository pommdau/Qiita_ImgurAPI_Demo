//
//  ImgurAPI.swift
//  QItta_ImgurAPI_Demo_02
//
//  Created by HIROKI IKEUCHI on 2020/08/03.
//  Copyright © 2020 hikeuchi. All rights reserved.
//

import Foundation

public final class ImgurAPI {
    
    // OAuth2.0認証用
    public struct UserAuthenticationRequest : ImgurRequest {
        public typealias Response = ImgurBaseResponse<Bool>  // TODO: 不要なんだけどな…
        
        public var method: HTTPMethod {
            return .post
        }
        
        public var path: String {
            return "/oauth2/authorize"
        }
        
        public var queryItems: [URLQueryItem] {
            return [URLQueryItem(name: "client_id",     value: OAuthInfo.clientID),
                    URLQueryItem(name: "response_type", value: "token"),
                    URLQueryItem(name: "state",         value: "sample")]
        }
        
        public var header: Dictionary<String, String>? {
            return nil
        }
        
        public var body: Data? {
            return nil
        }
    }
    
    public struct GeneratingAccessTokenRequest : ImgurRequest {
        public typealias Response = GenerateAccessTokenResponse
        
        public var method: HTTPMethod {
            return .post
        }
        
        public var path: String {
            return "/oauth2/token"
        }
        
        public var queryItems: [URLQueryItem] {
            return []
        }
        
        public var header: Dictionary<String, String>? {
            let bodySize = body?.count ?? 0
            return [
                "Content-Length" : "\(bodySize)",
                "Content-Type"  : "application/json",
            ]
        }
        
        public var body: Data? {
            let bodyJSON = [
                "refresh_token" : OAuthInfo.refreshToken,
                "client_id"     : OAuthInfo.clientID,
                "client_secret" : OAuthInfo.clientSecret,
                "grant_type"    : "refresh_token",
            ]
            
            guard let bodyData = try? JSONSerialization.data(withJSONObject: bodyJSON) else {
                return nil
            }
            
            return bodyData
        }
    }
    
    public struct UploadingImageRequest : ImgurRequest {
        public let imageInBase64String: String  // member wise initializerで代入される
        public let needAuthentication: Bool  // 認証状態で画像をアップロードするかどうか
        
        public typealias Response = ImgurBaseResponse<Image>
        
        public var method: HTTPMethod {
            return .post
        }
        
        public var path: String {
            return "/3/image"
        }
        
        public var queryItems: [URLQueryItem] {
            return []
        }
        
        public var header: Dictionary<String, String>? {
            var headerList = ["Content-Type" : "application/json"]
            
            if needAuthentication {
                headerList["Authorization"] = "Bearer \(OAuthInfo.accessToken)"
            } else {
                headerList["Authorization"] = "Client-ID \(OAuthInfo.clientID)"
            }
            
            return headerList
        }
        
        public var body: Data? {
            let bodyJSON = [
                "image" : imageInBase64String,
            ]
            
            guard let bodyData = try? JSONSerialization.data(withJSONObject: bodyJSON) else {
                return nil
            }
            
            return bodyData
        }
    }
    
    public struct DeletingImageRequest : ImgurRequest {
        public let imageHash: String
        public let needAuthentication: Bool  // 認証状態で画像をアップロードするかどうか
        
        public typealias Response = ImgurBaseResponse<Bool>
        
        public var method: HTTPMethod {
            return .delete
        }
        
        public var path: String {
            return "/3/image/\(imageHash)"
        }
        
        public var queryItems: [URLQueryItem] {
            return []
        }
        
        public var header: Dictionary<String, String>? {
            var headerList = ["Content-Type" : "application/json"]  // TODO: bodyがnilなので不要かも
            
            if needAuthentication {
                headerList["Authorization"] = "Bearer \(OAuthInfo.accessToken)"
            } else {
                headerList["Authorization"] = "Client-ID \(OAuthInfo.clientID)"
            }
            
            return headerList
        }
        
        public var body: Data? {
            return nil
        }
    }
    
    public struct OAuthInfo {
        private enum UserDefaultsKey: String {
            case accessToken
            case expires
            case tokenType
            case refreshToken
            case accountUserName
            case accountID
        }
        
        static let clientID = "e6d8ea34904ab93"
        static let clientSecret = "fcbd5690a9ae357f927d31b1f0918b12ec3af24c"
        static let callBackNotificationName = Notification.Name("ReceiveCallBackURLNotification")
        struct UserinfoKey {
            static let callbackURL = "callbackurl"
        }
        
        public static func postCallBackNotification(for url: URL) {
            NotificationCenter.default.post(name: self.callBackNotificationName,
                                            object: nil,
                                            userInfo:  [self.UserinfoKey.callbackURL: url])
        }
        
        public static func resetUserDefault() {
            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.accessToken.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.expires.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.tokenType.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.refreshToken.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.accountUserName.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.accountUserName.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.accountID.rawValue)
        }
        
        static var accessToken: String {
            get {
                return UserDefaults.standard.string(forKey: UserDefaultsKey.accessToken.rawValue) ?? ""
            }
            
            set(accessToken) {
                UserDefaults.standard.set(accessToken, forKey: UserDefaultsKey.accessToken.rawValue)
            }
        }
        
        static var expires: Int {
            get {
                return UserDefaults.standard.integer(forKey: UserDefaultsKey.expires.rawValue)
            }
            
            set(expires) {
                UserDefaults.standard.set(expires, forKey: UserDefaultsKey.expires.rawValue)
            }
        }
        
        static var tokenType: String {  // bearer:無記名
            get {
                return UserDefaults.standard.string(forKey: UserDefaultsKey.tokenType.rawValue) ?? ""
            }
            
            set(tokenType) {
                UserDefaults.standard.set(tokenType, forKey: UserDefaultsKey.tokenType.rawValue)
            }
        }
        
        static var refreshToken: String {
            get {
                return UserDefaults.standard.string(forKey: UserDefaultsKey.refreshToken.rawValue) ?? ""
            }
            
            set(refreshToken) {
                UserDefaults.standard.set(refreshToken, forKey: UserDefaultsKey.refreshToken.rawValue)
            }
        }
        
        static var accountUserName: String {
            get {
                return UserDefaults.standard.string(forKey: UserDefaultsKey.accountUserName.rawValue) ?? ""
            }
            
            set(accountUserName) {
                UserDefaults.standard.set(refreshToken, forKey: UserDefaultsKey.accountUserName.rawValue)
            }
        }
        
        static var accountID: String {
            get {
                return UserDefaults.standard.string(forKey: UserDefaultsKey.accountID.rawValue) ?? ""
            }
            
            set(accountID) {
                UserDefaults.standard.set(refreshToken, forKey: UserDefaultsKey.accountID.rawValue)
            }
        }
        
        static func update(for queryItems: [URLQueryItem]) {
            for queryItem in queryItems {
                
                guard let queryValue = queryItem.value else {
                    continue
                }
                
                switch queryItem.name {
                case "access_token":
                    Self.accessToken = queryValue
                case "expires_in":
                    Self.expires = Int(queryValue) ?? 0
                case "token_type":
                    Self.tokenType = queryValue
                case "refresh_token":
                    Self.refreshToken = queryValue
                case "account_username":
                    Self.accountUserName = queryValue
                case "account_id":
                    Self.accountID = queryValue
                default:
                    break
                }
            }
        }
        
        static func update(for response: GenerateAccessTokenResponse) {
            Self.accessToken     = response.accessToken
            Self.refreshToken    = response.refreshToken
            Self.accessToken     = response.accessToken
            Self.accountUserName = response.accountUserName
        }
    }
}
