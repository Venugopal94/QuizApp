//
//  TopScoresVC.swift
//  FalabellaQuiz
//
//  Created by venu Gopal on 11/05/20.
//  Copyright © 2020 venu Gopal. All rights reserved.
//

import UIKit

class TopScoresVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let viewModel = TopScoresVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getScores()
    }
    
    func getScores() {
        viewModel.getAllSavesScores {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    @IBAction func didTapOnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension TopScoresVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.allScores.count > 5 {
            return 5
        }
        return viewModel.allScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = "Top score \(indexPath.row + 1): \(viewModel.allScores[indexPath.row].score)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}
