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
    
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var forgotPasswordButton: UIButton!
    var loginButton: UIButton!
    var errorLabelLogin = UILabel()
    let loginLabel = UILabel()
    
    //    @IBOutlet weak var emailTextField: UITextField!
    //    @IBOutlet weak var passwordTextField: UITextField!
    //    @IBOutlet weak var forgotPasswordButton: UIButton!
    //    @IBOutlet weak var loginButton: UIButton!
    //    @IBOutlet weak var errorLabelLogin: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                setUpElements()
        //
        //        emailTextField.delegate = self
        //        passwordTextField.delegate = self
        
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
        
        emailTextField = UITextField(frame: CGRect(x: 20, y: 380, width: 350, height: 40))
        emailTextField.borderStyle = .roundedRect
        emailTextField.textAlignment = .left
        emailTextField.backgroundColor = .white
        emailTextField.textColor = .blue
        emailTextField.attributedPlaceholder = NSAttributedString(
                   string: "Email",
                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
               )
        // set the delegate if you need to respond to text field events
        emailTextField.delegate = self
        view.addSubview(emailTextField)
        
        passwordTextField = UITextField(frame: CGRect(x: 20, y: 430, width: 350, height: 40))
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.textAlignment = .left
        passwordTextField.backgroundColor = .white
        passwordTextField.attributedPlaceholder = NSAttributedString(
                   string: "password",
                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
               )
        passwordTextField.isSecureTextEntry = true
        passwordTextField.keyboardType = .default
        passwordTextField.autocorrectionType = .no
        // set the delegate if you need to respond to text field events
        passwordTextField.delegate = self
        view.addSubview(passwordTextField)
        
        forgotPasswordButton = UIButton(type:  .system)
        forgotPasswordButton.frame = CGRect(x: 200, y: 470, width: 200  , height: 40)
        forgotPasswordButton.setTitle("Forgot Password", for: .normal)
        forgotPasswordButton.backgroundColor = UIColor.clear
        forgotPasswordButton.setTitleColor(UIColor.systemBlue, for: .normal)
        forgotPasswordButton.layer.cornerRadius = 8.0
        forgotPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        //forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        self.view.addSubview(forgotPasswordButton)
        
        loginButton = UIButton(type:  .system)
        loginButton.frame = CGRect(x: 10, y: 590, width: 370, height: 40)
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = UIColor.black
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.layer.cornerRadius = 8.0
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        self.view.addSubview(loginButton)
        
        errorLabelLogin.text = "error"
        errorLabelLogin.font = UIFont.systemFont(ofSize: 10)
        errorLabelLogin.frame = CGRect(x: 10, y: 120 , width: 370, height: 40)
        self.view.addSubview(errorLabelLogin)
        errorLabelLogin.textColor = UIColor.red
        errorLabelLogin.textAlignment = .center
        errorLabelLogin.backgroundColor = UIColor.clear
        
        loginLabel.text = "Login"
        loginLabel.font = UIFont.boldSystemFont(ofSize: 30)
        loginLabel.frame = CGRect(x: 10, y: 340 , width: 120, height: 40)
        self.view.addSubview(loginLabel)
        loginLabel.textColor = UIColor.black
        loginLabel.textAlignment = .center
        loginLabel.backgroundColor = UIColor.clear
        
        let appImageView = UIImageView(frame: CGRect(x: 80, y: 160, width: 240, height: 150))
        appImageView.image = UIImage(named: "Screen Shot 2023-01-16 at 8.16.49 PM")
        view.addSubview(appImageView)


        
        
            }
        
        func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            print(textField.text!)
        }
        
    @objc func loginButtonTapped(_ sender: Any) {
            
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
                    let homeViewController = HomeViewController()
                    
                    self.navigationController?.pushViewController(homeViewController, animated: true)
                    
//                    let mainTabViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainTabViewController) as? UITabBarController
//                    
//                    self.view.window?.rootViewController = mainTabViewController
//                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    func forgotPasswordTapped (_ sender: Any) {
        print("hey")
    }
        
        
}
    
    
