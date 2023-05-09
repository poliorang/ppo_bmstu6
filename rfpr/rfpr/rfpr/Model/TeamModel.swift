//
//  TeamModel.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//

import RealmSwift

struct Team: Hashable {
    var id: String?
    var name: String
    var competitions: [Competition]?
    var score: Int
}


extension Team: Equatable {
    static func == (lhs: Team, rhs: Team) -> Bool {
        if lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.competitions == rhs.competitions {
            return true
        }
        
        return false
    }
    
    static func != (lhs: Team, rhs: Team) -> Bool {
        return !(lhs == rhs)
    }
}
