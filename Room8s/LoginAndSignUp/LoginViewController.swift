//
//  OpeningScreenViews.swift
//  Room8s
//
//  Created by Jeremiah Benjamin on 7/11/25.
//

import UIKit
import AuthenticationServices // For Apple Sign-In
//import GoogleSignIn           // If using Google Sign-In SDK

class LoginViewController: UIViewController {

    // MARK: - UI Elements

    let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "your_logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Room8s"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let appleButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let googleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign in with Google", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false

        let googleIcon = UIImageView(image: UIImage(named: "google_logo"))
        googleIcon.contentMode = .scaleAspectFit
        googleIcon.frame = CGRect(x: 16, y: 13, width: 24, height: 24)
        button.addSubview(googleIcon)
        return button
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupUI()
    }

    // MARK: - Gradient Background

    private func setupGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemIndigo.cgColor, UIColor.systemTeal.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }

    // MARK: - Layout

    private func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(welcomeLabel)
        view.addSubview(appleButton)
        view.addSubview(googleButton)

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 120),

            welcomeLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            appleButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            appleButton.heightAnchor.constraint(equalToConstant: 50),

            googleButton.topAnchor.constraint(equalTo: appleButton.bottomAnchor, constant: 20),
            googleButton.leadingAnchor.constraint(equalTo: appleButton.leadingAnchor),
            googleButton.trailingAnchor.constraint(equalTo: appleButton.trailingAnchor),
            googleButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
