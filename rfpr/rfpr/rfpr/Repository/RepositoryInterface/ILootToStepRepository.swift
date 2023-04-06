//
//  ILootToStepRepository.swift
//  rfpr
//
//  Created by poliorang on 01.04.2023.
//

protocol ILootToStepRepository {
    func addLoot(loot: Loot?, step: Step?) -> Any?
    func deleteLoot(loot: Loot?, step: Step?) -> Any?
}
