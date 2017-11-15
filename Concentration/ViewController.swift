//
//  ViewController.swift
//  Concentration
//
//  Created by Michael De La Cruz on 11/12/17.
//  Copyright © 2017 Michael De La Cruz. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count+1) / 2
    }
    
    var flipCount = 0 {
        didSet {  // property observer
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }

    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.6891634198, blue: 0.1001188663, alpha: 1)
            }
        }
    }
    
    private var emojiChoices = ["🎃","👻","😈","💀", "🤖", "👨‍🚀", "🐈", "🐕"]
    
    private var emoji = [Int:String]()

    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil {
            if emojiChoices.count > 0 {
                emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
            }
        }
        return emoji[card.identifier] ?? "?"
    }
}


extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self > 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
