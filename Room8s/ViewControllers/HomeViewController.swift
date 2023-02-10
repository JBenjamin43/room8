//
//  HomeViewController.swift
//  Room8s
//
//  Created by Jeremiah on 1/18/23.
//

import UIKit
import Firebase
import FirebaseAuth

protocol HomeViewControllerDataSource: NSObject  {
    func handleSkipButtonPress(currentUserID: String, senderUserID: String)
    func handleLikeButtonPress(currentUserID: String, senderUserID: String)
}

class HomeViewController: UIViewController,
                          UICollectionViewDelegate,
                          UICollectionViewDataSource,
                          UICollectionViewDelegateFlowLayout,
                          HomeViewControllerDataSource {
    
    var roomies: [Roomie] = []
    var currentUserInteractions: [Interaction] = []
    
    @IBOutlet weak var homeViewCollectionView: UICollectionView!
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeViewCollectionView.delegate = self
        homeViewCollectionView.dataSource = self
        interactionObservable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
    }
    
    // MARK: Private
    
    private func fetchData() {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        //get a reference to the database
        let db = Firestore.firestore()
        
        //read the documents at a specific path
        db.collection("users").getDocuments { snapshot, error in
            // check for errors
            if error == nil {
                //no errors
                if let snapshot = snapshot {
                    // update the list property in the main thread
                    DispatchQueue.main.async {
                        // Get all the documents
                        self.roomies = snapshot.documents.map { d in
                            //create a todo item for each document returned
                            return Roomie(id: d.documentID,
                                          firstName: d["firstName"] as? String ?? "",
                                          lastName: d["lastName"] as? String ?? "",
                                          email: d["email"] as? String ?? "",
                                          City: d["city"] as? String ?? "",
                                          State: d["state"] as? String ?? "",
                                          PhoneNumber: d["phoneNumber"] as? String ?? "",
                                          gender: d["gender"] as? String ?? "",
                                          age: d["age"] as? String ?? "",
                                          bio: d["bio"] as? String ?? "")
                        }
                        // Remove the current user from the roomies list
                        self.roomies.removeAll { roomie in
                            roomie.id == userId
                        }
                        
                        self.reloadView()
                    }
                }
            }
            else {
                // handle error
            }
        }
    }
        
    private func interactionObservable() {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("interactions").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error getting snapshot: \(error)")
                return
            }
            if let snapshot = snapshot {
                // update the list property in the main thread
                DispatchQueue.main.async {
                    // Get all the documents
                    for document in snapshot.documents {
                        let data = document.data()
                        let roomieID = data.keys.first ?? ""
                        let interactionType = data.values.first as? Int ?? -1
                        self.currentUserInteractions.append(Interaction(roomieID: roomieID,
                                                                        interactionType: interactionType))
                    }
                    print("the current user interactions are: \(self.currentUserInteractions)")
                    self.reloadView()
                }
            }
        }
    }
    
    private func reloadView() {
        let interactionKeys = currentUserInteractions.map { interaction in
            interaction.roomieID
        }
        
        self.roomies = self.roomies.filter({ roomie in
            return !interactionKeys.contains(where: { key in
                key == roomie.id
            })
        })
        
        self.homeViewCollectionView.reloadData()
    }
    
    // MARK: HomeViewControllerDataSource
    
    func handleSkipButtonPress(currentUserID: String, senderUserID: String) {
        // when we skip we need to update the user's interaction collection
        // updates as -> ["key_id_of_interacted_user": "0"]
        let db = Firestore.firestore()
        db.collection("users").document(currentUserID).collection("interactions").addDocument(data: [senderUserID : 0]) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID")
            }
            
        }
    }
    
    func handleLikeButtonPress(currentUserID: String, senderUserID: String) {
        // when we like someone this will be entered into their matches collection
        // && when we like someone our interaction table will be updated
        let db = Firestore.firestore()
        db.collection("users").document(currentUserID).collection("interactions").addDocument(data: [senderUserID : 1]) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID")
            }
        }
        
        db.collection("users").document(senderUserID).collection("matches").addDocument(data: [currentUserID : 1]) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID")
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    // we set the amount of items that will appear
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomies.count
    }
    
    // used for set up of a collection view cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //here we are creating a variable to refernce a collection view of type HomeCollectionViewCell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return UICollectionViewCell()
        }
        
        let roomie = roomies[indexPath.row]
        cell.roomiesFirstNameLabel.text = roomie.firstName
        cell.roomieAgeLabel.text = roomie.age
        cell.delegate = self
        cell.currentUserID = currentUserId
        cell.senderUserID = roomie.id
        
        return cell
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUserProfile" {
            let detailVC = segue.destination as! ProfileDetailViewController
            detailVC.roomie = sender as? Roomie
        }
    }
    
    // MARK: UICollectionViewDelegate.
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showUserProfile",
                     sender: roomies[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width , height: self.view.frame.height / 2)
    }
}
