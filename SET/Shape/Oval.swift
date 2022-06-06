//
//  Oval.swift
//  SET
//
//  Created by George Mapaya on 2022-06-06.
//

import SwiftUI

struct Oval: InsettableShape {
    var insetAmount: CGFloat = 0.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let quarterWidth = rect.width * OvalConstants.quarter
        let threeQuarterWidth = rect.width * OvalConstants.threeQuarters
        let quarterHeight = rect.height * OvalConstants.quarter
        let threeQuarterHeight = rect.height * OvalConstants.threeQuarters
        
        path.move(to: CGPoint(x: threeQuarterWidth, y: quarterHeight))
        path.addLine(to: CGPoint(x: quarterWidth, y: quarterHeight))
        path.addArc(center: CGPoint(x: threeQuarterWidth, y: rect.midY), radius: quarterHeight, startAngle: -OvalConstants.ninetyDegreeAngle, endAngle: OvalConstants.ninetyDegreeAngle, clockwise: false)
        path.addLine(to: CGPoint(x: quarterWidth, y: threeQuarterHeight))
        path.addArc(center: CGPoint(x: quarterWidth, y: rect.midY), radius: quarterHeight, startAngle: OvalConstants.ninetyDegreeAngle, endAngle: -OvalConstants.ninetyDegreeAngle, clockwise: false)
        path.closeSubpath()
        
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var oval = self
        oval.insetAmount += insetAmount
        return oval
    }
}

extension Oval {
    private struct OvalConstants {
        static let quarter = 0.25
        static let threeQuarters = 0.75
        static let ninetyDegreeAngle = Angle(degrees: 90.0)
        static let negativeNinetyDegreeAngle = Angle(degrees: 270.0)
    }
}

