//
//  HTTPMethod.swift
//  QItta_ImgurAPI_Demo_02
//
//  Created by HIROKI IKEUCHI on 2020/08/03.
//  Copyright © 2020 hikeuchi. All rights reserved.
//

import Foundation

public enum HTTPMethod : String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case head    = "HEAD"
    case delete  = "DELETE"
    case patch   = "PATCH"
    case trace   = "TRACE"
    case options = "OPTIONS"
    case connect = "CONNECT"
}
