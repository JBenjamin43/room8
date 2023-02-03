//
//  MatchesViewController.swift
//  Room8s
//
//  Created by Jeremiah on 2/1/23.
//

import UIKit

class MatchesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var data = [1,2,3,4,5,6,]
    
    @IBOutlet weak var matchesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        matchesCollectionView.delegate = self
        matchesCollectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //here we are creating a variable to refernce a collection view of type HomeCollectionViewCell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchesCollectionViewCell.reuseIdentifier, for: indexPath) as? MatchesCollectionViewCell else {
            return UICollectionViewCell()
        }
        
//        cell.firstName.text = "Jake"
//        cell.profileAge = "30"
//        cell.ProfileImage
//        cell.email.text = "NotJakeFromStateFarm@gmail.com"
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width , height: self.view.frame.height / 4)
    }
}
