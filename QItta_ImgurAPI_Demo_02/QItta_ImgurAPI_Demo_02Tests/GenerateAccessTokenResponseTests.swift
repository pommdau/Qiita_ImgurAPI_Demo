//
//  GenerateAccessTokenResponseTests.swift
//  QItta_ImgurAPI_Demo_02Tests
//
//  Created by HIROKI IKEUCHI on 2020/08/03.
//  Copyright © 2020 hikeuchi. All rights reserved.
//

import XCTest
@testable import QItta_ImgurAPI_Demo_02

class GenerateAccessTokenResponseTests: XCTestCase {

    func testDecode() throws {
        let jsonDecoder = JSONDecoder()
        let data = GenerateAccessTokenResponse.exampleJSON.data(using: .utf8)!
        let response = try jsonDecoder.decode(GenerateAccessTokenResponse.self, from: data)
        XCTAssertEqual(response.accountID,       104356397)
        XCTAssertEqual(response.scope,           nil)
        XCTAssertEqual(response.refreshToken,    "e5bbc2c2bc29543470cc9e126d77397240b91040")
        XCTAssertEqual(response.tokenType,       "bearer")
        XCTAssertEqual(response.accessToken,     "e0d1b6af7b3f498dab549e9c9dafce2708081764")
        XCTAssertEqual(response.accountUserName, "IKEH1024")
        XCTAssertEqual(response.expiresIn,       315360000)
    }
}
