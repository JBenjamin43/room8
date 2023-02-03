//
//  profile.swift
//  Room8s
//
//  Created by Jeremiah on 2/1/23.
//

import Foundation
import UIKit

class MatchesCollectionViewCell : UICollectionViewCell {
    static let reuseIdentifier = "MatchesCollectionViewCell"
    
    @IBOutlet weak var ProfileImage: UIView!
    
    @IBOutlet weak var firstName: UIView!
    
    @IBOutlet weak var profileAge: UIView!
    
    @IBOutlet weak var email: UILabel!
}
