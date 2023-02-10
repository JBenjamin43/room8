//
//  ProfileDetailViewController.swift
//  Room8s
//
//  Created by Jeremiah on 2/9/23.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class ProfileDetailViewController: UIViewController {
        
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var firstNameProfileLabel: UILabel!
    @IBOutlet weak var lastNameProfileLabel: UILabel!
    @IBOutlet weak var emailProfileLabel: UILabel!
    @IBOutlet weak var cityProfileLabel: UILabel!
    @IBOutlet weak var stateProfileLabel: UILabel!
    @IBOutlet weak var phoneNumberProfileLabel: UILabel!
    @IBOutlet weak var genderProfileLabel: UILabel!
    @IBOutlet weak var ageProfileLabel: UILabel!
    @IBOutlet weak var bioProfileLabel: UILabel!
    
    var roomie: Roomie? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentUserData()
    }
    
    func fetchCurrentUserData() {
        guard let roomieID = roomie?.id else {
            return
        }
        let db = Firestore.firestore()
        //read the documents at a specific path
        db.collection("users").document(roomieID).getDocument { snapshot, error in
            // check for errors
            if error == nil {
                //no errors
                if let d = snapshot {
                    // update the list property in the main thread
                    DispatchQueue.main.async {
                        self.firstNameProfileLabel.text = d["firstName"] as? String ?? "bo"
                        self.lastNameProfileLabel.text = d["lastName"] as? String ?? ""
                        self.emailProfileLabel.text = d["email"] as? String ?? ""
                        self.cityProfileLabel.text = d["city"] as? String ?? ""
                        self.stateProfileLabel.text = d["state"] as? String ?? ""
                        self.phoneNumberProfileLabel.text = d["phoneNumber"] as? String ?? ""
                        self.genderProfileLabel.text = d["gender"] as? String ?? ""
                        self.ageProfileLabel.text = d["age"] as? String ?? ""
                        self.bioProfileLabel.text = d["bio"] as? String ?? ""
                        self.fetchImage()
                    }
                }
            } else {
                print("there was an error: \(error.debugDescription)")
            }
        }
    }
    
    private func fetchImage() {
        guard let roomieID = roomie?.id else {
            return
        }
        let storageRef = Storage.storage().reference().child("user/\(roomieID)")
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
                            self.imageProfile.image = image
                        }
                    }
                }.resume()
            } else {
                print("Something went wrong: \(error.debugDescription)")
            }
        }

    }
}

