//
//  MainViewController.swift
//  BoxOffice
//
//  Created by Zion, Hemg on 13/01/23.
//

import UIKit

final class MainViewController: UIViewController, CanShowNetworkFailAlert {
    private lazy var requestMovieDetailInformationButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("영화 개별 상세 조회", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTappedRequestMovieDetailInformationButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var requestMovieDailyInformationButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("오늘의 일일 박스오피스 조회", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTappedRequestMovieDailyInformationButton), for: .touchUpInside)
        return button
    }()
    
    private let stackView: UIStackView = {
       let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpConstraints()
        setUpBackgroundColor()
    }
    
    private func setUpBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureUI() {
        [requestMovieDetailInformationButton, requestMovieDailyInformationButton].forEach { stackView.addArrangedSubview($0) }
        view.addSubview(stackView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - NetworkRequests
extension MainViewController {
    private func requestMovieDetailInformation() {
        let queryItems: [String: Any] = [
            "key": NetworkKey.boxOffice,
            "movieCd": "20218541"
        ]
        
        let request = APIRequest(baseURL: BaseURL.boxOffice, path: BoxOfficeURLPath.movieDetail, queryItems: queryItems)
        
        Networking.dataTask(request) { (result: APIResult<MovieDetailResult>) in
            switch result {
            case .success(let result):
                print(result)
            case .fauilure(let error):
                DispatchQueue.main.async {
                    self.showNetworkFailAlert(message: error.description, retryFunction: self.requestMovieDetailInformation)
                }
            }
        }
    }
    
    private func requestMovieDailyInformation() {
        let queryItems: [String: Any] = [
            "key": NetworkKey.boxOffice,
            "targetDt": "20230720"
        ]

        let request = APIRequest(baseURL: BaseURL.boxOffice, path: BoxOfficeURLPath.daily, queryItems: queryItems)

        Networking.dataTask(request) { (result: APIResult<BoxOfficeResult>) in
            switch result {
            case .success(let result):
                print(result)
            case .fauilure(let error):
                DispatchQueue.main.async {
                    self.showNetworkFailAlert(message: error.description, retryFunction: self.requestMovieDailyInformation)
                }
            }
        }
    }
}

// MARK: - Button Action
extension MainViewController {
    @objc private func didTappedRequestMovieDetailInformationButton() {
        requestMovieDetailInformation()
    }
    
    @objc private func didTappedRequestMovieDailyInformationButton() {
        requestMovieDailyInformation()
    }
}
