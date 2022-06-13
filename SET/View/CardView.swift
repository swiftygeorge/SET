//
//  CardView.swift
//  SET
//
//  Created by George Mapaya on 2022-06-06.
//

import SwiftUI

struct CardView: View {
    let card: Card
    @State private var symbolPulse: CGFloat = 1
    @State private var shakeCount = 0
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            
            if card.hasBeenDealt {
                ZStack {
                    RoundedRectangle(cornerRadius: CardConstants.cornerRadius)
                        .stroke(strokeColor(), lineWidth: lineWidth())
                    cardBackground()
                    VStack {
                        ForEach(0..<card.mainSymbolCount, id:\.self) { count in
                            ZStack {
                                if card.isSetMember {
                                    symbol(card.mainSymbol, width: width)
                                        .scaleEffect(symbolPulse)
                                        .onAppear {
                                            withAnimation(.easeInOut.repeatForever(autoreverses: true)) {
                                                symbolPulse = 1.05 * symbolPulse
                                            }
                                        }
                                } else {
                                    if card.failedSetTest {
                                        symbol(card.mainSymbol, width: width)
                                            .aspectRatio(CardConstants.aspectRatio, contentMode: .fit)
                                            .frame(maxWidth: width * CardConstants.widthFactor)
                                            .modifier(ShakeEffect(animatableData: CGFloat(shakeCount)))
                                            .onAppear {
                                                withAnimation { shakeCount = 3 }
                                            }
                                    } else {
                                        symbol(card.mainSymbol, width: width)
                                            .aspectRatio(CardConstants.aspectRatio, contentMode: .fit)
                                            .frame(maxWidth: width * CardConstants.widthFactor)
                                            .onAppear { shakeCount = 0 }
                                    }
                                }
                            }
                        }
                    }
                    .padding(width * CardConstants.paddingFactor)
                }
            } else {
                cardBackground()
                    .overlay(
                        RoundedRectangle(cornerRadius: CardConstants.cornerRadius)
                            .stroke(CardConstants.gradient, lineWidth: CardConstants.lineWidth)
                    ) // overlay
            }
        }
    }
    
    private func mainColor() -> Color {
        switch card.mainColor {
        case .mainGreen:
            return .green
        case .mainPurple:
            return .purple
        case .mainRed:
            return .red
        }
    }
    
    private func strokeColor() -> Color {
        withAnimation {
            card.isSelected ? .blue : card.isSetMember ? mainColor() : .secondary.opacity(0.4)
        }
    }
    
    private func lineWidth() -> CGFloat {
        withAnimation {
            card.isSetMember ? 2 : CardConstants.lineWidth
        }
    }
    
    private func symbol(_ symbol: Card.MainSymbol, width: CGFloat) -> some View {
        createView(for: symbol)
            .aspectRatio(CardConstants.aspectRatio, contentMode: .fit)
            .frame(maxWidth: width * CardConstants.widthFactor)
    }
    
    @ViewBuilder
    private func createView(for symbol: Card.MainSymbol) -> some View {
        switch symbol {
        case .diamond:
            Diamond()
                .stroke(mainColor(), lineWidth: CardConstants.lineWidth)
                .background(Diamond().fill((mainColor().opacity(card.mainOpacity.level))))
        case .oval:
            Oval()
                .stroke(mainColor(), lineWidth: CardConstants.lineWidth)
                .background(Oval().fill((mainColor().opacity(card.mainOpacity.level))))
        case .squiggle:
            Squiggle()
                .stroke(mainColor(), lineWidth: CardConstants.lineWidth)
                .background(Squiggle().fill((mainColor().opacity(card.mainOpacity.level))))
        }
    }
    
    @ViewBuilder
    private func cardBackground() -> some View {
        if card.hasBeenDealt {
            RoundedRectangle(cornerRadius: CardConstants.cornerRadius)
                .fill(CardConstants.systemBackground)
                .shadow(color: CardConstants.shadowColor, radius: CardConstants.shadowRadius, x: CardConstants.shadowXOffset, y: CardConstants.shadowYOffset)
        } else {
            RoundedRectangle(cornerRadius: CardConstants.cornerRadius)
                .fill(CardConstants.gradient)
                .shadow(color: CardConstants.shadowColor, radius: CardConstants.shadowRadius, x: CardConstants.shadowXOffset, y: CardConstants.shadowYOffset)
        }
    }
}

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)), y: 0))
    }
}

extension CardView {
    private struct CardConstants {
        static let cornerRadius = 10.0
        static let systemBackground = Color(UIColor.systemBackground)
        static let widthFactor = 0.75
        static let lineWidth = 2.0
        static let aspectRatio: CGFloat = 3/2
        static let paddingFactor = 0.1
        static let shadowRadius = 0.0
        static let shadowColor: Color = .secondary.opacity(0.5)
        static let shadowXOffset: CGFloat = 2
        static let shadowYOffset: CGFloat = 2
        static let gradient = LinearGradient(colors: [.green, .purple, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
        static let rotationAngle: Angle = .degrees(1080)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardView(card: SampleData.diamondOne)
            CardView(card:SampleData.diamondTwo)
                .preferredColorScheme(.dark)
            CardView(card:SampleData.diamondThree)
        }
        .previewLayout(.fixed(width: 200, height: 300))
        .padding()
    }
}
