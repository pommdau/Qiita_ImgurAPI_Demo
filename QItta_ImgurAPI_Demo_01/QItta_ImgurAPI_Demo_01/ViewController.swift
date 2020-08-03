//
//  ViewController.swift
//  QItta_ImgurAPI_Demo_01
//
//  Created by HIROKI IKEUCHI on 2020/08/03.
//  Copyright © 2020 hikeuchi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func AuthorizeInBrowser() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleCallbackURL(_:)),
                                               name: OAuthInfo.Imgur.callBackNotificationName,
                                               object: nil)
        
        let baseURL           = URL(string: "https://api.imgur.com")!
        let relativePath      = "oauth2/authorize"
        let authenticationURL = baseURL.appendingPathComponent(relativePath)
        var components = URLComponents(url: authenticationURL , resolvingAgainstBaseURL: true)  // URL構成要素を表現するクラス。URLも楽に書き出せて便利。
        
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "client_id",     value: OAuthInfo.Imgur.clientID),
                                          URLQueryItem(name: "response_type", value: "token"),
                                          URLQueryItem(name: "state",         value: "sample")]
        
        components?.queryItems = queryItems
        
        guard let openingURL = components?.url else {
            return
        }
        
        if !NSWorkspace.shared.open(openingURL) {
            fatalError()
        }
    }
    
    @objc func handleCallbackURL(_ notification: Notification) {
        NotificationCenter.default.removeObserver(self)
        
        guard let callbackURL = notification.userInfo?[OAuthInfo.Imgur.UserinfoKey.callbackURL] as? URL else {
            return
        }
        
        /*
         // allowが選択された
         qiita-demo-2cdc3a06e7197c2://oauth-callback?state=sample#access_token=3342acd5d5f91c49646266254aa0ebb8521db7b7&expires_in=315360000&token_type=bearer&refresh_token=e91e74e710fd96b40a87652c87b7282e99c0edd9&account_username=IKEH1024&account_id=104356397
         
         // denyが選択された
         qiita-demo-2cdc3a06e7197c2://oauth-callback?error=access_denied&state=sample
         */
        print("CallbackURLを受け取りました。\n\(callbackURL.absoluteString)")
        
        var components = URLComponents(url: callbackURL , resolvingAgainstBaseURL: true)  // フラグメント部分は無視されるようです
        components?.query = callbackURL.fragment  // フラグメントをクエリとして保存する
        guard let queryItems = components?.queryItems else {
            return
        }
        
        var oauthInfo = OAuthInfo.Imgur()
        for queryItem in queryItems {
            oauthInfo.update(for: queryItem)
        }
    }
    
    
    func updateAccessToken() {
        let baseURL      = URL(string: "https://api.imgur.com")!
        let relativePath = "oauth2/token"
        let url          = baseURL.appendingPathComponent(relativePath)
        
        var urlRequest = URLRequest(url: url, timeoutInterval: Double.infinity)
        urlRequest.httpMethod = "POST"
        
        let bodyJSON = [
            "refresh_token" : OAuthInfo.Imgur.refreshToken,
            "client_id"     : OAuthInfo.Imgur.clientID,
            "client_secret" : OAuthInfo.Imgur.clientSecret,
            "grant_type"    : "refresh_token",
        ]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: bodyJSON) else {
            return
        }
        urlRequest.httpBody = bodyData
        
        
        urlRequest.addValue("\(bodyData.count)", forHTTPHeaderField: "Content-Length")
        urlRequest.addValue("application/json",  forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { data, urlResponse, error in
            if let urlResponse = urlResponse as? HTTPURLResponse {
                if urlResponse.statusCode != 200 {
                    print("アクセストークンのアップデートに失敗しました。")
                    /*
                     // ヘッダ不正
                     {
                         "data": {
                             "error": "Invalid grant_type parameter or parameter missing",
                             "request": "/oauth2/token",
                             "method": "POST"
                         },
                         "success": false,
                         "status": 400
                     }
                     
                     // APIの使用が不許可
                     {
                         "data": {
                             "error": "Invalid refresh token",
                             "request": "/oauth2/token",
                             "method": "POST"
                         },
                         "success": false,
                         "status": 400
                     }
                     */
                    self.printDebugString(for: data)
                    return
                }
                
                /*
                 {
                     "access_token": "e0d1b6af7b3f498dab549e9c9dafce2708081764",
                     "expires_in": 315360000,
                     "token_type": "bearer",
                     "scope": null,
                     "refresh_token": "e5bbc2c2bc29543470cc9e126d77397240b91040",
                     "account_id": 104356397,
                     "account_username": "IKEH1024"
                 }
                 */
                self.printDebugString(for: data)
                
                let dic = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any]
                if let dic = dic {
                    if let accessToken = dic["access_token"] as? String {
                        OAuthInfo.Imgur.accessToken = accessToken
                    }
                    
                    if let refreshToken =  dic["refresh_token"] as? String {
                        OAuthInfo.Imgur.refreshToken = refreshToken
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func uploadImage() {
        
        guard let image = readImageFromClipboard() else {
            return
        }
        
        guard let imageData = image.tiffRepresentation else {
            return
        }
        
        let baseURL      = URL(string: "https://api.imgur.com")!
        let relativePath = "/3/image"
        let url          = baseURL.appendingPathComponent(relativePath)
        
        var urlRequest = URLRequest(url: url, timeoutInterval: Double.infinity)
        urlRequest.httpMethod = "POST"
        
        let base64 = imageData.base64EncodedString()
        let bodyJSON = [
            "image" : base64,
        ]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: bodyJSON) else {
            return
        }
        
        urlRequest.httpBody = bodyData
        
        urlRequest.addValue("application/json",                      forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(OAuthInfo.Imgur.accessToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { data, urlResponse, error in
            if let urlResponse = urlResponse as? HTTPURLResponse {
                if urlResponse.statusCode != 200 {
                    print("画像のアップロードに失敗しました。")
                    /*
                     {
                         "data": {
                             "error": "Authentication required",
                             "request": "/3/image",
                             "method": "POST"
                         },
                         "success": false,
                         "status": 401
                     }
                     */
                    self.printDebugString(for: data)
                    return
                }
                
                // アップロード結果の確認
                /*
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
                 */
                self.printDebugString(for: data)
            }
        }
        
        task.resume()
    }
    
    
    // MARK: - Helper Methods
    
    func readImageFromClipboard() -> NSImage? {
        // 画像がクリップボードにコピーされている場合
        let pasteboard = NSPasteboard.general
        
        let classes = [NSImage.self]
        let options = [NSPasteboard.ReadingOptionKey : Any]()
        
        let canRead = pasteboard.canReadObject(forClasses: classes, options: options)
        if canRead {
            let objectsToPaste = pasteboard.readObjects(forClasses: classes,
                                                        options: options) ?? []
            
            if objectsToPaste.count > 0 {
                let image = objectsToPaste[0] as! NSImage
                return image
            }
        } else {
            print("クリップボードに画像はありませんでした")
        }
        
        return nil
    }
    
    func printDebugString(for data: Data?) {
        if let dataString = String(data: data ?? Data(), encoding: .utf8) {
            print(dataString)
        }
    }
    
    
    // MARK: - Actrions
    
    @IBAction func authorizeButtonClicked(_ sender: Any) {
        AuthorizeInBrowser()
    }
    
    @IBAction func updateAccessTokenButtonClicked(_ sender: Any) {
        updateAccessToken()
    }
 
    @IBAction func uploadImageButtonClicked(_ sender: Any) {
        uploadImage()
    }
}



