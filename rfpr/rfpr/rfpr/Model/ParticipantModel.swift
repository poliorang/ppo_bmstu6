//
//  ParticipantModel.swift
//  rfpr
//
//  Created by poliorang on 28.03.2023.
//

import Foundation

struct Participant {
    var id: Int
    var fullname: String
    var city: String
    var birthday: Date?
    var role: String
    var autorization: Autorization?
    var score: Int
}

extension Participant: Equatable {
    static func == (lhs: Participant, rhs: Participant) -> Bool {
        if lhs.id == rhs.id &&
            lhs.fullname == rhs.fullname &&
            lhs.city == rhs.city &&
            lhs.birthday == rhs.birthday &&
            lhs.role == rhs.role {
            return true
        }
        
        return false
    }
    
    static func != (lhs: Participant, rhs: Participant) -> Bool {
        return !(lhs == rhs)
    }
}
