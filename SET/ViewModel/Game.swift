//
//  Game.swift
//  SET
//
//  Created by George Mapaya on 2022-06-06.
//

import Foundation

final class Game: ObservableObject {
    @Published var deck: [Card]
    
    init() {
        deck = []
        loadDeck()
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
