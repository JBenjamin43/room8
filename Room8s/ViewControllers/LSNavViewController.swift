//
//  LSNavPage.swift
//  Room8s
//
//  Created by Jeremiah on 1/16/23.
//

import Foundation
import UIKit


class LSNavViewController : UIViewController {
    
    let welcomeToLabel = UILabel()
    var homeSignInButton: UIButton!
    var homeLoginButton: UIButton!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setupView()
        
        let backgroundImage = UIImage(named: "background")
            let backgroundImageView = UIImageView(image: backgroundImage)
            backgroundImageView.frame = view.bounds
            backgroundImageView.contentMode = .scaleAspectFill
            view.addSubview(backgroundImageView)
            view.sendSubviewToBack(backgroundImageView)
        

        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        homeSignInButton = UIButton(type:  .system)
        homeSignInButton.frame = CGRect(x: 10, y: 450, width: 370, height: 40)
        homeSignInButton.setTitle("Sign up", for: .normal)
        homeSignInButton.backgroundColor = UIColor.black
        homeSignInButton.setTitleColor(UIColor.white, for: .normal)
        homeSignInButton.layer.cornerRadius = 8.0
        homeSignInButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        homeSignInButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.view.addSubview(homeSignInButton)
        
        homeLoginButton = UIButton(type:  .system)
        homeLoginButton.frame = CGRect(x: 10, y: 500, width: 370, height: 40)
        homeLoginButton.setTitle("Login", for: .normal)
        homeLoginButton.backgroundColor = UIColor.black
        homeLoginButton.setTitleColor(UIColor.white, for: .normal)
        homeLoginButton.layer.cornerRadius = 8.0
        homeLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        homeLoginButton.addTarget(self, action: #selector(buttonTapped2), for: .touchUpInside)
        self.view.addSubview(homeLoginButton)
        
        welcomeToLabel.text = "Welcome to"
        welcomeToLabel.font = UIFont.systemFont(ofSize: 30)
        welcomeToLabel.frame = CGRect(x: 10, y: 160 , width: 370, height: 40)
        self.view.addSubview(welcomeToLabel)
        welcomeToLabel.textColor = UIColor.black
        welcomeToLabel.textAlignment = .center
        welcomeToLabel.backgroundColor = UIColor.clear
        
        let appImageView = UIImageView(frame: CGRect(x: 90, y: 200, width: 220, height: 170))
        appImageView.image = UIImage(named: "Screen Shot 2023-01-16 at 8.16.49 PM")
        view.addSubview(appImageView)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let signUpViewController = SignUpPageViewController()
        
        self.navigationController?.pushViewController(signUpViewController, animated: true)

    }
    
    @objc func buttonTapped2(_ sender: UIButton) {
        let loginPageViewController = LoginPageViewController()
        
        self.navigationController?.pushViewController(loginPageViewController, animated: true)

    }
    
    
}
