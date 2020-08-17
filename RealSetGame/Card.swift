//
//  Card.swift
//  SetGame
//
//  Created by Douglas castilho on 22/07/20.
//  Copyright © 2020 Vanessa Furtado. All rights reserved.
//

import Foundation


struct Card : Equatable{
    
    var symbol : SymbolEnum
    var color : ColorEnum
    var shading : ShadingEnum
    var numberOfSymbols : Int
    
    
    init(_ number : Int, ofSymbol symbol : SymbolEnum, withColor color : ColorEnum, andShading shade : ShadingEnum ){
        numberOfSymbols = number
        self.symbol = symbol
        self.color = color
        shading = shade
        
    }
    
    func toString() -> String {
        return ("Symbol \(self.symbol) \(self.numberOfSymbols) times with color \(self.color) and shading \(self.shading)")
    }

}
