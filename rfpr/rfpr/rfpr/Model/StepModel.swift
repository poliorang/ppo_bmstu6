//
//  StepModel.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//

struct Step {
    var id: String
    var name: String
    var participant: Participant?
    var competition: Competition?
}

extension Step: Equatable {
    static func == (lhs: Step, rhs: Step) -> Bool {
        if lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.participant == rhs.participant &&
            lhs.competition == rhs.competition {
            return true
        }
        
        return false
    }
    
    static func != (lhs: Step, rhs: Step) -> Bool {
        return !(lhs == rhs)
    }
}
