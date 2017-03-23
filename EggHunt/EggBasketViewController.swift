//
//  EggBasketViewController.swift
//  EggHunt
//
//  Created by Chris Smith on 22/03/2017.
//  Copyright © 2017 CDSApps. All rights reserved.
//

import UIKit

class EggBasketViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var caughtEggs : [Egg] = []
    var uncaughtEggs : [Egg] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        caughtEggs = getAllCaughtEggs()
        uncaughtEggs = getAllUncaughtEggs()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Caught"
        } else {
            return "Uncaught"
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return caughtEggs.count
        } else {
            return uncaughtEggs.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eggs: Egg
        
        if indexPath.section == 0 {
            eggs = caughtEggs[indexPath.row]
        } else {
            eggs = uncaughtEggs[indexPath.row]
        }
        
        let cell = UITableViewCell()
        cell.textLabel?.text = eggs.name
        cell.imageView?.image = UIImage(named: eggs.imageName!)
        return cell
    }
    
    
    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
