//
//  CardView.swift
//  RealSetGame
//
//  Created by Douglas castilho on 28/07/20.
//  Copyright © 2020 Vanessa Furtado. All rights reserved.
//

import UIKit


extension UIBezierPath {
    
    func createFilling(using shape : ShadingEnum, with color : UIColor){
        switch shape {
        case .filled:
            fillShape(of: self, with: color)
        case .stripped:
            strippedShape(of: self, with: color)
        default:
            break
        }
    }
    
    func fillShape(of path : UIBezierPath, with color : UIColor) {
        color.setFill()
        path.fill()
    }
    
    func strippedShape(of path: UIBezierPath, with color : UIColor) {
        path.addClip()
        
        for index in 1...1000 {
            path.move(to: CGPoint(x: 10*index, y: 0))
            path.addLine(to: CGPoint(x: 10*index, y: 1000))
        }
        path.lineWidth = 2.0
        color.setStroke()
        path.stroke()
    }
}


class CardView: UIView {
    override func draw(_ rect: CGRect) {
        let draw = CardView2()
        let cardPadding = 10
        let cardWidth = 50
        let cardRatio : Double = (3/2)
        let startingPoint = CGPoint(x: 10, y: 10)
        let cardsInARow = Int(self.bounds.width) / (cardWidth + cardPadding)
        let cardHeight = Double(cardWidth)*cardRatio + Double(cardPadding)
        let numberOfLines = Int(Double(self.bounds.height) / cardHeight)
        
        for index in 0..<numberOfLines {
            for index2 in 0..<cardsInARow {
                let positionX = Int(startingPoint.x) + (cardWidth + cardPadding)*index2
                let positionY = Int(startingPoint.y) + Int(cardHeight)*index
                draw.createCard(Card(3, ofSymbol: .square, withColor: .black, andShading: .stripped), withWidth: cardWidth, andRatio: cardRatio, startingAt: CGPoint(x: positionX, y: positionY))
            }
        }
    }
}

class CardView2: UIView {
    
    private let ovalAspectRatio = 0.4
    private let diamondAspectRatio = 0.6
    private let squiggleAspectRatio = 0.5
    
    func createCard(_ card : Card, withWidth width : Int, andRatio ratio : Double, startingAt: CGPoint) {
        var color : UIColor
        let height = Int(Double(width) * ratio)
        
        drawCard(startingAt: startingAt, width: width, height: height)
        
        
        switch card.color {
        case .black:
            color = UIColor.black
        case .blue:
            color = UIColor.blue
        case .orange:
            color = UIColor.orange
        }
        
        for index in 0..<card.numberOfSymbols {
            UIGraphicsGetCurrentContext()?.saveGState()
            let shape : UIBezierPath
            let xPadding = Int(startingAt.x)
            let startingX = (width/8) + xPadding
            let shapeWitdh = 3*width/4
            let shapeHeight : Double
            var startingY = Int(startingAt.y)
            // shape is 75
            // height/8 = 37,5
            switch card.symbol {
            case .square:
                shapeHeight = Double(shapeWitdh) * squiggleAspectRatio
                startingY += height/8 + index*Int(shapeHeight)
                shape = createSquiggles(startingAt: CGPoint(x: startingX, y: startingY), withWidth: shapeWitdh, using: color)
            case .triangle:
                shapeHeight = Double(shapeWitdh) * diamondAspectRatio
                startingY += height/8 + index*Int(shapeHeight)
                shape = createDiamonds(startingAt: CGPoint(x: startingX, y: startingY), withWidth: shapeWitdh, using: color)
            case .circle:
                shapeHeight = Double(shapeWitdh) * ovalAspectRatio
                startingY += height/8 + index*Int(shapeHeight)
                shape = createOval(startingAt: CGPoint(x: startingX, y: startingY), withWidth: shapeWitdh, using: color)
            }
            shape.createFilling(using: card.shading, with: color)
            UIGraphicsGetCurrentContext()?.restoreGState()
        }
        
    }
    func drawCard(startingAt : CGPoint, width: Int, height : Int){
        let card = UIBezierPath()
        card.move(to: startingAt)
        card.addLine(to: CGPoint(x: startingAt.x + CGFloat(width), y: startingAt.y))
        card.addLine(to: CGPoint(x: startingAt.x + CGFloat(width), y: startingAt.y + CGFloat(height)))
        card.addLine(to: CGPoint(x: startingAt.x, y: startingAt.y + CGFloat(height)))
        card.addLine(to: CGPoint(x: startingAt.x, y: startingAt.y))
        UIColor.magenta.setStroke()
        card.stroke()
    }
    
    func createSquiggles(startingAt point : CGPoint, withWidth width : Int, using color : UIColor) -> UIBezierPath {
        let height = Int(Double(width) * squiggleAspectRatio)
        let squiggles = UIBezierPath()
        squiggles.move(to: CGPoint(x: Int(point.x)+width/8, y: Int(point.y)+height/3))
        squiggles.addCurve(to: CGPoint(x: Int(point.x)+5*width/6, y: Int(point.y)+height/5), controlPoint1: CGPoint(x: Int(point.x)+width/4, y: Int(point.y)+0), controlPoint2: CGPoint(x: Int(point.x)+3*width/5, y: Int(point.y)+3*height/5))
        squiggles.addCurve(to: CGPoint(x: Int(point.x)+5*width/6, y: Int(point.y)+4*height/5), controlPoint1: CGPoint(x: Int(point.x)+width, y: Int(point.y)+height/5), controlPoint2: CGPoint(x: Int(point.x)+width, y: Int(point.y)+3*height/5))
        squiggles.addCurve(to: CGPoint(x: Int(point.x)+width/8, y: Int(point.y)+4*height/5), controlPoint1: CGPoint(x: Int(point.x)+width/2, y: Int(point.y)+height), controlPoint2: CGPoint(x: Int(point.x)+3*width/5, y: Int(point.y)+3*height/5))
        squiggles.addCurve(to: CGPoint(x: Int(point.x)+width/8, y: Int(point.y)+height/3), controlPoint1: CGPoint(x: Int(point.x)+0, y: Int(point.y)+4*height/5), controlPoint2: CGPoint(x: Int(point.x)+0, y: Int(point.y)+2*height/3))
        squiggles.lineWidth = 5.0
        color.setStroke()
        squiggles.stroke()
        
        
        
        return squiggles
    }
    
    private func createDiamonds(startingAt point : CGPoint, withWidth width : Int, using color : UIColor) -> UIBezierPath {
        let height = Int(Double(width) * diamondAspectRatio)
        let x = Int(point.x)
        let y = Int(point.y)
        
        let diamonds = UIBezierPath()
        diamonds.move(to: CGPoint(x: x, y: y+(2*height/3)))
        diamonds.addLine(to: CGPoint(x: x+(width/2), y: y+(height/3)))
        diamonds.addLine(to: CGPoint(x: x+(width), y: y+(2*height/3)))
        diamonds.addLine(to: CGPoint(x: x+(width/2), y: y+(height)))
        diamonds.addLine(to: CGPoint(x: x, y: y+(2*height/3)))
        diamonds.lineWidth = 5.0
        color.setStroke()
        diamonds.stroke()
        
        return diamonds
    }
    
    func createOval(startingAt point : CGPoint, withWidth width : Int, using color : UIColor) -> UIBezierPath {
        let height = Int(Double(width) * ovalAspectRatio)
        let x = Int(point.x)
        let y = Int(point.y)
        
        let oval = UIBezierPath()
        oval.move(to: CGPoint(x: x+(width/4), y: y))
        oval.addLine(to: CGPoint(x: x+(3*width/4), y: y))
        oval.addCurve(to: CGPoint(x: x+(3*width/4), y: y+(height)), controlPoint1: CGPoint(x: x+(width), y: y+(height/5)), controlPoint2: CGPoint(x: x+(width), y: y+(4*height/5)))
        oval.addLine(to: CGPoint(x: x+(width/4), y: y+(height)))
        oval.addCurve(to: CGPoint(x: x+(width/4), y: y), controlPoint1: CGPoint(x: x, y: y+(4*height/5)), controlPoint2: CGPoint(x: x, y: y+(height/5)))
        
        oval.lineWidth = 5.0
        color.setStroke()
        oval.stroke()
        
        return oval
    }
    
}
