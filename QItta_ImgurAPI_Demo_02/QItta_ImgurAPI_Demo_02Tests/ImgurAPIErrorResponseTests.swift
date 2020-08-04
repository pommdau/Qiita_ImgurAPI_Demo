//
//  ImgurAPIErrorResponseTests.swift
//  QItta_ImgurAPI_Demo_02Tests
//
//  Created by HIROKI IKEUCHI on 2020/08/04.
//  Copyright © 2020 hikeuchi. All rights reserved.
//

import XCTest
@testable import QItta_ImgurAPI_Demo_02

class ImgurAPIErrorResponseTests: XCTestCase {
    func testDecode() throws {
        let jsonDecoder = JSONDecoder()
        let data = ImgurAPIErrorResponse.exampleJSON.data(using: .utf8)!
        let response = try jsonDecoder.decode(ImgurAPIErrorResponse.self, from: data)
        XCTAssertEqual(response.success,      false)
        XCTAssertEqual(response.status,       400)
        XCTAssertEqual(response.data.error,   "Invalid refresh token")
        XCTAssertEqual(response.data.request, "/oauth2/token")
        XCTAssertEqual(response.data.method,  "POST")
    }

}
