//
//  BoxOfficeRepository.swift
//  BoxOffice
//
//  Created by Zion, Hemg on 2023/08/01.
//

import Foundation

protocol BoxOfficeRepository {
    func fetchDailyBoxOffice(_ targetDate: String, _ completionHandler: @escaping (Result<BoxOfficeResult, APIError>) -> Void)
    func fetchMovieDetailInformation(_ movieCode: String, _ completionHandler: @escaping (Result<MovieDetailResult, APIError>) -> Void)
}

final class BoxOfficeRepositoryImplementation: BoxOfficeRepository {
    private let sessionProvider: URLSessionProvider
    private let decoder: JSONDecoder
    
    init(sessionProvider: URLSessionProvider, decoder: JSONDecoder = JSONDecoder()) {
        self.sessionProvider = sessionProvider
        self.decoder = decoder
    }
    
    func fetchDailyBoxOffice(_ targetDate: String, _ completionHandler: @escaping (Result<BoxOfficeResult, APIError>) -> Void) {
        let queryItems: [String: Any] = [
            "key": APIKey.boxOffice,
            "targetDt": targetDate
        ]
        
        sessionProvider.requestData(BaseURL.boxOffice, BoxOfficeURLPath.daily, queryItems, nil) { result in
            switch result {
            case .success(let data):
                self.decoder.decodeResponseData(data, completionHandler)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func fetchMovieDetailInformation(_ movieCode: String, _ completionHandler: @escaping (Result<MovieDetailResult, APIError>) -> Void) {
        let queryItems: [String: Any] = [
            "key": APIKey.boxOffice,
            "movieCd": movieCode
        ]
        
        sessionProvider.requestData(BaseURL.boxOffice, BoxOfficeURLPath.movieDetail, queryItems, nil) { result in
            switch result {
            case .success(let data):
                self.decoder.decodeResponseData(data, completionHandler)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
