//
//  BeforeLootRepositoryTests.swift
//  rfpr
//
//  Created by poliorang on 21.04.2023.
//

class BeforeLootRepositoryTest {
    var lootRepository: LootRepository!
    
    func setupRepository(config: String) throws {
        do {
            lootRepository = try LootRepository(configRealm: config)
            try lootRepository.realmDeleteAll()
        } catch {
            print("Не удалось открыть Realm: \(config)")
            throw DatabaseError.openError
        }
    }
    
    func createData() throws {
        let loot1 = Loot(id: "6442852b2b74d595cb4f4756", fish: "Сом", weight: 1000, score: 1500)
        let loot2 = Loot(id: "6442852b2b74d595cb4f4760", fish: "Форель", weight: 100, score: 600)
        
        do {
            try [loot1, loot2].forEach {
                try _ = lootRepository.createLoot(loot: $0)
            }
        } catch {
                throw DatabaseError.addError
        }
    }
    
}
