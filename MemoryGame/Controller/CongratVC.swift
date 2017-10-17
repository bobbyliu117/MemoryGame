// Chang Liu

import UIKit

class CongratVC: UIViewController {
    
    // stored property
    // to get display information from game result
    var displayInfo: String!

    
    // UIs
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var txfNameInput: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // display result
        lblResult.text = displayInfo
    }

    // dismiss
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
