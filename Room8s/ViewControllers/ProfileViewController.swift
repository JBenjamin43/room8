//
//  CollectionViewController.swift
//  Room8s
//
//  Created by Jeremiah on 1/25/23.
//

import UIKit
import Firebase
import FirebaseStorage

private let reuseIdentifier = "Cell"

protocol ProfileViewControllerDataSource: AnyObject {
    func fetchCurrentUserData()
}

class ProfileViewController: UIViewController, ProfileViewControllerDataSource {
    
    private let profileImageUrlConstant = "gs://room8-dee6c.appspot.com/user/"
    
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
        self.performSegue(withIdentifier: "editProfileSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentUserData()
    }
    
    func fetchCurrentUserData() {
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
                        self.fetchImage()
                    }
                }
            }
        }
    }
    
    private func fetchImage() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfileSegue" {
            let editVC = segue.destination as! EditProfileViewController
            editVC.delegate = self
        }
    }
}

    
