//
//  ILootService.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//

protocol ILootRepository {
    func createLoot(id: Int?, fish: String?, weight: Int?, step: Step?) -> Loot?
    
    func updateLoot(id: Int?, loot: Loot?) -> Any?
    func deleteLoot(id: Int?) -> Any?
}

