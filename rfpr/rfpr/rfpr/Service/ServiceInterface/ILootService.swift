//
//  ILootService.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//

protocol ILootService {
    func createLoot(id: Int?, fish: String?, weight: Int?, step: Step?) -> Loot?
    
    func updateLoot(id: Int?)
    func deleteLoot(id: Int?)
}
