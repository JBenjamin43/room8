//
//  profile.swift
//  Room8s
//
//  Created by Jeremiah on 2/1/23.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

class MatchesCollectionViewCell : UICollectionViewCell {
    static let reuseIdentifier = "MatchesCollectionViewCell"
    
    
    @IBOutlet weak var ProfileImage: UIImageView!
    
    @IBOutlet weak var firstName: UILabel!
    
    @IBOutlet weak var profileAge: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    public var roomie: Roomie? = nil
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fetchImage()
    }
    
    private func fetchImage() {
        guard let uid = Auth.auth().currentUser?.uid, let roomie = roomie else {
            return
        }
        let storageRef = Storage.storage().reference().child("user/\(roomie.id)")
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
                            self.ProfileImage.image = image
                        }
                    }
                }.resume()
            } else {
                print("Something went wrong: \(error.debugDescription)")
            }
        }

    }
}
