//
//  ImgurClient.swift
//  QItta_ImgurAPI_Demo_02
//
//  Created by HIROKI IKEUCHI on 2020/08/04.
//  Copyright © 2020 hikeuchi. All rights reserved.
//

import Cocoa

public class ImgurClient {
    private let httpClient: HTTPClient  // HTTPClientプロトコルに準拠した型
    public var callbackURLCompletion: () -> Void = {}  // コールバック後に呼び出し元クラスで処理（for debug）
    
    public init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // クライアントの機能として、Requestから実際のHTTPリクエストを作成し（これはRequest側に持たせている機能）、非同期的に通信を行う。
    // 結果を受け取ったらRequestに対応するレスポンスの型へ変換し呼び出し元へ返す
    public func send<Request : ImgurRequest>
        (request: Request,
         completion: @escaping (Result<Request.Response, ImgurClientError>) -> Void) {
        
        let urlRequest = request.buildURLRequest()
        
        httpClient.sendRequest(urlRequest) { result in
            switch result {  // 通信の成否はresult: Result<(Data, HTTPURLResponse), Error>から判断する
            case .success((let data, let urlResponse)):
                do {
                    let response = try request.response(from: data, urlResponse: urlResponse)
                    completion(Result.success(response))
                } catch let error as ImgurAPIErrorResponse {
                    completion(Result.failure(.apiError(error)))
                } catch {
                    completion(.failure(.responseParseError(error)))
                }
            case .failure(let error):
                completion(.failure(.connectionError(error)))
            }
        }
    }
    
    // MARK:- OAuth2.0初回認証用（URLRequestが関係なく特殊なのでクラス分けの余地はあるかも）
    
    public func openAuthorizePageInBrowser<Request : ImgurRequest>(request: Request) {
        let urlRequest = request.buildURLRequest()
        guard let url = urlRequest.url else {
            return
        }
        
        if NSWorkspace.shared.open(url) {
            NotificationCenter.default.addObserver(self, selector: #selector(receivedCallbackURL(_:)),
                                                   name: ImgurAPI.OAuthInfo.callBackNotificationName,
                                                   object: nil)
        } else {
            fatalError()
        }
    }
    
    @objc func receivedCallbackURL(_ notification: Notification) {
        NotificationCenter.default.removeObserver(self)

        guard let callbackURL = notification.userInfo?[ImgurAPI.OAuthInfo.UserinfoKey.callbackURL] as? URL else {
            return
        }
        
        var components = URLComponents(url: callbackURL , resolvingAgainstBaseURL: true)
        components?.query = callbackURL.fragment  // フラグメントの追加
        
        guard let queryItems = components?.queryItems else {
            return
        }
        
        for queryItem in queryItems {
            print(queryItem)
        }
        
        ImgurAPI.OAuthInfo.update(for: queryItems)
        callbackURLCompletion()
    }
}
