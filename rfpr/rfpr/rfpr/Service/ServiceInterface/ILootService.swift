//
//  ILootService.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//

protocol ILootService {
    func createLoot(id: String?, fish: String?, step: Step?, weight: Int?) throws -> Loot
    
    func updateLoot(previousLoot: Loot?, newLoot: Loot?) throws -> Loot
    func deleteLoot(loot: Loot?) throws
    
    func getLoot(fishName: String?, score: Int?) throws -> Loot?
    func getLootByStep(step: Step?) throws -> [Loot]? 
}
