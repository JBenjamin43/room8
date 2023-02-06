//
//  CollectionViewController.swift
//  Room8s
//
//  Created by Jeremiah on 1/25/23.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"



class ProfileViewController: UIViewController {
    
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
    @IBAction func signOutButton(_ sender: Any) {
        logout()
    }
    
    @IBAction func editProfilebutton(_ sender: Any) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selfUserData()
    }
    
    private func selfUserData() {
        // gets the current id of the user that is signed in
        guard let userId = Auth.auth().currentUser?.uid else {return}
        print("userId: \(userId)")
        
        let db = Firestore.firestore()
        //read the documents at a specific path
        db.collection("users").document(userId).getDocument { snapshot, error in
            // check for errors
            if error == nil {
                //no errors
                if let d = snapshot {
                    // update the list property in the main thread
                    DispatchQueue.main.async {
                        self.firstNameProfileLabel.text = d["firstName"] as? String ?? ""
                        self.lastNameProfileLabel.text = d["lastName"] as? String ?? ""
                        self.emailProfileLabel.text = d["email"] as? String ?? ""
                        self.cityProfileLabel.text = d["city"] as? String ?? ""
                        self.stateProfileLabel.text = d["state"] as? String ?? ""
                        self.phoneNumberProfileLabel.text = d["phoneNumber"] as? String ?? ""
                        self.genderProfileLabel.text = d["gender"] as? String ?? ""
                        self.ageProfileLabel.text = d["age"] as? String ?? ""
                        self.bioProfileLabel.text = d["bio"] as? String ?? ""
                    }
                }
            }
        }
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
            // Navigate to the login screen
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let LoginNavController = storyboard.instantiateViewController(withIdentifier: "LoginNavController")
            self.present(LoginNavController, animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
