//
//  Concentration.swift
//  Concentration
//
//  Created by Michael De La Cruz on 11/13/17.
//  Copyright © 2017 Michael De La Cruz. All rights reserved.
//

import Foundation

class Concentration
{    
    var scoreCount = 0
        
    private(set) var cards = [Card]()
        
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    private var identityStorage = [Int]()
    private var matchIndexStorage = [Int]()
    

    private var currentTime = Date().addingTimeInterval(10.0)
    
    func chooseCard(at index: Int) {
        let timeCounter = Date()
        
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    scoreCount += 2
                    
                    if timeCounter < currentTime {
                        scoreCount += 1
                        currentTime = Date().addingTimeInterval(10.0)
                    }
                } else {
                    if timeCounter > currentTime {
                        scoreCount -= 1
                        currentTime = Date().addingTimeInterval(10.0)
                    }
                    var misMatches = [Int]()
                    misMatches += [cards[matchIndex].identifier, cards[index].identifier]
                    for misMatch in misMatches {
                        if identityStorage.contains(misMatch) {
                            scoreCount -= 1
                        }
                    }
                    if !identityStorage.contains(cards[index].identifier) {
                        identityStorage.append(cards[index].identifier)
                    }
                    if !identityStorage.contains(cards[matchIndex].identifier) {
                        identityStorage.append(cards[matchIndex].identifier)
                    }
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
 
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        
        var cardsShuffled = [Card]()
        for _ in cards.indices {
            cardsShuffled.append(cards.remove(at: cards.count.arc4random))
        }
        cards = cardsShuffled
    }

}
