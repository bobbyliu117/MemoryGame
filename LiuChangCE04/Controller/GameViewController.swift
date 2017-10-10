// Chang Liu

import UIKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}



extension GameViewController: CardButtonDelegate {
    
    func shuffle() {
        
    }
    
    
    func screen() {
        
    }
    
    
    func dismiss() {
        // setup alert
        let alert = UIAlertController(title: "Congrat!", message: "YOU WIN!", preferredStyle: UIAlertControllerStyle.alert)
        let okay = UIAlertAction(title: "Play Again", style: UIAlertActionStyle.default) { (_) in
            // reset game
            self.shuffle()
        }
        let quit = UIAlertAction(title: "Quit", style: UIAlertActionStyle.cancel) { (_) in
            self.dismiss()
        }
        alert.addAction(okay)
        alert.addAction(quit)
        
        present(alert, animated: true, completion: nil)
    }
    
}






























