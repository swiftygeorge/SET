//
//  Squiggle.swift
//  SET
//
//  Created by George Mapaya on 2022-06-06.
//

import SwiftUI

struct Squiggle: InsettableShape {
    var insetAmount: CGFloat = 0.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let halfWidth = width * SquiggleConstants.half
        let quarterHeight = height * SquiggleConstants.quarter
        
        path.move(to: CGPoint(x: halfWidth, y: quarterHeight))
        path.addQuadCurve(to: CGPoint(x: width * SquiggleConstants.zeroPointNineTwoFive, y: height * SquiggleConstants.zeroPointZeroTwoFive), control: CGPoint(x: width * SquiggleConstants.zeroPointSeven, y: height * SquiggleConstants.oneThird))
        path.addQuadCurve(to: CGPoint(x: width * SquiggleConstants.zeroPointNineSevenFive, y: height * SquiggleConstants.oneEighth), control: CGPoint(x: width * SquiggleConstants.zeroPointNineSevenFive, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: halfWidth, y: height * SquiggleConstants.threeQuarters), control: CGPoint(x: rect.maxX, y: height * SquiggleConstants.sevenEighths))
        path.addQuadCurve(to: CGPoint(x: width * SquiggleConstants.zeroPointZeroSevenFive, y: height * SquiggleConstants.zeroPointNineSevenFive), control: CGPoint(x: width * SquiggleConstants.oneThird, y: height * SquiggleConstants.zeroPointSeven))
        path.addQuadCurve(to: CGPoint(x: width * SquiggleConstants.zeroPointZeroTwoFive, y: height * SquiggleConstants.sevenEighths), control: CGPoint(x: width * SquiggleConstants.zeroPointZeroTwoFive, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: halfWidth, y: height * SquiggleConstants.quarter), control: CGPoint(x: rect.minX, y: height * SquiggleConstants.oneEighth))
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var squiggle = self
        squiggle.insetAmount += insetAmount
        return squiggle
    }
}

extension Squiggle {
    private struct SquiggleConstants {
        static let zeroPointZeroTwoFive = 0.025
        static let zeroPointZeroSevenFive = 0.075
        static let oneEighth = 0.125
        static let sevenEighths = 0.875
        static let zeroPointNineTwoFive = 0.925
        static let zeroPointNineSevenFive = 0.975
        static let quarter = 0.25
        static let oneThird = 0.3
        static let half = 0.5
        static let zeroPointSeven = 0.7
        static let threeQuarters = 0.75
        static let threeEighths = 0.875
    }
}
