//
//  SetView.swift
//  SET
//
//  Created by George Mapaya on 2022-06-06.
//

import SwiftUI

struct SetView: View {
    @EnvironmentObject private var game: Game
    
    @Namespace private var dealingNamespace
    @Namespace private var discardingNamespace
    
    @State private var shakeCount = 0
    
    var failSetTest: Bool { game.setTestFailed }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack {
                    GeometryReader { geometry in
                        AspectVGrid(cards: game.dealtCards, aspectRatio: SetConstants.aspectRatio, size: geometry.size, initialDeal: game.isInitialDeal) { card in
                            CardView(card: card)
                                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                                .matchedGeometryEffect(id: card.id, in: discardingNamespace)
                                .padding(SetConstants.cardPadding)
                                .scaleEffect(card.isSelected ? 0.85 : 1.0)
                                .onTapGesture { self.choose(card: card) }
                                .animation(.easeInOut, value: card.isSelected)
                                .disabled(card.isSetMember)
                        }
                        .onChange(of: game.setTestFailed) { newValue in
                            if game.setTestFailed {
                                shakeCount = 2
                            } else {
                                shakeCount = 0
                            }
                        }
                    }
                }
                .frame(height: geo.size.height * 0.5)
                .fixedSize(horizontal: false, vertical: true)
                Spacer()
                controls
            }
            .padding([.top, .horizontal])
        }
    }
    
    private var controls: some View {
        HStack {
            Spacer()
            deck().onTapGesture { self.deal() }
            Spacer()
            Spacer()
            discardedStack()
            Spacer()
        }
    }
    
    private func emptyStack() -> some View {
        RoundedRectangle(cornerRadius: SetConstants.cornerRadius)
            .stroke(.secondary, lineWidth: SetConstants.lineWidth)
            .aspectRatio(SetConstants.aspectRatio, contentMode: .fit)
            .frame(width: SetConstants.width)
    }
    
    private func deck() -> some View {
        VStack {
            if game.deckIsEmpty {
               emptyStack()
            } else {
                ZStack {
                    ForEach(game.deck) { card in
                        CardView(card: card)
                            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                            .aspectRatio(SetConstants.aspectRatio, contentMode: .fit)
                            .frame(width: SetConstants.width)
                    }
                }
            }
            controlTitle(text: "Deal", textColor: game.canDeal ? .blue : .secondary)
        }
    }
    
    private func discardedStack() -> some View {
        VStack {
            if game.noDiscardedCards {
                emptyStack()
            } else {
                ZStack {
                    ForEach(game.discardedCards) { card in
                        CardView(card: card)
                            .matchedGeometryEffect(id: card.id, in: discardingNamespace)
                            .aspectRatio(SetConstants.aspectRatio, contentMode: .fit)
                            .frame(width: SetConstants.width)
                    }
                }
            }
            controlTitle(text: "Matched", textColor: SetConstants.systemBackground)
        }
    }
    
    @ViewBuilder
    private func controlTitle(text: String, textColor: Color) -> some View {
        Text(text)
            .font(.caption)
            .foregroundColor(textColor)
    }
    
    private func deal() {
        if game.isInitialDeal {
            for count in 0..<12 {
                if let topCard = game.deck.last {
                    withAnimation(createAnimation(count: count)) {
                        game.deal(card: topCard)
                    }
                }
            }
            game.initialize()
        } else {
            for count in 0..<3 {
                if let topCard = game.deck.last {
                    if let indexOfMatchedCard = game.dealtCards.firstIndex(where: { $0.isSetMember}) {
                        withAnimation(createAnimation(count: count)) {
                            game.deal(card: topCard, index: indexOfMatchedCard)
                        }
                    } else {
                        withAnimation(createAnimation(count: count)) {
                            game.deal(card: topCard)
                        }
                    }
                }
            }
        }
    }
    
    private func choose(card: Card) {
        if game.matchedCardsNotDiscarded {
            for count in 0..<3 {
                if let indexOfSetMember = game.dealtCards.firstIndex(where: { $0.isSetMember }) {
                    withAnimation(createAnimation(count: count)) {
                        game.discard(at: indexOfSetMember)
                    }
                }
            }
            game.recordDiscard()
            game.select(card: card)
        } else if game.setTestFailed {
            for index in game.dealtCards.indices {
                if game.dealtCards[index].failedSetTest {
                    game.unfail(at: index)
                    game.deselect(at: index)
                }
            }
            game.resetFailedTest()
            game.select(card: card)
        } else {
            game.select(card: card)
        }
    }
    
    private func createAnimation(count: Int) -> Animation {
        let delay = Double(count) * SetConstants.dealingDelayFactor
        return .easeInOut(duration: SetConstants.animationDuration).delay(delay)
    }
}

extension SetView {
    private struct SetConstants {
        static let cornerRadius: CGFloat = 10.0
        static let lineWidth = 1.0
        static let aspectRatio: CGFloat = 2/3
        static let animationDuration = 0.4
        static let dealingDelayFactor = 0.3
        static let discardingDelayFactor = 0.2
        static let width: CGFloat = 50.0
        static let cardPadding: CGFloat = 4.0
        static let dozenCards = 12
        static let threeCards = 3
        static let systemBackground = Color(UIColor.systemBackground)
    }
}

struct RotationEffect: Animatable {
    
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SetView()
                .environmentObject(Game())
            SetView()
                .preferredColorScheme(.dark)
                .environmentObject(Game())
        }
    }
}
