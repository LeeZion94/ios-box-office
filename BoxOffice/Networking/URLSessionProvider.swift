//
//  URLSessionProvider.swift
//  BoxOffice
//
//  Created by Zion, Hemg on 2023/07/27.
//

import Foundation

protocol URLSessionProvider {
    func requestData<T: Decodable>(_ requestURL: URL?, _ completionHandler: @escaping (Result<APIResponse<T>, APIError>) -> Void)
}

final class URLSessionProviderImpl: URLSessionProvider {
    private var dataTask: URLSessionDataTask?
    
    func requestData<T: Decodable>(_ requestURL: URL?, _ completionHandler: @escaping (Result<APIResponse<T>, APIError>) -> Void) {
        guard let requestURL  = requestURL else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        dataTask = URLSession.shared.dataTask(with: requestURL) { data, response, error in
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
            
            self.decodeResponseData(data, completionHandler)
        }
        
        self.dataTask?.resume()
    }
}

// MARK: - Private
extension URLSessionProviderImpl {
    private func decodeResponseData<T: Decodable>(_ responseData: Data, _ completionHandler: (Result<APIResponse<T>, APIError>) -> Void) {
        do {
            let jsonDecoder = JSONDecoder()
            let decodingData = try jsonDecoder.decode(T.self, from: responseData)
            
            completionHandler(.success(.init(data: decodingData)))
        } catch {
            completionHandler(.failure(.decodingFail))
        }
    }
    
    private func setUpRequestURL(_ baseURL: String,_ request: APIRequest) -> URL? {
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        
        if let path = request.path {
            urlComponents.path += path
        }
        
        if let queryItems = request.queryItems {
            urlComponents.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        return urlComponents.url
    }
}
