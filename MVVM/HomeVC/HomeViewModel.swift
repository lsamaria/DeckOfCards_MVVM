//
//  HomeViewModel.swift
//  MVVM
//
//  Created by LanceMacBookPro on 11/3/22.
//

import UIKit.UIColor

class HomeViewModel {
    
    let title = "Deck of Cards"
    
    let backgroundColor = UIColor.white
    
    var datasource = [CardCellViewModel]()
    
    let apiEndpoint = "https://deckofcardsapi.com/api/deck/new/draw/?count=52"
}

// MARK: - Fetch Deck/Cards
extension HomeViewModel {
    
    func fetchCards(completion: @escaping ()->Void) {
        
        guard let url = URL(string: apiEndpoint) else {
            print("\napiEndpoint is incorrect")
            completion()
            return
        }
        
        Service.fetchAPIObject(with: url) { (result) in
            
            switch result {
            
            case .failure(let sessionIssue):
                
                switch sessionIssue {
                
                case .errorIssue, .responseStatusCodeIssue, .dataIsNil:
                    print("\nurl-session-error-: ", sessionIssue)
                case .malformedData:
                    print("\nmalformed-data-error-: ", sessionIssue)
                }
                
                completion()
                
            case .success(let cards):
                
                DispatchQueue.main.async { [weak self] in
                    
                    self?.setDatasource(with: cards, completion: completion)
                }
            }
        }
    }
}

// MARK: - Set Datasource
extension HomeViewModel {
    
    private func setDatasource(with cards: [Card], completion: @escaping ()->Void) {
        
        if cards.isEmpty {
            print("\nnothing to display in datasource")
            completion()
            return
        }
        
        datasource = cards.compactMap({
            
            CardCellViewModel(card: $0)
        })
        
        completion()
    }
}
