//
//  HomeController.swift
//  MVVM
//
//  Created by LanceMacBookPro on 11/3/22.
//

import UIKit

class HomeController: UIViewController {
    
    // MARK: - Init
    init(with homeViewModel: HomeViewModel) {
        
        self.homeViewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = homeViewModel.title
        view.backgroundColor = homeViewModel.backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIElements
    private lazy var collectionView: UICollectionView = {
        
        let verticalPadding: CGFloat = 25
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = verticalPadding
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: verticalPadding, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.alwaysBounceVertical = true
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        
        cv.register(CardCell.self, forCellWithReuseIdentifier: CardCell.identifier)
        
        return cv
    }()
    
    private lazy var networkSpinner: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.center = view.center
        activityIndicatorView.color = .gray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }()
    
    // MARK: - Ivars
    private let homeViewModel: HomeViewModel
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutUI()
        
        fetchAPIData()
    }
}

// MARK: - Fetch Data
extension HomeController {
    
    private func fetchAPIData() {
        
        homeViewModel.fetchCards { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.networkSpinner.stopAnimating()
                self?.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as? CardCell else {
            return UICollectionViewCell()
        }
        
        cell.cardCellViewModel = homeViewModel.datasource[indexPath.item]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height: CGFloat = 80
        return CGSize(width: width, height: height)
    }
}

// MARK: - LayoutUI
extension HomeController {
    
    private func layoutUI() {
        
        view.addSubview(collectionView)
        view.addSubview(networkSpinner)
    }
}
