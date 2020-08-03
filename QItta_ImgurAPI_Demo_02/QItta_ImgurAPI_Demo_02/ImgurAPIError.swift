//
//  ImgurAPIError.swift
//  QItta_ImgurAPI_Demo_02
//
//  Created by HIROKI IKEUCHI on 2020/08/03.
//  Copyright © 2020 hikeuchi. All rights reserved.
//

import Foundation

public struct ImgurAPIError : Decodable, Error {
    public var error   : String
    public var request : String
    public var method  : String
}
