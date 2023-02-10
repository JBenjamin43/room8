//
//  EditProfileViewController.swift
//  Room8s
//
//  Created by Jeremiah on 2/1/23.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage


class EditProfileViewController: UIViewController, UITextFieldDelegate {
    
    public weak var delegate: ProfileViewControllerDataSource?
    
    @IBAction func addImageEditButton(_ sender: Any) {
        let addImageViewController = UIImagePickerController()
        addImageViewController.sourceType = .photoLibrary
        addImageViewController.delegate = self
        addImageViewController.allowsEditing = true
        present(addImageViewController, animated: true)
    }
    @IBOutlet weak var profileEditImage: UIImageView!
    @IBOutlet weak var firstNameEditTextField: UITextField!
    @IBOutlet weak var lastNameEditTextField: UITextField!
    @IBOutlet weak var emailEditTextField: UITextField!
    @IBOutlet weak var passwordEditTextField: UITextField!
    @IBOutlet weak var cityEditTextField: UITextField!
    @IBOutlet weak var stateEditTextField: UITextField!
    @IBOutlet weak var phoneNumberEditTextField: UITextField!
    @IBOutlet weak var genderEditTextField: UITextField!
    @IBOutlet weak var ageEditTextField: UITextField!
    @IBOutlet weak var bioEditTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameEditTextField.delegate = self
        lastNameEditTextField.delegate = self
        emailEditTextField.delegate = self
        passwordEditTextField.delegate = self
        cityEditTextField.delegate = self
        stateEditTextField.delegate = self
        phoneNumberEditTextField.delegate = self
        genderEditTextField.delegate = self
        ageEditTextField.delegate = self
        bioEditTextField.delegate = self
        
        self.profileEditImage.image = UIImage(systemName: "plus.app.fill")
        
        setUpElements()
    }
    
    // hides the error labels
    func setUpElements() {
        errorLabel.alpha = 0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print(textField.text as Any)
    }
    
    func validateFields() -> String? {
        
        if firstNameEditTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameEditTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailEditTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordEditTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            cityEditTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            stateEditTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneNumberEditTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            genderEditTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            ageEditTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            bioEditTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "please fill in all fields"
        }
        return nil
    }
    
    func updateUserInfo(userID: String,
                        firstName: String,
                        lastName: String,
                        email: String,
                        password: String,
                        city: String,
                        state: String,
                        phoneNumber: String,
                        gender: String,
                        age: String,
                        bio: String) {
        
        let db = Firestore.firestore()
        db.collection("users").document(userID).updateData([
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "password": password,
            "city": city,
            "state": state,
            "phoneNumber": phoneNumber,
            "gender": gender,
            "age": age,
            "bio": bio
        ]) { (error) in
            if let error = error {
                print("Error updating: \(error)")
            } else {
                print("Successfully updated")
                self.dismiss(animated: true, completion: nil)
                self.uploadProfileImage()
            }
        }
    }
    
    private func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    private func uploadProfileImage() {
        // we get the current user id
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        //path way to the photo
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        //compresses the data
        guard let compressedData = self.profileEditImage.image?.jpegData(compressionQuality: 0.9) else {
            return
        }
        
        storageRef.putData(compressedData) { metadata, error in
            if error != nil {
                // there was an error
            } else {
                // success
                self.delegate?.fetchCurrentUserData()
                print("We uploaded an image successfully 🏌🏿‍♂️🥂")
            }
        }
    }
    
    @IBAction func doneEditButton(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            showError(error!)
        } else {
            let firstName = firstNameEditTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameEditTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailEditTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordEditTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let city = cityEditTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let state = stateEditTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phoneNumber = phoneNumberEditTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let gender = genderEditTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let age = ageEditTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let bio = bioEditTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let userId = Auth.auth().currentUser?.uid else {
                return
            }
            
            updateUserInfo(userID: userId,
                           firstName: firstName,
                           lastName: lastName,
                           email: email,
                           password: password,
                           city: city,
                           state: state,
                           phoneNumber: phoneNumber,
                           gender: gender,
                           age: age,
                           bio: bio)
        }
    }
}


extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            profileEditImage.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
