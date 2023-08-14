//
//  URLSessionProvider.swift
//  BoxOffice
//
//  Created by Zion, Hemg on 2023/07/27.
//

import Foundation

protocol URLSessionProvider {
    func requestData(_ baseURL: String, _ path: String, _ queryItem:[String: Any], _ header: [String: Any]?, _ completionHandler: @escaping (Result<Data, APIError>) -> Void)
}

final class URLSessionProviderImplementation: URLSessionProvider {
    private var dataTask: URLSessionDataTask?
  
    func requestData(_ baseURL: String, _ path: String, _ queryItem:[String: Any], _ header: [String: Any]? = nil, _ completionHandler: @escaping (Result<Data, APIError>) -> Void) {
        guard var setUpUrlRequest = setUpRequestURL(baseURL, path, queryItem) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        if let header = header {
            for (key, value) in header {
                setUpUrlRequest.addValue(value as? String ?? "", forHTTPHeaderField: key)
            }
        }
            
        dataTask = URLSession.shared.dataTask(with: setUpUrlRequest) { data, response, error in
            if error != nil {
                completionHandler(.failure(.requestFail))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299) ~= httpResponse.statusCode else {
                completionHandler(.failure(.invalidHTTPStatusCode))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            completionHandler(.success(data))
        }
        
        self.dataTask?.resume()
    }
    
    private func setUpRequestURL(_ baseURL: String,_ path: String, _ queryItems: [String: Any]) -> URLRequest? {
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        
        urlComponents.path += path
        urlComponents.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        
        guard let url = urlComponents.url else { return nil }
        let urlRequest = URLRequest(url: url)
        
        return urlRequest
    }
}
