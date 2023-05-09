//
//  LootModel.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//

struct Loot {
    var id: String?
    var fish: String
    var weight: Int
    var step: Step?
    var score: Int
}

extension Loot: Equatable {
    static func == (lhs: Loot, rhs: Loot) -> Bool {
        if lhs.id == rhs.id &&
            lhs.fish == rhs.fish &&
            lhs.weight == rhs.weight &&
            lhs.weight == rhs.weight &&
            lhs.step == rhs.step &&
            lhs.score == rhs.score {
            return true
        }
        
        return false
    }
    
    static func != (lhs: Loot, rhs: Loot) -> Bool {
        return !(lhs == rhs)
    }
}
