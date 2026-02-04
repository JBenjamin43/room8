//
//  SwipeHomeScreen.swift
//  Room8s
//
//  Created by Jeremiah Benjamin on 6/26/24.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class HomeScreenViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView!
    private var items: [String] = ["One", "Two", "Three", "Four"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    private func setupLayout() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemIndigo.cgColor, UIColor.systemTeal.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = UIScreen.main.bounds.size
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(FullScreenCell.self, forCellWithReuseIdentifier: "FullScreenCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isPagingEnabled = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return items.count
        }
        
    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView,
                cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullScreenCell",
                                                            for: indexPath) as? FullScreenCell else {
                return UICollectionViewCell()
            }
            cell.configure(text: items[indexPath.item])
            return cell
        }
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            return collectionView.bounds.size // full screen
        }
}


