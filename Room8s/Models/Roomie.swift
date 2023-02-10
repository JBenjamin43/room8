//
//  Models.swift
//  Room8s
//
//  Created by Jeremiah on 2/1/23.
//

import Foundation

struct Roomie {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var City: String
    var State: String
    var PhoneNumber: String
    var gender: String
    var age : String
    var bio : String
}
struct Interaction {
    var roomieID : String
    var interactionType : Int
}

struct Match {
    var roomieID : String
    var interactionType : Int
}
