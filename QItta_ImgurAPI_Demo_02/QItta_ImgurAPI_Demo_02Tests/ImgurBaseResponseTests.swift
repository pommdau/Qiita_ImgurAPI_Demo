//
//  ImgurBaseResponseTests.swift
//  QItta_ImgurAPI_Demo_02Tests
//
//  Created by HIROKI IKEUCHI on 2020/08/03.
//  Copyright © 2020 hikeuchi. All rights reserved.
//

import Foundation

import XCTest
@testable import QItta_ImgurAPI_Demo_02

class ImgurBaseResponseTests: XCTestCase {

    func testDecodeImgurAPIError() throws {
        let jsonDecoder = JSONDecoder()
        let data = ImgurBaseResponse<ImgurAPIError>.exampleJSON.data(using: .utf8)!
        let response = try jsonDecoder.decode(ImgurBaseResponse<ImgurAPIError>.self, from: data)
        XCTAssertEqual(response.success,      false)
        XCTAssertEqual(response.status,       400)
        XCTAssertEqual(response.data.error,   "Invalid refresh token")
        XCTAssertEqual(response.data.request, "/oauth2/token")
        XCTAssertEqual(response.data.method,  "POST")
    }
    
    func testDecodeImage() throws {
        let jsonDecoder = JSONDecoder()
        let data = ImgurBaseResponse<Image>.exampleJSON.data(using: .utf8)!
        let response = try jsonDecoder.decode(ImgurBaseResponse<Image>.self, from: data)
        XCTAssertEqual(response.success,            true)
        XCTAssertEqual(response.status,             200)
        XCTAssertEqual(response.data.id,            "RsWSMHF")
        XCTAssertEqual(response.data.datetime,      1596455626)
        XCTAssertEqual(response.data.animated,      false)
        XCTAssertEqual(response.data.deletehash,    "HWl7S48dF4Y2Q3r")
        XCTAssertEqual(response.data.link,          "https://i.imgur.com/RsWSMHF.png")
        
    }
}
