//
//  Image.swift
//  QItta_ImgurAPI_Demo_02
//
//  Created by HIROKI IKEUCHI on 2020/08/03.
//  Copyright © 2020 hikeuchi. All rights reserved.
//

import Foundation

// アップロードしたメディア情報
public struct Image: Codable {
    let id          : String
    let datetime    : Int
    let animated    : Bool
    let deletehash  : String
    let link        : String
}
