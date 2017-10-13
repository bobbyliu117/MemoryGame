// Chang Liu

import Foundation

class Record {
    // Stored Properties
    
    var name: String!
    var numberOfTurns: Int!
    var timeTakenInSeconds: Int!
    var date: NSDate!
    
    // initializer
    init(name: String, numberOfTurns: Int, timeTakenInSeconds: Int, date: NSDate) {
        self.name = name
        self.numberOfTurns = numberOfTurns
        self.timeTakenInSeconds = timeTakenInSeconds
        self.date = date
    }
}


