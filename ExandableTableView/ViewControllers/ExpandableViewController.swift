//
//  ExpandableViewController.swift
//  ExandableTableView
//
//  Created by Eli Pacheco Hoyos on 11/25/16.
//  Copyright © 2016 Eli Pacheco Hoyos. All rights reserved.
//

import UIKit

class ExpandableViewController: UIViewController {

    @IBOutlet weak var devicesTableView: UITableView!
    let expandableViewModel = ExpandableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        expandableViewModel.exapandableListener = {
            [weak self] action in
            
            switch action {
            case .Close(let indexPaths):
                self?.devicesTableView.deleteRows(at: indexPaths, with: .bottom)
                break
            case .Open(let indexPaths):
                self?.devicesTableView.insertRows(at: indexPaths, with: .top)
                break
            case .LeafSelected(let indexPath):
                if let deviceToGo = self?.expandableViewModel.devices?[indexPath.row] {
                    print("Go to \(deviceToGo.value)")
                }
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ExpandableViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expandableViewModel.devices?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.text = expandableViewModel.value(indexPath)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        expandableViewModel.deviceSelected(indexPath)
    }
    
}
