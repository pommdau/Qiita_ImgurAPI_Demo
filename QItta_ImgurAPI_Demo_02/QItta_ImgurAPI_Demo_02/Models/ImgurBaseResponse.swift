//
//  ImgurBaseResponse.swift
//  QItta_ImgurAPI_Demo_02
//
//  Created by HIROKI IKEUCHI on 2020/08/03.
//  Copyright © 2020 hikeuchi. All rights reserved.
//

import Foundation

public struct ImgurBaseResponse<Item : Decodable> : Decodable {
    public var success: Bool
    public var status: Int
    public var data: Item  // レスポンスの詳細情報
}
