//
//  SetView.swift
//  SET
//
//  Created by George Mapaya on 2022-06-06.
//

import SwiftUI

struct SetView: View {
    @EnvironmentObject private var game: Game
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack {
                    GeometryReader { geometry in
                        AspectVGrid(cards: game.deck, aspectRatio: SetConstants.aspectRatio, size: geometry.size, initialDeal: game.isInitialDeal) { card in
                            CardView(card: card)
                                .padding(SetConstants.cardPadding)
                        }
                    }
                }
                .frame(height: geo.size.height * 0.5)
                .fixedSize(horizontal: false, vertical: true)
            }
            .padding([.top, .horizontal])
//            .frame(height: geo.size.height)
        }
        
    }
}

extension SetView {
    private struct SetConstants {
        static let cornerRadius: CGFloat = 10.0
        static let lineWidth = 1.0
        static let aspectRatio: CGFloat = 2/3
        static let animationDuration = 0.4
        static let delayFactor = 0.2
        static let width: CGFloat = 50.0
        static let cardPadding: CGFloat = 4.0
        static let dozenCards = 12
        static let threeCards = 3
        static let systemBackground = Color(UIColor.systemBackground)
    }
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        SetView()
            .environmentObject(Game())
    }
}
