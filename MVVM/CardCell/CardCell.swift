//
//  CardCell.swift
//  MVVM
//
//  Created by LanceMacBookPro on 11/3/22.
//

import UIKit

final class CardCell: UICollectionViewCell {
    
    // MARK: - UIElements
    private lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 7
        return imageView
    }()
    
    private lazy var cardImageViewNetworkSpinner: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.color = .white
        return activityIndicatorView
    }()
    
    private lazy var suitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    // MARK: - Ivars
    static let identifier = "CardCell"
    
    public var cardCellViewModel: CardCellViewModel? {
        didSet {
            
            guard let cardCellViewModel = cardCellViewModel else { return }
            
            cardImageViewNetworkSpinner.startAnimating()
            
            setupBinders(for: cardCellViewModel)
            
            cardCellViewModel.setData()
            
            layoutUI()
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cardCellViewModel?.cancelTask()
        cardImageView.image = nil
    }
}

// MARK: - Binders
extension CardCell {
    
    private func setupBinders(for cardCellViewModel: CardCellViewModel) {
        
        cardCellViewModel.suitText.bind { [weak self](text) in
            self?.suitLabel.text = text
        }
        
        cardCellViewModel.valueText.bind { [weak self](text) in
            self?.valueLabel.text = text
        }
        
        cardCellViewModel.cardImage.bind { [weak self](img) in
            self?.cardImageView.image = img
            self?.cardImageViewNetworkSpinner.stopAnimating()
        }
    }
}

// MARK: - LayoutUI
extension CardCell {
    
    private func layoutUI() {
        
        contentView.addSubview(cardImageView)
        cardImageView.addSubview(cardImageViewNetworkSpinner)
        contentView.addSubview(suitLabel)
        contentView.addSubview(valueLabel)
        
        let cardImageViewLeadingPadding: CGFloat = 8
        let cardImageViewWidthHeight: CGFloat = 80
        
        cardImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cardImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cardImageViewLeadingPadding).isActive = true
        cardImageView.widthAnchor.constraint(equalToConstant: cardImageViewWidthHeight).isActive = true
        cardImageView.heightAnchor.constraint(equalToConstant: cardImageViewWidthHeight).isActive = true
        
        cardImageViewNetworkSpinner.centerYAnchor.constraint(equalTo: cardImageView.centerYAnchor).isActive = true
        cardImageViewNetworkSpinner.centerXAnchor.constraint(equalTo: cardImageView.centerXAnchor).isActive = true
        
        let suitLabelLeadingPadding: CGFloat = 5
        let suitLabelTrailingPadding: CGFloat = 8
        
        suitLabel.centerYAnchor.constraint(equalTo: cardImageView.centerYAnchor).isActive = true
        suitLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: suitLabelLeadingPadding).isActive = true
        suitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -suitLabelTrailingPadding).isActive = true
        
        valueLabel.bottomAnchor.constraint(equalTo: suitLabel.topAnchor).isActive = true
        valueLabel.leadingAnchor.constraint(equalTo: suitLabel.leadingAnchor).isActive = true
        valueLabel.trailingAnchor.constraint(equalTo: suitLabel.trailingAnchor).isActive = true
    }
}
