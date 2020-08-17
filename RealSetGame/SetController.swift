//
//  SetController.swift
//  SetGame
//
//  Created by Douglas castilho on 22/07/20.
//  Copyright © 2020 Vanessa Furtado. All rights reserved.
//

import Foundation


extension URLSession {
    func getCardsResult(with url: URLRequest, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
    return dataTask(with: url) { (data, response, error) in
        if let error = error {
            result(.failure(error))
            return
        }
        guard let response = response, let data = data else {
            let error = NSError(domain: "error", code: 0, userInfo: nil)
            result(.failure(error))
            return
        }
        result(.success((response, data)))
    }
}
}


extension Array where Iterator.Element == Card {
    func getCardValue(toProperty property : String) -> [Int]{
        
        switch property {
        case "shade":
            return self.map( { (card) -> Int in
                return card.shading.rawValue
            } )
        case "color":
            return self.map( { (card) -> Int in
                return card.color.rawValue
            } )
        case "symbol":
            return self.map( { (card) -> Int in
                return card.symbol.rawValue
            } )
        case "count":
            return self.map( { (card) -> Int in
                return card.numberOfSymbols
            } )
        default:
            print("do nothing")
        }
        
        return []
    }
}


class SetController {
    
    
    var deck : [Card] = []
    var symbols : [String] = []
    var selectedCards : [Card] = []
    var tableCards : [Card] = []
    var lastSetWasMatch : Bool = false
    var score = 0
    var hasMatch : Bool = false
    
    
    func initGame() {
        deck = []
        selectedCards = []
        tableCards = []
        score = 0
        createDeck()
        createTable()
    }
    
    
    private func getSymbols() -> [String] {
        return ["▴","●","■"]
    }
    
    func canSelectButton(index : Int) -> Bool {
        return !selectedCards.contains(tableCards[index])
    }
    
    func deselectButton(index : Int) {
        selectedCards.remove(at: selectedCards.firstIndex(of: tableCards[index])!)
    }
    
    func showSelectedButtons(){
        print("   ----    ")
        for card in selectedCards {
            print(tableCards.firstIndex(of: card)!)
        }
        print("   ----   ")
    }
    
    
    private func createDeck() {
        symbols = getSymbols()
        
        for symbolCount in 1...3 {
            for colorIndex in ColorEnum.allCases {
                for shadingIndex in ShadingEnum.allCases {
                    for symbol in SymbolEnum.allCases {
                        deck.append(Card(symbolCount, ofSymbol: symbol, withColor: colorIndex, andShading: shadingIndex))
                    }
                }
            }
        }
        deck.shuffle()
    }
    
    
    private func createTable() {
        for index in 1...12 {
            tableCards.append(deck.remove(at: index))
        }
    }
    
    func addThreeMore() -> Bool {
        if(tableCards.count < 24) {
            //createJSONObject()
            if hasMatch {
                print("Sub 10 points")
                score -= 10
                hasMatch = false
            }else {
                print("didn't wait for function")
            }
            addNewCardsOnTable(nil)
            return true
        }
        return false
    }
    
//    func createJSONObject() -> (){
//        let para:NSMutableDictionary = NSMutableDictionary()
//        let cardsDictionary = tableCards.map({ ["symbol": $0.symbol.rawValue, "color" : $0.color.rawValue, "shading": $0.shading.rawValue, "number_of_symbols" : $0.numberOfSymbols] })
//        para.setValue(cardsDictionary, forKey: "cards")
//        let JSON = try? JSONSerialization.data(withJSONObject: para, options: [])
//        if let result = JSON {
//            let headers: HTTPHeaders = [
//                "Content-Type": "application/json"
//            ]
//            let url = URL(string: "https://vanessa-game.herokuapp.com/game/check")!
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.headers = headers
//            request.httpBody = result
//
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let data = data, error == nil else {
//                    print(error?.localizedDescription ?? "No data")
//                    return
//                }
//                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//                if let responseJSON = responseJSON as? [String: Any] {
//                    if let hasSet = responseJSON["game"] {
//                        if hasSet as! Bool == true {
//                            print("Yes, you're dumb")
//                            self.hasMatch = true
//
//                        }else {
//
//                            print("you're right. I'll give you more cards")
//                            self.hasMatch = false
//                        }
//                    }
//                }
//            }
//            return task.resume()
//        }else {
//            print("bad code")
//        }
//        print("end of task code", hasMatch)
//    }
    
    func cardSelected(index : Int) -> Bool{
        
        if(canSelectButton(index: index)){
            print("yes, button \(index) is selected")
            let card = tableCards[index]
            selectedCards.append(card)
            if(selectedCards.count == 3){
                checkSetMatch()
            }
            return true
        } else {
            print("this button \(index) was selected. Not anymore")
            deselectButton(index: index)
            return false
        }
        
    }
    
    private func checkSetMatch() {
        
        let shade = compare(card: selectedCards.getCardValue(toProperty: "shade"))
        let color = compare(card: selectedCards.getCardValue(toProperty: "color"))
        let symbol = compare(card: selectedCards.getCardValue(toProperty: "symbol"))
        let count = compare(card: selectedCards.getCardValue(toProperty: "count"))
        
        if symbol && count && color && shade {
            print("It's a match")
            score += 6
            let indices = removeCardsFromTable()
            if tableCards.count < 12 {
                addNewCardsOnTable(indices)
            }
        } else {
            score -= 3
            print("Not a match")
        }
        selectedCards.removeAll()
    }
    
    private func removeCardsFromTable() -> [Int] {
        var indices : [Int] = []
        
        for card in selectedCards {
            indices.append(tableCards.firstIndex(of: card)!)
        }
        
        for card in selectedCards {
            tableCards.remove(at: tableCards.firstIndex(of: card)!)
        }
        indices.sort()
        
        return indices
    }
    
    
    
    private func compare(card : [Int]) -> Bool {
        print(card)
        return (card[0] == card[1] && card[1] == card[2]) || ((card[0] != card[1])&&(card[0] != card[2])&&(card[1] != card[2]))
    }
    
    private func addNewCardsOnTable(_ indices : [Int]?) {
        if let index = indices {
            for count in index {
                tableCards.insert(deck.removeFirst(), at: count)
            }
        }else {
            for _ in 1...3 {
                tableCards.append(deck.removeFirst())
            }
        }
    }
}
