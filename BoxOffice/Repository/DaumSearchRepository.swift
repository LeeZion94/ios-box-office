//
//  DaumSearchRepository.swift
//  BoxOffice
//
//  Created by Zion, Hemg on 2023/08/09.
//

import Foundation

protocol DaumSearchRepository: CanMakeURLRequest {
    func fetchDaumImageSearchInformation(_ movieName: String, _ completionHandler: @escaping (Result<DaumSearchImageResult, APIError>) -> Void)
    func fetchDaumImageDataFormURL(_ urlString: String, _ completionHandler: @escaping (Result<Data, APIError>) -> Void)
}

final class DaumSearchRepositoryImplementation: DaumSearchRepository {
    private let sessionProvider: URLSessionProvider
    private let decoder: JSONDecoder
    
    init(sessionProvider: URLSessionProvider, decoder: JSONDecoder = JSONDecoder()) {
        self.sessionProvider = sessionProvider
        self.decoder = decoder
    }
    
    func fetchDaumImageSearchInformation(_ movieName: String, _ completionHandler: @escaping (Result<DaumSearchImageResult, APIError>) -> Void) {
        let queryItem: [String: Any] = ["query": "\(movieName) 영화 포스터"]
        let header = "KakaoAK \(APIKey.daumSearch)"
        var urlRequest = setUpRequestURL(BaseURL.daumSearch, DaumSearchURLPath.image, queryItem)
        
        urlRequest?.setValue(header, forHTTPHeaderField: "Authorization")
        sessionProvider.requestData(urlRequest) { result in
            switch result {
            case .success(let data):
                self.decoder.decodeResponseData(data, completionHandler)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func fetchDaumImageDataFormURL(_ urlString: String, _ completionHandler: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        
        sessionProvider.requestData(urlRequest) { result in
            switch result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
