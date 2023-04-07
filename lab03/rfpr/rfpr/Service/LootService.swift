//
//  LootService.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//

class LootService: ILootService {

    let lootRepository: ILootRepository?
    
    init(lootRepository: ILootRepository) {
        self.lootRepository = lootRepository
    }
    
    func createLoot(id: Int?, fish: String?, weight: Int?, step: Step?) -> Loot? {
        let loot = lootRepository?.createLoot(id: id, fish: fish, weight: weight, step: step)
        
        return loot
    }
    
    func updateLoot(id: Int?, loot: Loot?) {
        lootRepository?.updateLoot(id: id, loot: loot)
    }
    
    func deleteLoot(id: Int?) {
        lootRepository?.deleteLoot(id: id)
    }
}
