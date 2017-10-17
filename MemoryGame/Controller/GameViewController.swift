// Chang Liu

import UIKit
import CoreData

class GameViewController: UIViewController {
    
    // MARK: Core Data Setup
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    // get managed context to read/write data
    private var managedContext: NSManagedObjectContext!
    
    // create variables to hold data needed to create Record
    var winDate: Date!
    var winMoves: Int16!
    var winTimes: Int16!
    var winnerName: String!
    
    // UIs
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
    // keep track moves
    var moves = 0
    
    // methods to update time and time label display
    @objc func countUpTime() {
        time += 1
        lblTimer.text = formatTime(time: Int16(time)) //"\(time) seconds"
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
        lblTimer.text = "\(time) Seconds Left"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // assign imageStrings according to device used
        imageStrings = totalPairs == 10 ? imageNames10 : imageNames15
        
        // get Core Data Context
        managedContext = appDelegate.managedObjectContext
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
    
    // format time output
    func formatTime(time: Int16) -> String {
        if time < 60 {
            return time.description + "\""
        } else if time < 3600 {
            let min = time / 60
            let sec = time % 60
            return "\(min)'\(sec)\""
        } else {
            return "Man...no way to take more than an hour"
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sVC = segue.destination as? CongratVC {
            sVC.displayInfo = "YOU WIN!\nTook \(moves) moves in \(formatTime(time: Int16(time))).\nPlease enter your name or initial:"
        }
    }
    
    // 3rd required method
    func dismiss() {
        // keep track winning record data
        // TODO: Take local time difference into account
        winDate = Date()
        // Int16_MAX = 32767, should be enough in this case
        winMoves = Int16(moves)
        winTimes = Int16(time)

        performSegue(withIdentifier: "toCongratVC", sender: nil)
        
        // reset
        timer.invalidate()
        btnStart.isHidden = false
        btnScreen.isHidden = false
        time = 0
        lblTimer.text = "Timer"
        moves = 0
        
    }
    
    // if the user click OK to store the record, unwind here
    @IBAction func saveRecord(_ segue: UIStoryboardSegue) {
        if let sVC = segue.source as? CongratVC {
            // get new record
            let newRecord = Record(context: managedContext)
            // assign values to each attribute
            newRecord.date = winDate
            newRecord.moveCount = winMoves
            newRecord.time = winTimes
            newRecord.name = sVC.userInput
            
            // save new record
            do {
                try managedContext.save()
            } catch {
                print("Save New Record Failed 001")
            }
        }
    }
    
    // 4th required method: keep track of nuber of moves
    func countMoves() {
        moves += 1
        print(moves)
    }
    
}






























