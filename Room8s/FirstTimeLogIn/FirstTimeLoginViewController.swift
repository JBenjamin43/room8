//
//  FirstTimeLoginViewController.swift
//  Room8s
//
//  Created by Jeremiah Benjamin on 9/16/25.
//

import Foundation
import UIKit

class FirstTimeLoginViewController: UIViewController {
    
    private let options = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5",
                           "Option 6", "Option 7", "Option 8", "Option 9", "Option 10"]
    
    private let dropdownTableView: UITableView = {
        let table = UITableView()
        table.isHidden = true // Start hidden
        table.layer.cornerRadius = 8
        table.layer.borderWidth = 1
        table.layer.borderColor = UIColor.lightGray.cgColor
        return table
    }()
    
    private let dropdownButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select an Option ⌄", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
    
}
