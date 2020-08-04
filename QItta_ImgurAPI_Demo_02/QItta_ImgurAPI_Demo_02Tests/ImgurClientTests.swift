//
//  ImgurClientTests.swift
//  QItta_ImgurAPI_Demo_02Tests
//
//  Created by HIROKI IKEUCHI on 2020/08/04.
//  Copyright © 2020 hikeuchi. All rights reserved.
//

import Foundation
import XCTest
@testable import QItta_ImgurAPI_Demo_02

// GenerateAccessTokenResponseに関してのみ、クライアントのテストを実装している
class ImgurClientTests: XCTestCase {
    var httpClient: StubHTTPClient!
    var imgurClient: ImgurClient!
    
    override func setUp() {
        super.setUp()
        
        httpClient = StubHTTPClient()
        imgurClient = ImgurClient(httpClient: httpClient)
    }
    
    private func makeHTTPClientResult(statusCode: Int, json: String) -> Result<(Data, HTTPURLResponse), Error> {
        return .success((
            json.data(using: .utf8)!,
            HTTPURLResponse(
                url: URL(string: "https://api.imgur.com")!,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil)!
        ))
    }
    
    
    // MARK:- Test Methods
    
    func testSuccessGeneratingAccessToken() {
        httpClient.result = makeHTTPClientResult(
            statusCode: 200,
            json: ImgurAPI.GeneratingAccessTokenRequest.Response.exampleJSON
        )
        
        let request = ImgurAPI.GeneratingAccessTokenRequest()
        let apiExpectation = expectation(description: "")
        imgurClient.send(request: request) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.accountID,       104356397)
                XCTAssertEqual(response.scope,           nil)
                XCTAssertEqual(response.refreshToken,    "e5bbc2c2bc29543470cc9e126d77397240b91040")
                XCTAssertEqual(response.tokenType,       "bearer")
                XCTAssertEqual(response.accessToken,     "e0d1b6af7b3f498dab549e9c9dafce2708081764")
                XCTAssertEqual(response.accountUserName, "IKEH1024")
                XCTAssertEqual(response.expiresIn,       315360000)
            default:
                XCTFail("unexpected result: \(result)")
            }
            apiExpectation.fulfill()
        }
        
        wait(for: [apiExpectation], timeout: 3)
    }
    
    func testFailureByConnectionError() {
        httpClient.result = .failure(URLError(.cannotConnectToHost))
        
        let request = ImgurAPI.GeneratingAccessTokenRequest()
        let apiExpectation = expectation(description: "")
        imgurClient.send(request: request) { result in
            switch result {
            case .failure(.connectionError):
                break
            default:
                XCTFail("unexpected result: \(result)")
            }
            apiExpectation.fulfill()
        }
        
        wait(for: [apiExpectation], timeout: 3)
    }
    
    func testFailureByResponseParseError() {
        httpClient.result = makeHTTPClientResult(
            statusCode: 200,
            json: "{}")
        
        let request = ImgurAPI.GeneratingAccessTokenRequest()
        let apiExpectation = expectation(description: "")
        imgurClient.send(request: request) { result in
            switch result {
            case .failure(.responseParseError):
                break
            default:
                XCTFail("unexpected result: \(result)")
            }
            apiExpectation.fulfill()
        }
        
        wait(for: [apiExpectation], timeout: 3)
    }
    
    func testFailureByAPIError() {
        httpClient.result = makeHTTPClientResult(
            statusCode: 400,
            json: ImgurAPIErrorResponse.exampleJSON)
        
        let request = ImgurAPI.GeneratingAccessTokenRequest()
        let apiExpectation = expectation(description: "")
        imgurClient.send(request: request) { result in
            switch result {
            case .failure(.apiError(let error)):
                XCTAssertEqual(error.success,      false)
                XCTAssertEqual(error.status,       400)
                XCTAssertEqual(error.data.error,   "Invalid refresh token")
                XCTAssertEqual(error.data.request, "/oauth2/token")
                XCTAssertEqual(error.data.method,  "POST")
            default:
                XCTFail("unexpected result: \(result)")
            }
            apiExpectation.fulfill()
        }
        
        wait(for: [apiExpectation], timeout: 3)
    }
}
