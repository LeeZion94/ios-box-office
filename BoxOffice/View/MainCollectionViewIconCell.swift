//
//  MainCollectionViewIconCell.swift
//  BoxOffice
//
//  Created by Hyungmin Lee on 2023/08/15.
//

import UIKit

final class MainCollectionViewIconCell: UICollectionViewCell, MainCollectionViewCellChangable {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        return label
    }()
    
    private let movieNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setContentHuggingPriority(.init(1), for: .vertical)
        return label
    }()
    
    private let rankIntenLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    private let audienceCountLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLayout()
        layer.borderWidth = 1.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        mainStackView.addArrangedSubview(rankLabel)
        mainStackView.addArrangedSubview(movieNameLabel)
        mainStackView.addArrangedSubview(rankIntenLabel)
        mainStackView.addArrangedSubview(audienceCountLabel)
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setUpContent(_ movieInformation: MovieInformationDTO) {
        rankLabel.text = movieInformation.rank
        rankIntenLabel.attributedText = movieInformation.conventedRankIntenSybolAndText()
        movieNameLabel.text = movieInformation.movieName
        
        let audienceCount = movieInformation.convertDecimalFormattedString(text: movieInformation.audienceCount)
        let audienceAccumulateCount = movieInformation.convertDecimalFormattedString(text: movieInformation.audienceAccumulate)
        
        audienceCountLabel.text = "오늘 \(audienceCount) / 총 \(audienceAccumulateCount)"
    }
}
