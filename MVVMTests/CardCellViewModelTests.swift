//
//  CardCellViewModelTest.swift
//  MVVMTests
//
//  Created by LanceMacBookPro on 11/3/22.
//

import XCTest
@testable import MVVM

class CardCellViewModelTests: XCTestCase {
    
    var cardCellViewModel: CardCellViewModel?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let card = Card(code: nil, image: nil, images: nil, value: "Ace", suit: "Spades")
        cardCellViewModel = CardCellViewModel(card: card)
        
        cardCellViewModel?.setData()
    }
    
    func testCardCellViewModelValueTextBinder() {
        
        cardCellViewModel?.valueText.bind(callback: { (txt) in
            XCTAssertEqual(txt, "Ace")
        })
    }
    
    func testCardCellViewModelSuitTextBinder() {
        
        cardCellViewModel?.suitText.bind(callback: { (txt) in
            XCTAssertEqual(txt, "Spades")
        })
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
        
        cardCellViewModel = nil
    }
}
