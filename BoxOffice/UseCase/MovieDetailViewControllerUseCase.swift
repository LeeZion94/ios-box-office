//
//  MovieDetailViewControllerUseCase.swift
//  BoxOffice
//
//  Created by Zion, Hemg on 2023/08/09.
//

import Foundation

protocol MovieDetailViewControllerUseCase {
    var delegate: MovieDetailViewControllerUseCaseDelegate? { get set }
    func fetchMovieDetailInformation(_ movieCode: String, _ movieName: String)
}

final class MovieDetailViewControllerUseCaseImplementation: MovieDetailViewControllerUseCase {
    private let boxOfficeRepository: BoxOfficeRepository
    private let daumSearchRepository: DaumSearchRepository
    weak var delegate: MovieDetailViewControllerUseCaseDelegate?
    
    init(boxOfficeRepository: BoxOfficeRepository, daumSearchRepository: DaumSearchRepository) {
        self.boxOfficeRepository = boxOfficeRepository
        self.daumSearchRepository = daumSearchRepository
    }
    
    func fetchMovieDetailInformation(_ movieCode: String, _ movieName: String) {
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.global().async {
            self.fetchMovieDescription(movieCode, dispatchGroup)
            self.fetchMovieImageInformation(movieName, dispatchGroup)

            let waitResult = dispatchGroup.wait(timeout: .now() + 15)

            if waitResult == .success {
                self.delegate?.completeFetchMovieDetailInformation()
            } else {
                let timeOutError = APIError.requestTimeOut
                
                self.delegate?.failFetchMovieDetailInformation(timeOutError.errorDescription)
            }
        }
    }
    
    private func fetchMovieDescription(_ movieCode: String, _ dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        self.boxOfficeRepository.fetchMovieDetailInformation(movieCode) { result in
            print("movie Detail 완료")
            dispatchGroup.leave()
            switch result {
            case .success(let result):
                let movieDetailInformationDTO = self.setUpMovieDetailInformationDTO(result.movieInformationResult.movieInformation)
                
                self.delegate?.completeFetMoviewDescription(movieDetailInformationDTO)
            case .failure(let error):
                self.delegate?.failFetchMovieDetailInformation(error.errorDescription)
            }
        }
    }
    
    private func fetchMovieImageInformation(_ movieName: String, _ dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        self.daumSearchRepository.fetchDaumImageSearchInformation(movieName) { result in
            print("moview Image 완료")
            switch result {
            case .success(let result):
                guard let imageInformation = result.documents.first else {
                    let error = APIError.dataTransferFail
                    
                    self.delegate?.failFetchMovieDetailInformation(error.errorDescription)
                    return
                }
                
                self.fetchImageDataFormURL(imageInformation, dispatchGroup)
            case .failure(let error):
                self.delegate?.failFetchMovieDetailInformation(error.errorDescription)
            }
        }
    }
    
    private func fetchImageDataFormURL(_ imageInformation: DaumSearchImageResult.ImageInformation, _ dispatchGroup: DispatchGroup) {
        self.daumSearchRepository.fetchDaumImageDataFormURL(imageInformation.imageURL) { result in
            dispatchGroup.leave()
            print("image 변환 완료")
            switch result {
            case .success(let data):
                let movieDetailImageDTO = self.setUpMovieDetailImageDTO(imageInformation, data)
                
                self.delegate?.completeFetchMovieDetailImage(movieDetailImageDTO)
            case .failure(let error):
                self.delegate?.failFetchMovieDetailInformation(error.errorDescription)
            }
        }
    }
}

extension MovieDetailViewControllerUseCaseImplementation {
    private func setUpMovieDetailImageDTO(_ imageInformation: DaumSearchImageResult.ImageInformation, _ imageData: Data) -> MovieDetailImageDTO {
        let movieDetailImageDTO = MovieDetailImageDTO(imageData: imageData,
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
