//
//  HTTPURLResponse+Extension.swift
//  PokedexTests
//
//  Created by Vitor Costa on 30/09/24.
//

import Foundation

extension HTTPURLResponse {
    func makeURLResponseMock(with code: Int) -> HTTPURLResponse? {
        HTTPURLResponse(url: URL(string: "TestURL")!, statusCode: code, httpVersion: nil, headerFields: nil)
    }
}
