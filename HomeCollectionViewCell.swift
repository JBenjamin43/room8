//
//  HomeCollectionViewCell.swift
//  Room8s
//
//  Created by Jeremiah on 1/30/23.
//

import Foundation
import UIKit

class HomeCollectionViewCell : UICollectionViewCell {
    
    static let reuseIdentifier = "HomeCollectionViewCell"
    
    @IBOutlet weak var roomiesFirstNameLabel: UILabel!
    @IBOutlet weak var roomieAgeLabel: UILabel!
    @IBOutlet weak var roomieProfileImage: UIImageView!
    
    @IBAction func skipButton(_ sender: Any) {
        guard let currentUserID = currentUserID else {
            return
        }
        delegate?.handleSkipButtonPress(currentUserID: currentUserID)
    }
    @IBAction func likeButton(_ sender: Any) {
        guard let currentUserID = currentUserID, let senderUserID = senderUserID else {
            return
        }
        delegate?.handleLikeButtonPress(currentUserID: currentUserID,
                                        senderUserID: senderUserID)
    }
    
    public weak var delegate: HomeViewControllerDataSource?
    public var currentUserID: String?
    public var senderUserID: String?
}
