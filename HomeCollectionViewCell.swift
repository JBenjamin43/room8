//
//  HomeCollectionViewCell.swift
//  Room8s
//
//  Created by Jeremiah on 1/30/23.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage

class HomeCollectionViewCell : UICollectionViewCell {
    
    static let reuseIdentifier = "HomeCollectionViewCell"
    
    @IBOutlet weak var roomiesFirstNameLabel: UILabel!
    @IBOutlet weak var roomieAgeLabel: UILabel!
    @IBOutlet weak var roomieProfileImage: UIImageView!
    
    @IBAction func skipButton(_ sender: Any) {
        guard let currentUserID = currentUserID, let senderUserID = senderUserID else {
            return
        }
        delegate?.handleSkipButtonPress(currentUserID: currentUserID,
                                        senderUserID: senderUserID)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fetchImage()
    }
    
    private func fetchImage() {
        guard let uid = Auth.auth().currentUser?.uid, let senderUserID = senderUserID else {
            return
        }
        let storageRef = Storage.storage().reference().child("user/\(senderUserID)")
        storageRef.downloadURL { url, error in
            if let url = url, error == nil {
                print("Successfully worked.")
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print("Error downloading image: \(error)")
                        return
                    }
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.roomieProfileImage.image = image
                        }
                    }
                }.resume()
            } else {
                print("Something went wrong: \(error.debugDescription)")
            }
        }
        
    }
}
