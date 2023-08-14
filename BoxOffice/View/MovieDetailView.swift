//
//  MovieDetailView.swift
//  BoxOffice
//
//  Created by Zion, Hemg on 1823/08/09.
//

import UIKit


final class MovieDetailView: UIView {
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        
        activityIndicatorView.startAnimating()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()
    
    private let loadingView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let directorStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let directorLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "감독"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let directorContentLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18)
        label.setContentHuggingPriority(.init(1), for: .horizontal)
        return label
    }()
    
    private let productionYearStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let productionYearLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "제작년도"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productionYearContentLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18)
        label.setContentHuggingPriority(.init(1), for: .horizontal)
        return label
    }()
    
    private let openDateStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let openDateLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "개봉일"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let openDateContentLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18)
        label.setContentHuggingPriority(.init(1), for: .horizontal)
        return label
    }()
    
    private let showTimeStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let showTimeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "상영시간"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let showTimeContentLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18)
        label.setContentHuggingPriority(.init(1), for: .horizontal)
        return label
    }()
    
    private let watchGradeStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let watchGradeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "관람등급"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let watchGradeContentLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18)
        label.setContentHuggingPriority(.init(1), for: .horizontal)
        return label
    }()
    
    private let nationsStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let nationsLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "제작국가"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nationsContentLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18)
        label.setContentHuggingPriority(.init(1), for: .horizontal)
        return label
    }()
    
    private let genresStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let genresLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "장르"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genresContentLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18)
        label.setContentHuggingPriority(.init(1), for: .horizontal)
        return label
    }()
    
    private let movieActorsStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let movieActorsLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "배우"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let movieActorsContentLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.setContentHuggingPriority(.init(1), for: .horizontal)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let dispatchGroup = DispatchGroup()
    
    func setUpContents(_ movieDetailInformationDTO: MovieDetailInformationDTO) {
        dispatchGroup.enter()
        DispatchQueue.main.async {
            self.directorContentLabel.text = movieDetailInformationDTO.directors.joined(separator: ", ")
            self.productionYearContentLabel.text = movieDetailInformationDTO.productYear
            self.openDateContentLabel.text = movieDetailInformationDTO.openDate
            self.showTimeContentLabel.text = movieDetailInformationDTO.showTime
            self.watchGradeContentLabel.text = movieDetailInformationDTO.watchGrade
            self.nationsContentLabel.text = movieDetailInformationDTO.nations.joined(separator: ",")
            self.genresContentLabel.text = movieDetailInformationDTO.genres.joined(separator: ", ")
            self.movieActorsContentLabel.text = movieDetailInformationDTO.movieActors.joined(separator: ", ")
            
            self.movieActorsStackView.isHidden = movieDetailInformationDTO.isMovieActorsEmpty
            self.dispatchGroup.leave()
            self.dispatchGroup.notify(queue: .main) {
                self.hideLoading()
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    func setUpImageContent(_ movieDetailImageDTO: MovieDetailImageDTO) {
        dispatchGroup.enter()
        guard let imageURL = URL(string: movieDetailImageDTO.imageURL) else { return }
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let imageRatio = Double(movieDetailImageDTO.height) / Double(movieDetailImageDTO.width)
                let imageWidth = self.bounds.width
                
              
                self.imageView.heightAnchor.constraint(equalToConstant: imageWidth * imageRatio).isActive = true
                self.imageView.image = UIImage(data: data)
                
                self.dispatchGroup.leave()
                self.dispatchGroup.notify(queue: .main) {
                    self.hideLoading()
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }.resume()
    }
    
    private func setUpLayout() {
        showLoading()
        setUpScrollViewLayout()
        setUpContentViewLayout()
        setUpImageViewLayout()
        setUpMainStackViewLayout()
        setUpDirectorStackViewLayout()
        setUpProductionYearStackViewLayout()
        setUpOpenDateStackViewLayout()
        setUpShowTimeStackViewLayout()
        setUpWatchGradeStackViewLayout()
        setUpProductionNationStackViewLayout()
        setUpGenresStackViewLayout()
        setUpMovieActorsStackViewLayout()
        setUpActivityIndicatorViewLayout()
    }
    
    private func hideLoading() {
        loadingView.removeFromSuperview()
    }
}

// MARK: - setUpLayout
extension MovieDetailView {
    private func showLoading() {
        addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpScrollViewLayout() {
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func setUpContentViewLayout() {
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        let heightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor, constant: 1)
        
        heightConstraint.priority = .init(1)
        heightConstraint.isActive = true
    }
    
    private func setUpImageViewLayout() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95)
        ])
    }
    
    private func setUpMainStackViewLayout() {
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setUpDirectorStackViewLayout() {
        directorStackView.addArrangedSubview(directorLabel)
        directorStackView.addArrangedSubview(directorContentLabel)
        mainStackView.addArrangedSubview(directorStackView)
        
        NSLayoutConstraint.activate([
            directorLabel.widthAnchor.constraint(equalTo: directorStackView.widthAnchor, multiplier: 0.2)
        ])
    }
    
    private func setUpProductionYearStackViewLayout() {
        productionYearStackView.addArrangedSubview(productionYearLabel)
        productionYearStackView.addArrangedSubview(productionYearContentLabel)
        mainStackView.addArrangedSubview(productionYearStackView)
        
        NSLayoutConstraint.activate([
            productionYearLabel.widthAnchor.constraint(equalTo: productionYearStackView.widthAnchor, multiplier: 0.2)
        ])
    }
    
    private func setUpOpenDateStackViewLayout() {
        openDateStackView.addArrangedSubview(openDateLabel)
        openDateStackView.addArrangedSubview(openDateContentLabel)
        mainStackView.addArrangedSubview(openDateStackView)
        
        NSLayoutConstraint.activate([
            openDateLabel.widthAnchor.constraint(equalTo: openDateStackView.widthAnchor, multiplier: 0.2)
        ])
    }
    
    private func setUpShowTimeStackViewLayout() {
        showTimeStackView.addArrangedSubview(showTimeLabel)
        showTimeStackView.addArrangedSubview(showTimeContentLabel)
        mainStackView.addArrangedSubview(showTimeStackView)
        
        NSLayoutConstraint.activate([
            showTimeLabel.widthAnchor.constraint(equalTo: showTimeStackView.widthAnchor, multiplier: 0.2)
        ])
    }
    
    private func setUpWatchGradeStackViewLayout() {
        watchGradeStackView.addArrangedSubview(watchGradeLabel)
        watchGradeStackView.addArrangedSubview(watchGradeContentLabel)
        mainStackView.addArrangedSubview(watchGradeStackView)
        
        NSLayoutConstraint.activate([
            watchGradeLabel.widthAnchor.constraint(equalTo: watchGradeStackView.widthAnchor, multiplier: 0.2)
        ])
    }
    
    private func setUpProductionNationStackViewLayout() {
        nationsStackView.addArrangedSubview(nationsLabel)
        nationsStackView.addArrangedSubview(nationsContentLabel)
        mainStackView.addArrangedSubview(nationsStackView)
        
        NSLayoutConstraint.activate([
            nationsLabel.widthAnchor.constraint(equalTo: nationsStackView.widthAnchor, multiplier: 0.2)
        ])
    }
    
    private func setUpGenresStackViewLayout() {
        genresStackView.addArrangedSubview(genresLabel)
        genresStackView.addArrangedSubview(genresContentLabel)
        mainStackView.addArrangedSubview(genresStackView)
        
        NSLayoutConstraint.activate([
            genresLabel.widthAnchor.constraint(equalTo: genresStackView.widthAnchor, multiplier: 0.2)
        ])
    }
    
    private func setUpMovieActorsStackViewLayout() {
        movieActorsStackView.addArrangedSubview(movieActorsLabel)
        movieActorsStackView.addArrangedSubview(movieActorsContentLabel)
        mainStackView.addArrangedSubview(movieActorsStackView)
        
        NSLayoutConstraint.activate([
            movieActorsLabel.widthAnchor.constraint(equalTo: movieActorsStackView.widthAnchor, multiplier: 0.2)
        ])
    }
    
    private func setUpActivityIndicatorViewLayout() {
        loadingView.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
    }
}
