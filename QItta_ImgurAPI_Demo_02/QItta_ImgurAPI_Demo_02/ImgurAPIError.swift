//
//  ImgurAPIError.swift
//  QItta_ImgurAPI_Demo_02
//
//  Created by HIROKI IKEUCHI on 2020/08/03.
//  Copyright © 2020 hikeuchi. All rights reserved.
//

import Foundation

public struct ImgurAPIError : Decodable, Error {
    public var error   : String  // エラーの詳細 e.g. "Invalid grant_type parameter or parameter missing"
    public var request : String  // リクエストへの相対パス e.g. "/oauth2/token"
    public var method  : String  // メソッド e.g. "POST"
}
