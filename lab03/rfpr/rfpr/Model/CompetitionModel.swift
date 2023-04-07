//
//  CompetitionModel.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//

struct Competition {
    var id: Int
    var name: String
    var teams: [Team]?
}

extension Competition: Equatable {
    static func == (lhs: Competition, rhs: Competition) -> Bool {
        if lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.teams == rhs.teams {
            return true
        }
        
        return false
    }
    
    static func != (lhs: Competition, rhs: Competition) -> Bool {
        return !(lhs == rhs)
    }
}
