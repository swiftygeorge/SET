//
//  SampleData.swift
//  SET
//
//  Created by George Mapaya on 2022-06-06.
//

import Foundation

struct SampleData {
    static let diamondOne = Card(mainSymbol: .diamond, mainSymbolCount: 1, mainColor: .mainGreen, mainOpacity: .transparent, isSelected: false, hasBeenDealt: true)
    static let diamondTwo = Card(mainSymbol: .diamond, mainSymbolCount: 2, mainColor: .mainGreen, mainOpacity: .translucent, isSelected: false, hasBeenDealt: true)
    static let diamondThree = Card(mainSymbol: .diamond, mainSymbolCount: 3, mainColor: .mainGreen, mainOpacity: .opaque, isSelected: false, hasBeenDealt: true)
    static let ovalOne = Card(mainSymbol: .oval, mainSymbolCount: 1, mainColor: .mainPurple, mainOpacity: .transparent, hasBeenDealt: true)
    static let ovalTwo = Card(mainSymbol: .oval, mainSymbolCount: 2, mainColor: .mainPurple, mainOpacity: .translucent, hasBeenDealt: true)
    static let ovalThree = Card(mainSymbol: .oval, mainSymbolCount: 3, mainColor: .mainPurple, mainOpacity: .opaque, hasBeenDealt: true)
    static let squiggleOne = Card(mainSymbol: .squiggle, mainSymbolCount: 1, mainColor: .mainRed, mainOpacity: .transparent, hasBeenDealt: true)
    static let squiggleTwo = Card(mainSymbol: .squiggle, mainSymbolCount: 2, mainColor: .mainRed, mainOpacity: .translucent, hasBeenDealt: true)
    static let squiggleThree = Card(mainSymbol: .squiggle, mainSymbolCount: 3, mainColor: .mainRed, mainOpacity: .opaque, hasBeenDealt: true)
}
