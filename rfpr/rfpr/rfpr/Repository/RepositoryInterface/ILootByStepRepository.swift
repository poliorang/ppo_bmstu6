//
//  ILootByStepRepository.swift
//  rfpr
//
//  Created by poliorang on 10.05.2023.
//

protocol ILootByStepRepository {
    func getLootByStep(step: Step) throws -> [Loot]?
}
