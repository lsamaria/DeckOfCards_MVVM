//
//  HomeCellViewModel.swift
//  MVVM
//
//  Created by LanceMacBookPro on 11/3/22.
//

import UIKit.UIImage

final class CardCellViewModel {
    
    // MARK: Ivars - Observers
    public var suitText: ObserverableObject<String?> = ObserverableObject(nil)
    
    public var valueText: ObserverableObject<String?> = ObserverableObject(nil)
    
    public var cardImage: ObserverableObject<UIImage?> = ObserverableObject(nil)
    
    // MARK: Ivars - URLSessionTask
    private var task: URLSessionTask?
    
    // MARK: - Ivars - Main
    private let card: Card
    
    // MARK: - Init
    init(card: Card) {
        self.card = card
    }
}

// MARK: - Cancel Task
extension CardCellViewModel {
    
    public func cancelTask() {
        
        task?.cancel()
        task = nil
    }
}

// MARK: - Set Observers
extension CardCellViewModel {
    
    public func setData() {
        
        setSuit()
        
        setValue()
        
        fetchCardImage()
    }
}

// MARK: - Business Logic
extension CardCellViewModel {
    
    private func setSuit() {
        
        suitText.value = card.suit ?? "Suit Unavailable"
    }
    
    private func setValue() {
        
        valueText.value = card.value ?? "Value Unavailable"
    }
    
    fileprivate func fetchCardImage() {
        
        guard let imgStr = card.image, let url = URL(string: imgStr) else { return }
        
        Service.fetchCellImage(with: url, and: &task) { [weak self](result) in
            
            switch result {
            
            case .failure(let sessionIssue):
                
                print("\ncard-image-falied-: ", sessionIssue.localizedDescription)
                
            case .success(let img):
                
                DispatchQueue.main.async { [weak self] in
                    self?.cardImage.value = img
                }
            }
        }
    }
}
