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
    
    let signuplabel = UILabel()
    var firstNameTextField: UITextField!
    var lastNameTextField: UITextField!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var confirmPasswordTextField: UITextField!
    var signUpButton: UIButton!
    let errorLable = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

          setUpElements()
          setUpView()
        
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
    
    private func setUpView() {
        
        firstNameTextField = UITextField(frame: CGRect(x: 20, y: 380, width: 350, height: 30))
        firstNameTextField.borderStyle = .roundedRect
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.attributedPlaceholder = NSAttributedString(
                   string: "First Name",
                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
               )
        firstNameTextField.backgroundColor = .white
        firstNameTextField.textAlignment = .left
        // set the delegate if you need to respond to text field events
        firstNameTextField.delegate = self
        view.addSubview(firstNameTextField)
        
        lastNameTextField = UITextField(frame: CGRect(x: 20, y: 420, width: 350, height: 30))
        lastNameTextField.borderStyle = .roundedRect
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.backgroundColor = .white
        lastNameTextField.textAlignment = .center
        // set the delegate if you need to respond to text field events
        lastNameTextField.delegate = self
        view.addSubview(lastNameTextField)
        
        emailTextField = UITextField(frame: CGRect(x: 20, y: 460, width: 350, height: 30))
        emailTextField.borderStyle = .roundedRect
        emailTextField.placeholder = "Email"
        emailTextField.backgroundColor = .white
        emailTextField.textAlignment = .center
        // set the delegate if you need to respond to text field events
        emailTextField.delegate = self
        view.addSubview(emailTextField)
        
        passwordTextField = UITextField(frame: CGRect(x: 20, y: 500, width: 350, height: 30))
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "Password"
        passwordTextField.backgroundColor = .white
        passwordTextField.textAlignment = .center
        passwordTextField.isSecureTextEntry = true
        passwordTextField.keyboardType = .default
        passwordTextField.autocorrectionType = .no
        // set the delegate if you need to respond to text field events
        passwordTextField.delegate = self
        view.addSubview(passwordTextField)
        
        confirmPasswordTextField = UITextField(frame: CGRect(x: 20, y: 540, width: 350, height: 30))
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.placeholder = "Confirm Password"
        confirmPasswordTextField.textColor = .placeholderText 
        confirmPasswordTextField.backgroundColor = .white
        confirmPasswordTextField.textAlignment = .center
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.keyboardType = .default
        confirmPasswordTextField.autocorrectionType = .no
        // set the delegate if you need to respond to text field events
        confirmPasswordTextField.delegate = self
        view.addSubview(confirmPasswordTextField)

        errorLable.text = "error"
        errorLable.font = UIFont.systemFont(ofSize: 20)
        errorLable.frame = CGRect(x: 10, y: 120 , width: 370, height: 40)
        self.view.addSubview(errorLable)
        errorLable.textColor = UIColor.red
        errorLable.textAlignment = .center
        errorLable.backgroundColor = UIColor.clear
        
        signUpButton = UIButton(type:  .system)
        signUpButton.frame = CGRect(x: 10, y: 590, width: 370, height: 40)
        signUpButton.setTitle("Sign up", for: .normal)
        signUpButton.backgroundColor = UIColor.black
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.layer.cornerRadius = 8.0
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        self.view.addSubview(signUpButton)
        
        signuplabel.text = "Sign Up"
        signuplabel.font = UIFont.boldSystemFont(ofSize: 30)
        signuplabel.frame = CGRect(x: 10, y: 340 , width: 120, height: 40)
        self.view.addSubview(signuplabel)
        signuplabel.textColor = UIColor.black
        signuplabel.textAlignment = .center
        signuplabel.backgroundColor = UIColor.clear
        
        let appImageView = UIImageView(frame: CGRect(x: 90, y: 160, width: 240, height: 150))
        appImageView.image = UIImage(named: "Screen Shot 2023-01-16 at 8.16.49 PM")
        view.addSubview(appImageView)

        
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
    
    func transitionToHome() {}
}


