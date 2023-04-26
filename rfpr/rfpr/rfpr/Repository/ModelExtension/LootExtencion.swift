//
//  LootExtencion.swift
//  rfpr
//
//  Created by poliorang on 21.04.2023.
//

extension Loot {
    func convertLootToRealm() throws -> LootRealm {
        do {
            return try LootRealm(id: self.id, fish: self.fish, weight: self.weight, step: self.step?.convertStepToRealm(), score: self.score)
        } catch {
            throw DatabaseError.addError
        }
    }
}
