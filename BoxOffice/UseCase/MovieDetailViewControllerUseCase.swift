//
//  MovieDetailViewControllerUseCase.swift
//  BoxOffice
//
//  Created by Zion, Hemg on 2023/08/09.
//

import UIKit

protocol MovieDetailViewControllerUseCase {
    var delegate: MovieDetailViewControllerUseCaseDelegate? { get set }
    func fetchMovieDetailInformation(_ movieCode: String, _ movieName: String)
    //    func fetchMovieDetailImage(_ imageURL: URL, completion: @escaping (UIImage?) -> Void)
    var movieCode: String { get }
    var movieName: String { get }
}

final class MovieDetailViewControllerUseCaseImplementation: MovieDetailViewControllerUseCase {
    private let boxOfficeRepository: BoxOfficeRepository
    private let daumSearchRepository: DaumSearchRepository
    weak var delegate: MovieDetailViewControllerUseCaseDelegate?
    let movieCode: String
    let movieName: String
    
    init(boxOfficeRepository: BoxOfficeRepository, daumSearchRepository: DaumSearchRepository, movieCode: String, movieName: String) {
        self.boxOfficeRepository = boxOfficeRepository
        self.daumSearchRepository = daumSearchRepository
        self.movieName = movieName
        self.movieCode = movieCode
    }
    
    let dispatchGroup = DispatchGroup()
    func fetchMovieDetailInformation(_ movieCode: String, _ movieName: String) {
        dispatchGroup.enter()
        boxOfficeRepository.fetchMovieDetailInformation(movieCode) { result in
            self.dispatchGroup.leave()
            switch result {
            case .success(let result):
                let movieDetailInformationDTO = self.setUpMovieDetailInformationDTO(result.movieInformationResult.movieInformation)
                
                self.delegate?.completeFetchMovieDetailInformation(movieDetailInformationDTO)
            case .failure(let error):
                self.delegate?.failFetchMovieDetailInformation(error.errorDescription)
            }
        }
        
        dispatchGroup.enter()
        daumSearchRepository.fetchDaumImageSearchInformation(movieName) { result in
            switch result {
            case .success(let result):
                guard let imageData = result.documents.first?.imageURL.data(using: .utf8) else { return }
                guard let movieDetailImageDTO = self.setUpMovieDetailImageDTO(result, imageData) else {
                    let error = APIError.dataTransferFail
                    self.dispatchGroup.leave()
                    self.delegate?.failFetchMovieDetailImage(error.errorDescription)
                    return
                }
                
                self.delegate?.completeFetchMovieDetailImage(movieDetailImageDTO)
            case .failure(let error):
                self.dispatchGroup.leave()
                self.delegate?.failFetchMovieDetailImage(error.errorDescription)
            }
        }
    }
    
    //    func fetchMovieDetailImage(_ imageURL: URL, completion: @escaping (UIImage?) -> Void) {
    //        daumSearchRepository.setUpImageURL(imageURL) { image in
    //            completion(image)
    //        }
    //    }
}

extension MovieDetailViewControllerUseCaseImplementation {
    private func setUpMovieDetailImageDTO(_ daumSearchImageResult: DaumSearchImageResult, _ imageData: Data) -> MovieDetailImageDTO? {
        guard let imageInformation = daumSearchImageResult.documents.first else { return nil }
        
//        let imageData = Data()
        
        let movieDetailImageDTO = MovieDetailImageDTO(imageURL: imageData,
                                                      width: imageInformation.width,
                                                      height: imageInformation.height)
        
        return movieDetailImageDTO
    }
    
    private func setUpMovieDetailInformationDTO(_ movieDetailResult: MovieDetail) -> MovieDetailInformationDTO {
        let movieDetailInformationDTO = MovieDetailInformationDTO(showTime: movieDetailResult.showTime,
                                                                  productYear: movieDetailResult.productYear,
                                                                  openDate: movieDetailResult.openDate,
                                                                  nations: movieDetailResult.nations.map { $0.nationName },
                                                                  genres: movieDetailResult.genres.map { $0.genreName },
                                                                  directors: movieDetailResult.directors.map { $0.peopleName },
                                                                  movieActors: movieDetailResult.actors.map { $0.peopleName },
                                                                  watchGrade: movieDetailResult.audits.first?.watchGradeName ?? "")
        
        return movieDetailInformationDTO
    }
}
