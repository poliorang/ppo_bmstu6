//
//  LootRepositoryTest.swift
//  UnitTestAutorization
//
//  Created by poliorang on 09.04.2023.
//

import XCTest
import RealmSwift
@testable import rfpr

fileprivate var lootRepository: LootRepository!
fileprivate var config = "LootRepositoryTests"
fileprivate var beforeTestClass: BeforeLootRepositoryTest!

class LootRepositoryTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        
        do {
            lootRepository = try LootRepository(configRealm: config)
        } catch {
            print("Не удалось открыть Realm: \(config)")
            exit(-1)
        }
        
        // загрузить все данные для тестов
        beforeTestClass = BeforeLootRepositoryTest()
        
        do {
            try beforeTestClass.setupRepository(config: config)
            try beforeTestClass.createData()
        } catch {
            print("Не удалось загрузить данные: \(config)")
            exit(-1)
        }
    }

    override class func tearDown() {
        lootRepository = nil
        beforeTestClass = nil
        super.tearDown()
    }

    
    func testCreateLoot() throws {
        let loot = Loot(id: "6442852b2b74d595cb4f4764", fish: "Щука", weight: 500, score: 1000)
        var createdLoot: Loot?
        
        XCTAssertNoThrow(createdLoot = try lootRepository.createLoot(loot: loot))
        XCTAssertEqual(createdLoot, loot)
    }
    
    func testUpdateLoot() throws {
        let previousLoot = Loot(id: "6442852b2b74d595cb4f4760", fish: "Форель", weight: 100, score: 600)
        let newLoot = Loot(id: "6442852b2b74d595cb4f4760", fish: "Осетр", weight: 100, score: 600)
        var updatedLoot: Loot?
        
        XCTAssertNoThrow(updatedLoot = try lootRepository.updateLoot(previousLoot: previousLoot, newLoot: newLoot))
        XCTAssertEqual(updatedLoot, newLoot)
    }
    
    func testUpdateLootNoPrevious() throws {
        let previousLoot = Loot(id: "6442852b2b74d595cb4f4761", fish: "Лосось", weight: 1000, score: 1500)
        let newLoot = Loot(id: "6442852b2b74d595cb4f4761", fish: "Осетр", weight: 400, score: 900)
        var updatedLoot: Loot?
        
        XCTAssertThrowsError(updatedLoot = try lootRepository.updateLoot(previousLoot: previousLoot, newLoot: newLoot))
        XCTAssertEqual(updatedLoot, nil)
    }
    
    func testDeleteLoot() throws {
        let loot = Loot(id: "6442852b2b74d595cb4f4756", fish: "Сом", weight: 1000, score: 1500)
    
        XCTAssertNoThrow(try lootRepository.deleteLoot(loot: loot))
        XCTAssertEqual(try lootRepository.getLoot(id: "6442852b2b74d595cb4f4756"), nil)
    }

    func testDeleteLootNoLoot() throws {
        let loot = Loot(id: "6442852b2b74d595cb4f4711", fish: "Лосось", weight: 2000, score: 2500)
        
        XCTAssertThrowsError(try lootRepository.deleteLoot(loot: loot))
    }
}

