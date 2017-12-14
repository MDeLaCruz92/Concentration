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
    
    var themes = 0
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count+1) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet {  // property observer
            flipCountLabel.text = "Flips: \(flipCount)"
            scoreCountLabel.text = "Score: \(game.scoreCount)"
        }
    }

    @IBOutlet private weak var flipCountLabel: UILabel! 
    @IBOutlet private weak var scoreCountLabel: UILabel!
    @IBOutlet private weak var newGameButton: UIButton!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        startNewGame()
    }
    
    private func startNewGame() {
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        resetEmojis()
        themes = emojiChoices.count.arc4random
        updateViewFromModel()
        flipCount = 0
    }
    
    private func resetEmojis() {
        let emojiValues = Array(emoji.values)
        emojiChoices[themes] += emojiValues
        emoji = [Int:String]()
    }
        
    func updateViewFromModel() {
        flipCount += 1
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : cardBackThemes[themes]
                button.isEnabled = card.isMatched ? false : true  // works well with flipCount
                view.backgroundColor = backgroundThemes[themes]
                flipCountLabel.textColor = cardBackThemes[themes]
                scoreCountLabel.textColor = cardBackThemes[themes]
                newGameButton.setTitleColor(cardBackThemes[themes], for: .normal)
            }
        }
    }
    
    private let cardBackThemes = [#colorLiteral(red: 0.3655654788, green: 0.8429816961, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.6891634198, blue: 0.1001188663, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)]
    private let backgroundThemes = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
    
    private var emojiChoices = [["🎅","🤶","☃️","❄️","🎁","🛍","🦌","🌨","☕️","🎄"],
                                ["🎃","👻","😈","💀","🦇","⚰️","🍫","🍬","🍭","👹"],
                                ["😀","😇","🤥","🤪","🤤","🤩","🤨","🧐","🤫","😭"],
                                ["🌎","🌕","🌞","🌑","⭐️","🌙","⚡️","🌈","⛅️","💫"],
                                ["🍏","🍓","🍉","🍌","🌽","🥕","🍍","🍑","🍇","🍋"],
                                ["🏈","🏀","⚽️","⚾️","🎾","🏐","🥊","⛳️","🏒","🏓"],
                                ["🦖","🐬","🐐","🐊","🦀","🐞","🐒","🦊","🐶","🐱"]]
    
    private var emoji = [Int:String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices[themes].count > 0 {
            emoji[card.identifier] = emojiChoices[themes].remove(at: emojiChoices[themes].count.arc4random)
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
