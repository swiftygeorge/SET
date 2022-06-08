//
//  Game.swift
//  SET
//
//  Created by George Mapaya on 2022-06-06.
//

import Foundation

final class Game: ObservableObject {
    @Published var deck: [Card]
    @Published var dealtCards: [Card]
    @Published var discardedCards: [Card]
    
    private(set) var selectedCards: [Card]
    private(set) var isInitialDeal: Bool
    private(set) var matchedCardsNotDiscarded: Bool
    private(set) var setTestFailed: Bool
    
    private var noSelections: Bool { selectedCards.isEmpty }
    private var readyToMatch: Bool { selectedCards.count == 3 }
    var deckIsEmpty: Bool { deck.isEmpty }
    var noDiscardedCards: Bool { discardedCards.isEmpty }
    var canDeal: Bool { deck.count >= 3 }
    
    init() {
        deck = []
        dealtCards = []
        selectedCards = []
        discardedCards = []
        isInitialDeal = true
        matchedCardsNotDiscarded = false
        setTestFailed = false
        loadDeck()
    }
    
    func deal(card: Card, index: Int? = nil) {
        if let topCard = deck.last, topCard.id == card.id {
            var dealtCard = deck.removeLast()
            dealtCard.deal()
            if let index = index {
                discard(at: index)
                dealtCards.insert(dealtCard, at: index)
                selectedCards.removeFirst()
            } else {
                dealtCards.append(dealtCard)
            }
        }
    }
    
    func select(card: Card) {
        if let indexOfSelectedCard = dealtCards.firstIndex(where: { $0.id == card.id }) {
            dealtCards[indexOfSelectedCard].select()
            if dealtCards[indexOfSelectedCard].isSelected {
                selectedCards.append(card)
            } else {
                selectedCards = selectedCards.filter({ $0.id != card.id })
            }
        }
        if readyToMatch {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.match() ? self.recordMatch() : self.recordMismatch()
            }
        }
    }
    
    func deselect(at index: Int) {
        dealtCards[index].select()
    }
    
    func discard(at index: Int) {
        var discardedCard = dealtCards.remove(at: index)
        discardedCard.isSetMember = false
        discardedCard.discard()
        discardedCards.append(discardedCard)
    }
    
    func recordDiscard() {
        selectedCards = []
        matchedCardsNotDiscarded = false
    }
    
    func resetFailedTest() {
        selectedCards = []
        setTestFailed = false
    }
    
    func unfail(at index: Int) {
        dealtCards[index].unfail()
    }
    
    func initialize() { isInitialDeal = false }
    
    private func recordMatch() {
        for selectedCard in selectedCards {
            if let indexInDealtCards = dealtCards.firstIndex(where: { $0.id == selectedCard.id }) {
                dealtCards[indexInDealtCards].set()
                dealtCards[indexInDealtCards].match()
                deselect(at: indexInDealtCards)
            }
        }
        matchedCardsNotDiscarded = true
    }
    
    private func recordMismatch() {
        for selectedCard in selectedCards {
            if let indexInDealtCards = dealtCards.firstIndex(where: { $0.id == selectedCard.id }) {
                dealtCards[indexInDealtCards].fail()
            }
        }
        setTestFailed = true
    }
    
    private func match() -> Bool {
        let cardOne = selectedCards[0]
        let cardTwo = selectedCards[1]
        let cardThree = selectedCards[2]
        // same features
        let sameSymbolCount = cardOne.mainSymbolCount == cardTwo.mainSymbolCount && cardOne.mainSymbolCount == cardThree.mainSymbolCount
        let sameSymbol = cardOne.mainSymbol == cardTwo.mainSymbol && cardOne.mainSymbol == cardThree.mainSymbol
        let sameOpacity = cardOne.mainOpacity == cardTwo.mainOpacity && cardOne.mainOpacity == cardThree.mainOpacity
        let sameColor = cardOne.mainColor == cardTwo.mainColor && cardOne.mainColor == cardThree.mainColor
        // different features
        let differentSymbolCount = cardOne.mainSymbolCount != cardTwo.mainSymbolCount && cardOne.mainSymbolCount != cardThree.mainSymbolCount && cardTwo.mainSymbolCount != cardThree.mainSymbolCount
        let differentSymbol = cardOne.mainSymbol != cardTwo.mainSymbol && cardOne.mainSymbol != cardThree.mainSymbol && cardTwo.mainSymbol != cardThree.mainSymbol
        let differentOpacity = cardOne.mainOpacity != cardTwo.mainOpacity && cardOne.mainOpacity != cardThree.mainOpacity && cardTwo.mainOpacity != cardThree.mainOpacity
        let differentColor = cardOne.mainColor != cardTwo.mainColor && cardOne.mainColor != cardThree.mainColor && cardTwo.mainColor != cardThree.mainColor
        
        if (sameSymbolCount || differentSymbolCount) &&
            (sameSymbol || differentSymbol) &&
            (sameOpacity || differentOpacity) &&
            (sameColor || differentColor) {
            return true
        }
        return false
    }
    
    private func loadDeck() {
        var cards = Array<Card>()
        for mainSymbol in Card.MainSymbol.allCases {
            let symbolCards = createCards(for: mainSymbol)
            cards += symbolCards
        }
        deck = cards
    }
    
    private func createCards(for mainSymbol: Card.MainSymbol) -> [Card] {
        var cards = Array<Card>()
        for count in 1...3 {
            for mainColor in Card.MainColor.allCases {
                for mainOpacity in Card.MainOpacity.allCases {
                    cards.append(Card(mainSymbol: mainSymbol, mainSymbolCount: count, mainColor: mainColor, mainOpacity: mainOpacity))
                }
            }
        }
        return cards
    }
}
