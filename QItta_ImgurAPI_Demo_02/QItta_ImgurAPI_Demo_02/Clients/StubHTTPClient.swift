//
//  StubHTTPClient.swift
//  QItta_ImgurAPI_Demo_02Tests
//
//  Created by HIROKI IKEUCHI on 2020/08/04.
//  Copyright © 2020 hikeuchi. All rights reserved.
//

import Foundation

class StubHTTPClient : HTTPClient {
    var result: Result<(Data, HTTPURLResponse), Error> =
        .success(
            (Data(),
             HTTPURLResponse(url: URL(string :"https://exapmle.com")!,
                             statusCode: 200,
                             httpVersion: nil,
                             headerFields: nil)!)
    )
    
    func sendRequest(_ urlRequest: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [unowned self] in
            completion(self.result)
        }
    }
}
