/*
 Chang Liu
 MVF2 - CE04
 10/10/2017
 */

import UIKit

// global variable to store number of card pairs according to the running device, default to suit a phone size
var totalPairs = 10

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        // if device is iPad
        if w * h > 600000 {
            totalPairs = 15
        }
        
    }
}
