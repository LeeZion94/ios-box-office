//
//  Repositoriable.swift
//  BoxOffice
//
//  Created by Hyungmin Lee on 2023/08/09.
//

import Foundation

protocol Repositoriable {
    func setUpRequestURL(_ baseURL: String,_ path: String, _ queryItems: [String: Any]) -> URLRequest?
}

extension Repositoriable {
    func setUpRequestURL(_ baseURL: String,_ path: String, _ queryItems: [String: Any]) -> URLRequest? {
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        
        urlComponents.path += path
        urlComponents.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        
        guard let url = urlComponents.url else { return nil }
        let urlRequest = URLRequest(url: url)
        
        return urlRequest
    }
}
