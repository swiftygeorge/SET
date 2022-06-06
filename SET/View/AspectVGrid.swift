//
//  AspectVGrid.swift
//  SET
//
//  Created by George Mapaya on 2022-06-06.
//

import SwiftUI

struct AspectVGrid<Card, CardView>: View where CardView: View, Card: Identifiable {
    var cards: [Card]
    var aspectRatio: CGFloat
    var size: CGSize
    var initialDeal: Bool
    var content: (Card) -> CardView
    
    init(cards: [Card], aspectRatio: CGFloat, size: CGSize, initialDeal: Bool, @ViewBuilder content: @escaping (Card) -> CardView) {
        self.cards = cards
        self.aspectRatio = aspectRatio
        self.size = size
        self.initialDeal = initialDeal
        self.content = content
    }
    
    var body: some View {
        VStack {
            let width = widthThatFits(cardCount: cards.count, in: size, cardAspectRatio: aspectRatio)
            let columns = self.initialDeal ? fixedWidth(cardCount: 4) : [adaptiveWidth(width: width)]
            LazyVGrid(columns: columns) {
                ForEach(cards) { card in
                    content(card)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                }
                Spacer(minLength: 0)
            }
        }
    }
    
    private func adaptiveWidth(width: CGFloat) -> GridItem {
        GridItem(.adaptive(minimum: width))
    }
    
    private func fixedWidth(cardCount: Int) -> [GridItem] {
        Array(repeating: GridItem(), count: cardCount)
    }
    
    private func widthThatFits(cardCount: Int, in size: CGSize, cardAspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = cardCount
        repeat {
            let cardWidth = size.width / CGFloat(columnCount)
            let cardHeight = cardWidth / cardAspectRatio
            if (CGFloat(rowCount) * cardHeight) < size.height { break }
            columnCount += 1
            rowCount = (cardCount + (columnCount - 1)) / columnCount
        } while columnCount < cardCount
        return withAnimation { floor(size.width / CGFloat(columnCount)) }
    }
}
