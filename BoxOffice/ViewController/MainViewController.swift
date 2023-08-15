//
//  MainViewController.swift
//  BoxOffice
//
//  Created by Zion, Hemg on 13/01/23.
//

import UIKit

protocol MainViewControllerUseCaseDelegate: AnyObject {
    func completeFetchDailyBoxOfficeInformation(_ movieInformationDTOList: [MovieInformationDTO])
    func failFetchDailyBoxOfficeInformation(_ errorDescription: String?)
}

final class MainViewController: UIViewController, CanShowNetworkRequestFailureAlert {
    enum CollectionViewType {
        case icon
        case list
        
        var changeModeName: String {
            switch self {
            case .icon:
                return "리스트"
            case .list:
                return "아이콘"
            }
        }
    }
    
    enum Section {
        case main
    }
    
    private var collectionViewMode: CollectionViewType = .list {
        didSet {
            DispatchQueue.global().async {
                guard var snapShot = self.diffableDataSource?.snapshot() else { return }

                snapShot.reloadSections([.main])
                self.diffableDataSource?.apply(snapShot)
            }
        }
    }
    
    private let usecase: MainViewControllerUseCase
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .large
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let refreshAction = UIAction { [weak self] _ in
            self?.setUpViewControllerContents()
        }
        
        refreshControl.addAction(refreshAction, for: .valueChanged)
        return refreshControl
    }()
    
    private let listCompositionalLayout: UICollectionViewCompositionalLayout = {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        
        listConfiguration.separatorConfiguration.bottomSeparatorInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let compositionalLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return compositionalLayout
    }()
    
    private let iconCompositionalLayout: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        let section = NSCollectionLayoutSection(group: group)
        let compositionalLayout = UICollectionViewCompositionalLayout(section: section)
        
        return compositionalLayout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: listCompositionalLayout)
        
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, MovieInformationDTO>?
    
    init(_ usecase: MainViewControllerUseCase) {
        self.usecase = usecase
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpConstraints()
        setUpViewController()
        setUpToolBar()
        setUpViewControllerContents()
        setUpDiffableDataSource()
    }
    
    
    private func setUpViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.title = usecase.yesterdayDate
    }
    
    private func setUpToolBar() {
        navigationController?.isToolbarHidden = false
        
        let leftFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let barButtonItem = UIBarButtonItem(title: "화면 모드 변경", style: .plain, target: self, action: #selector(didTappedChangeMode))
        let rightflexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [leftFlexibleSpace, barButtonItem, rightflexibleSpace]
    }
    
    private func setUpViewControllerContents() {
        let targetDate = usecase.yesterdayDate.replacingOccurrences(of: "-", with: "")
        
        usecase.fetchDailyBoxOffice(targetDate: targetDate)
    }
    
    private func configureUI() {
        [collectionView, activityIndicatorView].forEach { view.addSubview($0) }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpDiffableDataSource() {
        let listCellResgistration = UICollectionView.CellRegistration<MainCollectionViewCell, MovieInformationDTO> { cell, indexPath, movieInformation in
            
            cell.setUpContent(movieInformation)
        }
        
        let iconCellResgistration = UICollectionView.CellRegistration<MainCollectionViewIconCell, MovieInformationDTO> { cell, indexPath, movieInformation in

            cell.setUpContent(movieInformation)
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource<Section, MovieInformationDTO>(collectionView: collectionView, cellProvider: { collectionView, indexPath, movieInformation in
            switch self.collectionViewMode {
            case .list:
                return collectionView.dequeueConfiguredReusableCell(using: listCellResgistration, for: indexPath, item: movieInformation)
            case .icon:
                return collectionView.dequeueConfiguredReusableCell(using: iconCellResgistration, for: indexPath, item: movieInformation)
            }
        })
    }
    
    private func stopRefreshing() {
        self.refreshControl.endRefreshing()
        
        if self.activityIndicatorView.isAnimating {
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    @objc private func didTappedChangeMode() {
        let alertController = UIAlertController()
        let changeAction = UIAlertAction(title: collectionViewMode.changeModeName, style: .default) { _ in
            self.changeCollectionViewMode()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        alertController.title = "화면 모드 변경"
        alertController.addAction(changeAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func changeCollectionViewMode() {
        if collectionViewMode == .list {
            collectionView.setCollectionViewLayout(iconCompositionalLayout, animated: true)
            collectionViewMode = .icon
        } else {
            collectionView.setCollectionViewLayout(listCompositionalLayout, animated: true)
            collectionViewMode = .list
        }
    }
}

// MARK: - MainViewControllerUseCaseDelegate
extension MainViewController: MainViewControllerUseCaseDelegate {
    func completeFetchDailyBoxOfficeInformation(_ movieInformationDTOList: [MovieInformationDTO]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, MovieInformationDTO>()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(movieInformationDTOList)
        diffableDataSource?.apply(snapShot)
        
        DispatchQueue.main.async {
            self.stopRefreshing()
        }
    }
    
    func failFetchDailyBoxOfficeInformation(_ errorDescription: String?) {
        DispatchQueue.main.async {
            self.stopRefreshing()
            self.showNetworkFailAlert(message: errorDescription, retryFunction: self.setUpViewControllerContents)
        }
    }
}

// MARK: - CollectionView Delegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieInformation = diffableDataSource?.snapshot().itemIdentifiers[indexPath.row]
        let movieCode = movieInformation?.movieCode ?? ""
        let movieName = movieInformation?.movieName ?? ""

        let sessionProvider: URLSessionProvider = URLSessionProviderImplementation()
        let daumSearchRepository: DaumSearchRepository = DaumSearchRepositoryImplementation(sessionProvider: sessionProvider)
        let boxOfficeRepository: BoxOfficeRepository = BoxOfficeRepositoryImplementation(sessionProvider: sessionProvider)
        let usecase = MovieDetailViewControllerUseCaseImplementation(boxOfficeRepository: boxOfficeRepository,
                                                                     daumSearchRepository: daumSearchRepository)
        let movieDetailViewController = MovieDetailViewController(usecase: usecase, movieCode: movieCode, movieName: movieName)

        usecase.delegate = movieDetailViewController
        navigationController?.pushViewController(movieDetailViewController, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
