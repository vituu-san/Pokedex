//
//  URLSession+Extension.swift
//  Pokedex
//
//  Created by Vitor Costa on 29/09/24.
//

import Foundation

/// Implementa um padrão ao `URLSession` para facilitar a manipulação dos testes de requisições HTTP.
protocol URLSessionProtocol {
    func dataTask(with url: URL,
                  completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol   {
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}

/// Implementa um padrão ao `URLSessionDataTask` para facilitar a manipulação dos testes de requisições HTTP.
protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
