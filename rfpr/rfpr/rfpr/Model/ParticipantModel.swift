//
//  ParticipantModel.swift
//  rfpr
//
//  Created by poliorang on 28.03.2023.
//

import Foundation

enum Role: Int {
    case participant = 1
    case referee = 2
    case admin = 3
}

struct Participant: Hashable {
    var id: String?
    var lastName: String
    var firstName: String
    var patronymic: String?
    var team: Team?
    var city: String
    var birthday: Date
    var role: String
    var score: Int
}

extension Participant: Equatable {
    static func == (lhs: Participant, rhs: Participant) -> Bool {
        if lhs.id == rhs.id &&
            lhs.lastName == rhs.lastName &&
            lhs.firstName == rhs.firstName &&
            lhs.team == rhs.team &&
            lhs.patronymic == rhs.patronymic &&
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
