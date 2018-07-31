//
//  AudioTableViewController.swift
//  PretendCall
//
//  Created by Jifei sui on 2018/6/21.
//  Copyright © 2018年 Jifei sui. All rights reserved.
//

import UIKit

class AudioTableViewController: UITableViewController {
    
    weak var callInfoDelegate: CallInfoDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ["Custom 1", "Custom 2", "Custom 3"].contains(segue.identifier) {
            let secondViewController = segue.destination as! AudioViewController
            secondViewController.sourceName = segue.identifier!
        }
    }
    
    @IBOutlet weak var DefaultButton: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            print(cell.reuseIdentifier!)
            callInfoDelegate?.setAudio(with: cell.reuseIdentifier!)
            navigationController?.popViewController(animated: true)
        }
    }
}
