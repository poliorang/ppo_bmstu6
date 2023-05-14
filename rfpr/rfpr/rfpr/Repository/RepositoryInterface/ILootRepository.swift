//
//  ILootService.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//

protocol ILootRepository {
    func createLoot(loot: Loot) throws -> Loot?
    
    func updateLoot(previousLoot: Loot, newLoot: Loot) throws -> Loot? 
    func deleteLoot(loot: Loot) throws
    
    func getLoots() throws -> [Loot]?
}

