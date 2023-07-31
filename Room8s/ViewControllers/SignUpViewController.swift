//
//  signUpPage.swift
//  Room8s
//
//  Created by Jeremiah on 1/16/23.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class SignUpPageViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        setUpElements()
        
        let backgroundImage = UIImage(named: "background")
            let backgroundImageView = UIImageView(image: backgroundImage)
            backgroundImageView.frame = view.bounds
            backgroundImageView.contentMode = .scaleAspectFill
            view.addSubview(backgroundImageView)
            view.sendSubviewToBack(backgroundImageView)
    }
    
    // hides the error label
    func setUpElements() {
        errorLable.alpha = 0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print(textField.text as Any)
    }
    
    func validateFields() -> String? {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields"
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Please give your password at least 8 characters, contains a special symbol and number"
        }
        
        return nil
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        // validates the fields
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        }else {
            
            // create clean versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // creates user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                //check for errors
                if err != nil {
                    
                    // there was an error creating users
                    self.showError("Error creating user")
                }else {
                    
                    // user was created save first and last name
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(result!.user.uid).setData(["firstName":firstName, "lastName":lastName,"uid":result!.user.uid]) { (error) in
                        
                        if error != nil {
                            // show error message
                            self.showError("user data couldnt be saved")
                        }
                    }
                    // transition to the home screen
                    self.transitionToHome()
                }
                
            }
            
        }
    }
    
    func showError(_ message:String) {
        errorLable.text = message
        errorLable.alpha = 1
    }
    
    func transitionToHome() {
        let mainTabViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainTabViewController) as? UITabBarController
        
        view.window?.rootViewController = mainTabViewController
        view.window?.makeKeyAndVisible()
    }
}


