//
//  File.swift
//  Room8s
//
//  Created by Jeremiah on 1/18/23.
//

import Foundation
import UIKit

class Utilities{
    
// this makes sure users are using a valid password
    static func isPasswordValid(_ password : String) -> Bool{
        let passswordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passswordTest.evaluate(with: password)
    }
    

    
    
}


