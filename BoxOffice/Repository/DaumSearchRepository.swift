//
//  DaumSearchRepository.swift
//  BoxOffice
//
//  Created by Zion, Hemg on 2023/08/09.
//

import Foundation

protocol DaumSearchRepository {
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
        let daumImageSearchInformation = DaumSearchEndPoint(urlInformation: .image(movieName: movieName))
        let header = ["Authorization": "KakaoAK \(APIKey.daumSearch)"]
        
        sessionProvider.requestData(url: daumImageSearchInformation.url, header: header) { result in
            switch result {
            case .success(let data):
                self.decoder.decodeResponseData(data, completionHandler)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func fetchDaumImageDataFormURL(_ urlString: String, _ completionHandler: @escaping (Result<Data, APIError>) -> Void) {
        let url = URL(string: urlString)
    
        sessionProvider.requestData(url: url, header: nil) { result in
            switch result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
