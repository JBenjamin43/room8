//
//  FirstTimeLoginView.swift
//  Room8s
//
//  Created by Jeremiah Benjamin on 9/16/25.
//

import Foundation
import UIKit

class FirstTimeLoginView: UIView {
    
    public let collectionView: UICollectionView
    
    override init(frame: CGRect) {
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemIndigo.cgColor, UIColor.systemTeal.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        
        super.init(frame: frame)
        
        collectionView.register(FullScreenCell.self, forCellWithReuseIdentifier: "FullScreenCell")
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        layoutIfNeeded()
        gradient.frame = bounds
        
        
        }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}
