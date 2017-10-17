// Chang Liu
// Ranking VC

import UIKit
import CoreData

class RankingVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // data model
    var records = [Record]()
    
    // Setup Core Data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!
    
    // UIs
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // get context
        managedContext = appDelegate.managedObjectContext
        
        // request to get all data in Record entity
        let fetchRequest = Record.fetchRequest() as NSFetchRequest<Record>
        // sort the fetch
        let sortDescriptor = NSSortDescriptor(key: "time", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // fetch
        do {
            records = try managedContext.fetch(fetchRequest)
        } catch {
            print("Fetch Records Failed 001")
        }
        
        // reload table view
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count < 5 ? records.count : 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! RecordCell
        // config
        cell.lblRank.text = "\(indexPath.row + 1)"
        // get record data
        let record = records[indexPath.row]
        // fill the cell
        configRecordCell(cell: cell, record: record)
        
        return cell
    }
    
    // Config Cell
    private func configRecordCell(cell: RecordCell, record: Record) {
        cell.lblName.text = record.name
        cell.lblMoves.text = record.moveCount.description + " moves"
        // format the date
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        cell.lblDate.text = df.string(from: record.date!)
        // formate the time
        cell.lblTime.text = formatTime(time: record.time)
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
    
    // dismiss
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
}
