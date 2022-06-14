//
//  Card.swift
//  SET
//
//  Created by George Mapaya on 2022-06-06.
//

import Foundation

struct Card: Identifiable {
    let id: UUID
    
    var mainSymbol: MainSymbol
    var mainSymbolCount: Int
    var mainColor: MainColor
    var mainOpacity: MainOpacity
    
    var isSelected: Bool
    var isSetMember: Bool
    var failedSetTest: Bool
    var hasBeenDealt: Bool
    var hasBeenMatched: Bool
    
    init(mainSymbol: MainSymbol, mainSymbolCount: Int, mainColor: MainColor, mainOpacity: MainOpacity, isSelected: Bool = false, isSetMember: Bool = false, failedSetTest: Bool = false, hasBeenDealt: Bool = false, hasBeenMatched: Bool = false) {
        self.id = UUID()
        self.mainSymbol = mainSymbol
        self.mainSymbolCount = mainSymbolCount
        self.mainColor = mainColor
        self.mainOpacity = mainOpacity
        self.isSelected = isSelected
        self.isSetMember = isSetMember
        self.failedSetTest = failedSetTest
        self.hasBeenDealt = hasBeenDealt
        self.hasBeenMatched = hasBeenMatched
    }
    
    mutating func deal() { hasBeenDealt = true }
    
    mutating func select() { isSelected.toggle() }
    
    mutating func set() { isSetMember = true }
    
    mutating func unset() { isSetMember = false }
    
    mutating func fail() { failedSetTest = true }
    
    mutating func unfail() { failedSetTest = false }
    
    mutating func match() { hasBeenMatched = true }
    
    mutating func unmatch() { hasBeenMatched = false }
    
    mutating func undeal() { hasBeenDealt = false }
    
    mutating func discard() {
        isSetMember = false
        hasBeenMatched = false
    }
}

extension Card {
    enum MainSymbol: CaseIterable {
        case diamond, oval, squiggle
    }
    
    enum MainColor: CaseIterable {
        case mainGreen, mainPurple, mainRed
    }
    
    enum MainOpacity: CaseIterable {
        case opaque, translucent, transparent
        var level: Double {
            switch self {
            case .opaque:
                return 1.0
            case .translucent:
                return 0.5
            case .transparent:
                return 0.0
            }
        }
    }
}
