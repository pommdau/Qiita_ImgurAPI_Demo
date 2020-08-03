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
}
