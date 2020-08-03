//
//  ImgurRequest.swift
//  QItta_ImgurAPI_Demo_02
//
//  Created by HIROKI IKEUCHI on 2020/08/03.
//  Copyright © 2020 hikeuchi. All rights reserved.
//

import Foundation

public protocol ImgurRequest {
    associatedtype Response: Decodable  // リクエストに応じたレスポンスのモデルクラス

    var baseURL     : URL                         { get }
    var path        : String                      { get }  // baesURLからの相対パス
    var method      : HTTPMethod                  { get }
    var queryItems  : [URLQueryItem]              { get }
    var header      : Dictionary<String, String>? { get }
    var body        : Data?                       { get }  // HTTP bodyに設定するパラメータ
    
}

public extension ImgurRequest {
    var baseURL: URL {  // デフォルト実装
        return URL(string: "https://api.imgur.com")!
    }
}
