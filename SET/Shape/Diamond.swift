//
//  Diamond.swift
//  SET
//
//  Created by George Mapaya on 2022-06-06.
//

import SwiftUI

struct Diamond: InsettableShape {
    var insetAmount: CGFloat = 0.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let minX = rect.width * DiamondConstants.oneEighth
        let midX = rect.midX
        let midY = rect.midY
        
        path.move(to: CGPoint(x: minX, y: midY))
        path.addLines([
            CGPoint(x: midX, y: rect.height * DiamondConstants.oneEighth),
            CGPoint(x: rect.width * DiamondConstants.sevenEighth, y: midY),
            CGPoint(x: midX, y: rect.height * DiamondConstants.sevenEighth),
            CGPoint(x: minX, y: midY)
        ])
        path.closeSubpath()
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var diamond = self
        diamond.insetAmount += insetAmount
        return diamond
    }
}

extension Diamond {
    private struct DiamondConstants {
        static let oneEighth = 0.125
        static let sevenEighth = 0.875
    }
}
