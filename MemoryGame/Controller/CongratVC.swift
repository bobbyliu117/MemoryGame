// Chang Liu

import UIKit

class CongratVC: UIViewController, UITextFieldDelegate {
    
    // stored property
    // to get display information from game result
    var displayInfo: String!
    var userInput: String!
    
    // UIs
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var txfNameInput: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // display result
        lblResult.text = displayInfo
        
    }
    
    // check if the user input is empty
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "unwindToGame" {
            // assign a default name if it is empty
            userInput = txfNameInput.text!.isEmpty ? "Someone" : txfNameInput.text!
        }
        return true
    }
    
    // Dismiss keyboard when touch view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // dismiss keyboard when return textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // dismiss
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
