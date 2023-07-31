//
//  LSNavPage.swift
//  Room8s
//
//  Created by Jeremiah on 1/16/23.
//

import Foundation
import UIKit


class LSNavViewController : UIViewController {
    
    @IBOutlet weak var homeSignInButton: UIButton!
    @IBOutlet weak var homeLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "background")
            let backgroundImageView = UIImageView(image: backgroundImage)
            backgroundImageView.frame = view.bounds
            backgroundImageView.contentMode = .scaleAspectFill
            view.addSubview(backgroundImageView)
            view.sendSubviewToBack(backgroundImageView)

        // Do any additional setup after loading the view.
    }
    
}
