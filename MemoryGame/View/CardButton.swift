// Chang Liu

import UIKit

// delegate
protocol CardButtonDelegate {
    // to setup a name game
    func shuffle()
    // to use a screen button to prevent user interaction
    func screen()
    // dismiss
    func dismiss()
    // to keep track of moves
    func countMoves()
}

// card
class CardButton: UIButton {
    
    // keep track of the first flipped card
    static var firstFlippedCard: CardButton?
    // keep track of the number of the matched pairs
    static var numberOfMatches = 0
    
    // stored properties
    var isFlipped = false
    var imageString: String!
    var delegate: CardButtonDelegate!
    
    // computed properties
    var image: UIImage {
        return UIImage(named: imageString)!
    }
    
    // initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    
    // game logic when card is tapped
    // flipped or not, is first flipped or not
    @objc func tap() {
        // to keep track of this move
        delegate.countMoves()
        
        if isFlipped {
            isFlipped = false
            // flip back
            flipTo()
            // reset
            CardButton.firstFlippedCard = nil
            
            return
        } else {
            isFlipped = true
            // flip up
            flipTo(imageName: imageString) // 0.3s
            
            // check if this is the first flip
            if let firstFlipped = CardButton.firstFlippedCard {
                // screen the interaction for 1 second
                delegate.screen()
                // check if the two is a match
                let matches = (self.imageString == firstFlipped.imageString)
                if matches {
                    // remove the two cards
                    perform(#selector(pulse), with: self, afterDelay: 0.3)
                    let timer = Timer(timeInterval: 0.1, target: firstFlipped, selector: #selector(self.pulseWithTimer(timer:)), userInfo: firstFlipped, repeats: false)
                    timer.fire()
                    
                    // count match number
                    CardButton.numberOfMatches += 1
                    CardButton.firstFlippedCard = nil
                    // check if win
                    if CardButton.numberOfMatches == totalPairs {
                        delegate.screen()
                        perform(#selector(gameEnd), with: self, afterDelay: 1)
                        
                    }
                } else {
                    // flip back with a delay for animation
                    _ = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(self.flipWithDelay), userInfo: nil, repeats: false)
                    _ = Timer.scheduledTimer(timeInterval: 0.7, target: firstFlipped, selector: #selector(self.flipWithTimer(timer:)), userInfo: firstFlipped, repeats: false)
                    
                    // reset
                    CardButton.firstFlippedCard = nil
                    self.isFlipped = false
                    firstFlipped.isFlipped = false
                    
                }
            } else {
                // set this card to be the first flipped
                CardButton.firstFlippedCard = self
                flipTo(imageName: imageString)
            }
        }
    }
    
    // flip back with delay
    @objc func flipWithDelay() {
        let image = UIImage(named: "card_back")
        setImage(image, for: .normal)
        CardButton.firstFlippedCard?.setImage(image, for: .normal)
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    @objc func flipWithTimer(timer: Timer) {
        let image = UIImage(named: "card_back")
        if let card = timer.userInfo as? CardButton {
            card.setImage(image, for: .normal)
            UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
    }
    
    // Show Play Button and prompt
    @objc func gameEnd() {
        
        // present alert
        delegate.dismiss()
        
    }
    
    // animations
    // flip card
    func flipTo(imageName: String = "card_back") {
        let image = UIImage(named: imageName)
        setImage(image, for: .normal)
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    // remove card with pulsing animation
    @objc func pulse() {
        // core animation to scale
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.7
        animation.repeatCount = 1
        animation.autoreverses = false
        animation.fromValue = 1.2
        animation.toValue = 0.1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        UIView.animateKeyframes(withDuration: 0.7, delay: 0, options: [], animations: {
            // frame 1: scale
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.9, animations: {
                self.layer.add(animation, forKey: nil)
            })
            
            // frame 2: remove
            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1, animations: {
                self.alpha = 0
            })
        }, completion: nil)
        
    }
    
    // pulse with a delay
    @objc func pulseWithTimer(timer: Timer) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.7
        animation.repeatCount = 1
        animation.autoreverses = false
        animation.fromValue = 1.2
        animation.toValue = 0.1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        if let card = timer.userInfo as? CardButton {
            UIView.animateKeyframes(withDuration: 0.7, delay: 0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.9, animations: {
                    card.layer.add(animation, forKey: nil)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1, animations: {
                    card.alpha = 0
                })
            }, completion: nil)
        }
    }
}
