//
//  ImgurAPIError.swift
//  QItta_ImgurAPI_Demo_02
//
//  Created by HIROKI IKEUCHI on 2020/08/03.
//  Copyright © 2020 hikeuchi. All rights reserved.
//

import Foundation

// エラーとして処理するため、ImgurBaseResponseと別実装にする必要がある
public struct ImgurAPIErrorResponse : Decodable, Error {
    public var success: Bool
    public var status: Int
    public var data: ErrorInfo
    
    public struct ErrorInfo : Decodable {
        public var error   : String  // エラーの詳細 e.g. "Invalid grant_type parameter or parameter missing"
        public var request : String  // リクエストへの相対パス e.g. "/oauth2/token"
        public var method  : String  // メソッド e.g. "POST"
    }
}
