//
//  DaumSearchEndPoint.swift
//  BoxOffice
//
//  Created by Hyungmin Lee on 2023/08/16.
//

import Foundation

struct DaumSearchEndPoint {
    init(urlInformation: URLInformation) {
        self.urlInformation = urlInformation
    }
    
    private let scheme = "https"
    private let host = "dapi.kakao.com"
    private let urlInformation: URLInformation
    
    var url: URL? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = urlInformation.path
        urlComponents.queryItems = urlInformation.queryItems
        return urlComponents.url
    }
    
    enum URLInformation {
        case image(movieName: String)
        
        var path: String {
            switch self {
            case .image:
                return "/v2/search/image"
            }
        }
        
        var queryItems: [URLQueryItem] {
            var queryItems = [URLQueryItem]()
            
            switch self {
            case .image(let movieName):
                queryItems.append(URLQueryItem(name: "query", value: "\(movieName) 영화 포스터"))
                return queryItems
            }
        }
    }
}
