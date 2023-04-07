//
//  LootModel.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//

struct Loot {
    var id: Int
    var fish: String
    var weight: Int
    var score: Int
    var step: Step?
}
 
extension Loot: Equatable {
    static func == (lhs: Loot, rhs: Loot) -> Bool {
        if lhs.id == rhs.id &&
            lhs.fish == rhs.fish &&
            lhs.weight == rhs.weight &&
            lhs.weight == rhs.weight &&
            lhs.score == rhs.score &&
            lhs.step == rhs.step {
            return true
        }
        
        return false
    }
    
    static func != (lhs: Loot, rhs: Loot) -> Bool {
        return !(lhs == rhs)
    }
}
