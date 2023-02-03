//
//  HomeViewController.swift
//  Room8s
//
//  Created by Jeremiah on 1/18/23.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var users = [Roomies(firstName: "jacari", lastName: "boboye", email: "jbob@gm.com", City: "", State: "CA", PhoneNumber: "313", gender: "Male", age: "27", bio: "hdfdafd")]
    @IBOutlet weak var homeViewCollectionView: UICollectionView!
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeViewCollectionView.delegate = self
        homeViewCollectionView.dataSource = self
        
        fetchData()
    }
    
    
    
    private func fetchData() {
        
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
                        self.list = snapshot.documents.map { d in
                            
                            return users(id, d.documentID,
                                         name: d["name"] as? String ?? "",
                                         age: d["age"] as? String ?? "")
                            
                            
                        }
                    }
                }
            }
            else {
                // handle error
            }
            
            
        }
        
        
        // MARK: UICollectionViewDataSource
        
        // we set the amount of items that will appear
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return users.count
            
        }
        
        // used for set up of a collection view cells
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            //here we are creating a variable to refernce a collection view of type HomeCollectionViewCell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeCollectionViewCell else {
                return UICollectionViewCell()
            }
            let user = users[indexPath.row]
            cell.roomiesFirstNameLabel.text = user.firstName
            cell.roomieAgeLabel.text = user.lastName
            //        cell.roomieProfileImage = user.
            //        cell.likeButton
            //        cell.SkipButton
            //        cell.likeButtonAction(<#T##sender: Any##Any#>)
            //        cell.skipButtonAction(<#T##sender: Any##Any#>)
            return cell
        }
        
        // MARK: UICollectionViewDelegate.
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
            
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: self.view.frame.width , height: self.view.frame.height / 2)
        }
    }
    
}
