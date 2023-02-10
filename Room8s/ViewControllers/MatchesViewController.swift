//
//  MatchesViewController.swift
//  Room8s
//
//  Created by Jeremiah on 2/1/23.
//

import UIKit
import Firebase

class MatchesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var currentUserInteractions: [Interaction] = []
    var currentUserMatches: [Match] = []
    var matchedRoomies: [Roomie] = []
    var allUsers:[Roomie] = []
    @IBOutlet weak var matchesCollectionView: UICollectionView!
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchesCollectionView.delegate = self
        matchesCollectionView.dataSource = self
        fetchAllUsers {
            self.interactionObservable()
            self.matchesObservable()
        }
    }
    
    // MARK: Private
    
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
    
    private func matchesObservable() {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("matches").addSnapshotListener { (snapshot, error) in
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
                        self.currentUserMatches.append(Match(roomieID: roomieID,
                                                             interactionType: interactionType))
                    }
                    print("the current user interactions are: \(self.currentUserInteractions)")
                    self.reloadView()
                }
            }
        }
    }
    
    private func fetchAllUsers(completion: @escaping () -> Void) {
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
                        self.allUsers = snapshot.documents.map { d in
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
                       // print("allUsers2: \(self.allUsers)")
                        // Remove the current user from the roomies list
                        self.allUsers.removeAll { roomie in
                            roomie.id == userId
                        }
                        completion()
                    }
                }
            }
            else {
                // handle error
            }
        }
    }
    
    private func reloadView() {
        print("currentUserInteractions: \(currentUserInteractions))")
        print("currentUserMatches: \(currentUserMatches))")
        // first loop throught current user interactions and find key value pairs that have a one for the value
        // compare the key ideas that had a one and see if the key id is in the matches Array
        //look through the match roomies and filter the matches based off the key ideas that were found between the matches and interactions array
        // reload view
        willMatch()
        self.matchesCollectionView.reloadData()
    }
    
    func willMatch() {
        print("allUsersbefore: \(self.allUsers)")
        var didMatch = [String]()
        var userInteractionLikes = [String]()
        for interaction in currentUserInteractions {
            if interaction.interactionType == 1 {
                userInteractionLikes.append(interaction.roomieID)
            }
        }
        for matches in currentUserMatches {
            if userInteractionLikes.contains(where: {$0 == matches.roomieID}){
                didMatch.append(matches.roomieID)
            }
        }
        self.matchedRoomies = self.allUsers.filter({ roomie in
            return didMatch.contains(where: {$0 == roomie.id})
        })
        
        print("currentUserInteractions: \(currentUserInteractions)")
        print("currentUserMatches: \(currentUserMatches)")
        print("matchedRoomies: \(self.matchedRoomies)")
        print("allUsers: \(self.allUsers)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUserProfile" {
            let detailVC = segue.destination as! ProfileDetailViewController
            detailVC.roomie = sender as? Roomie
        }
    }
    
    // MARK: UICollectionViewDelegate.
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchedRoomies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //here we are creating a variable to refernce a collection view of type HomeCollectionViewCell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchesCollectionViewCell.reuseIdentifier, for: indexPath) as? MatchesCollectionViewCell else {
            return UICollectionViewCell()
        }
        let roomie = matchedRoomies[indexPath.row]
        cell.roomie = roomie
        cell.firstName.text = roomie.firstName
        cell.profileAge.text = roomie.age
        cell.email.text = roomie.email
        //        cell.firstName.text = "Jake"
        //        cell.profileAge = "30"
        //        cell.ProfileImage
        //        cell.email.text = "NotJakeFromStateFarm@gmail.com"
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell at index \(indexPath.row) selected")
        performSegue(withIdentifier: "showUserProfile",
                     sender: matchedRoomies[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width , height: self.view.frame.height / 4)
    }
}
