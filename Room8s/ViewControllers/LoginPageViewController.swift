//
//  LoginPageViewController.swift
//  Room8s
//
//  Created by Jeremiah on 1/16/23.
//
import Foundation
import UIKit
import FirebaseAuth

class LoginPageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabelLogin: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let backgroundImage = UIImage(named: "background")
            let backgroundImageView = UIImageView(image: backgroundImage)
            backgroundImageView.frame = view.bounds
            backgroundImageView.contentMode = .scaleAspectFill
            view.addSubview(backgroundImageView)
            view.sendSubviewToBack(backgroundImageView)
        
    }
    
    
    func setUpElements() {
        //hides the error label
        errorLabelLogin.alpha = 0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print(textField.text)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        // TODO VALIDATE TEXT FIELDS
        
        // Create cleaned versions of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabelLogin.text = error!.localizedDescription
                self.errorLabelLogin.alpha = 1
            }
            else {
                
                
                let mainTabViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainTabViewController) as? UITabBarController
                
                self.view.window?.rootViewController = mainTabViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    
}
        
 
