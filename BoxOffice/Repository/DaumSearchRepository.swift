//
//  DaumSearchRepository.swift
//  BoxOffice
//
//  Created by Zion, Hemg on 2023/08/09.
//

import UIKit

protocol DaumSearchRepository {
    func fetchDaumImageSearchInformation(_ movieName: String, _ completionHandler: @escaping (Result<DaumSearchImageResult, APIError>) -> Void)
    func setUpImageURL(_ url: URL, completion: @escaping (UIImage?) -> Void)
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
        let header = ["Authorization": "KakaoAK \(APIKey.daumSearch)"]
        
        sessionProvider.requestData(BaseURL.daumSearch, DaumSearchURLPath.image, queryItem, header) { result in
            switch result {
            case .success(let data):
                self.decoder.decodeResponseData(data, completionHandler)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func setUpImageURL(_ url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            let imageData = UIImage(data: data)
            completion(imageData)
        }.resume()
    }
}
