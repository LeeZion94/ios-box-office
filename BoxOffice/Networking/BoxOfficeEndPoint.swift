//
//  BoxOfficeEndPoint.swift
//  BoxOffice
//
//  Created by Hyungmin Lee on 2023/08/16.
//

import Foundation

struct BoxOfficeEndPoint {
    init(urlInformation: URLInformation) {
        self.urlInformation = urlInformation
    }
    
    private let scheme = "http"
    private let host = "www.kobis.or.kr"
    private let urlInformation: URLInformation
    
    var url: URL? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "/kobisopenapi/webservice/rest" + urlInformation.path
        urlComponents.queryItems = urlInformation.queryItems
        return urlComponents.url
    }
    
    enum URLInformation {
        case daily(targetDate: String)
        case movieDetail(movieCode: String)
        
        var path: String {
            switch self {
            case .daily:
                return "/boxoffice/searchDailyBoxOfficeList.json"
            case .movieDetail:
                return "/movie/searchMovieInfo.json"
            }
        }
        
        var queryItems: [URLQueryItem] {
            var queryItems = [URLQueryItem(name: "key", value: APIKey.boxOffice)]
            
            switch self {
            case .daily(let targetDate):
                queryItems.append(URLQueryItem(name: "targetDt", value: targetDate))
                return queryItems
            case .movieDetail(let movieCode):
                queryItems.append(URLQueryItem(name: "movieCd", value: movieCode))
                return queryItems
            }
        }
    }
}
