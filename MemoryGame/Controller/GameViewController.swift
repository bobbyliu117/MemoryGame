// Chang Liu Chang Liu

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var btnScreen: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet var cardButtons: [CardButton]!
    
    // name of all images, 15 is for iPad, 10 is for iPhone
    let imageNames15 = ["card_1","card_2","card_3","card_4","card_5","card_6","card_7","card_8","card_9","card_10","card_11","card_12","card_13","card_14","card_15","card_1","card_2","card_3","card_4","card_5","card_6","card_7","card_8","card_9","card_10","card_11","card_12","card_13","card_14","card_15"]
    let imageNames10 = ["card_1","card_2","card_3","card_4","card_5","card_6","card_7","card_8","card_9","card_10","card_1","card_2","card_3","card_4","card_5","card_6","card_7","card_8","card_9","card_10"]
    // store the image names for shuffle according to device used
    var imageStrings: [String]!
    
    // keep track the time
    var time = 0
    var timer = Timer()
    
    // methods to update time and time label display
    @objc func countUpTime() {
        time += 1
        lblTimer.text = "\(time) seconds"
    }
    // 5 second count down
    @objc func countDownTime() {
        time -= 1
        
        if time < 0 {
            time = 0
            timer.invalidate()
            // start count up
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countUpTime), userInfo: nil, repeats: true)
            
            btnScreen.isHidden = true
            // flip back cards
            for (index, card) in cardButtons.enumerated() {
                // return when index reach 20, if it is iPhone
                if index == 20 {
                    if totalPairs == 10 {
                        break
                    }
                }
                card.flipTo()
            }
            return
        }
        // update time display
        lblTimer.text = "\(time) seconds left"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // assign imageStrings according to device used
        imageStrings = totalPairs == 10 ? imageNames10 : imageNames15
        
    }
    
    // start game
    @IBAction func start(_ sender: UIButton) {
        btnStart.isHidden = true
        shuffle()
        
        // reveal all
        for (index, card) in cardButtons.enumerated() {
            // return when index reach 20, if it is iPhone
            if index == 20 {
                if totalPairs == 10 {
                    break
                }
            }
            card.setImage(card.image, for: .normal)
        }
        
        // count 5 seconds
        time = 5
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownTime), userInfo: nil, repeats: true)
        
    }
    
    // quit game
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

// extension to implement CardButtonDelegate defined in CardButton.swift
extension GameViewController: CardButtonDelegate {
    
    // 1st required method: shuffle card to start
    func shuffle() {
        // get random double from 0 to 1 but not include 1 to use in Fisher-Yates Shuffle
        func getRandFrom0To1() -> Double {
            return Double(arc4random_uniform(100)) / 100.0
        }
        
        // Fisher-Yates Shuffle
        for i in (1..<imageStrings.count).reversed() {
            // get random index to switch with current value
            let randomIndex = Int(Double(i) * getRandFrom0To1())
            // switch values
            let temp = imageStrings[randomIndex]
            imageStrings[randomIndex] = imageStrings[i]
            imageStrings[i] = temp
        }
        
        // reassign images for cards
        for (index, card) in cardButtons.enumerated() {
            // return when index reach 20, if it is iPhone
            if index == 20 {
                if totalPairs == 10 {
                    break
                }
            }
            
            card.imageString = imageStrings[index]
            card.setImage(#imageLiteral(resourceName: "card_back"), for: .normal)
            card.isFlipped = false
            card.delegate = self
            card.alpha = 1.0
        }
        
        CardButton.numberOfMatches = 0
        CardButton.firstFlippedCard = nil
        
    }
    
    // 2nd required method: disabling all buttons, except quit and start
    func screen() {
        btnScreen.isHidden = false
        perform(#selector(unscreen), with: self, afterDelay: 1)
    }
    @objc func unscreen() {
        btnScreen.isHidden = true
    }
    
    // 3rd required method
    func dismiss() {
        
        // setup alert
        let alert = UIAlertController(title: "Congrat!", message: "YOU WIN! Took \(time) seconds.", preferredStyle: UIAlertControllerStyle.alert)
        let okay = UIAlertAction(title: "Play Again", style: UIAlertActionStyle.default) { (_) in
            // reset game
            self.shuffle()
        }
        let quit = UIAlertAction(title: "Quit", style: UIAlertActionStyle.cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okay)
        alert.addAction(quit)
        
        present(alert, animated: true, completion: nil)
        
        // reset
        timer.invalidate()
        btnStart.isHidden = false
        btnScreen.isHidden = false
        time = 0
        lblTimer.text = "Timer"
        
    }
    
}






























