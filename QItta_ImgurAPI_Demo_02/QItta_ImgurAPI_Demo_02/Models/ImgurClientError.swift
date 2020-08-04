//
//  ImgurClientError.swift
//  QItta_ImgurAPI_Demo_02
//
//  Created by HIROKI IKEUCHI on 2020/08/03.
//  Copyright © 2020 hikeuchi. All rights reserved.
//

import Foundation

public enum ImgurClientError : Error {
    // 通信に失敗
    case connectionError(Error)
    
    // レスポンスの解釈に失敗
    case responseParseError(Error)
    
    // APIからエラーレスポンスを受け取った
    case apiError(ImgurAPIErrorResponse)
    
}
