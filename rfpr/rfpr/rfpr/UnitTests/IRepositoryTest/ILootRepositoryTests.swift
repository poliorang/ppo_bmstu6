//
//  LootRepositoryTests.swift
//  UnitTestAutorization
//
//  Created by poliorang on 03.04.2023.
//

import XCTest
@testable import rfpr


class ILootRepositoryTests: XCTestCase {

    var lootRepository: MockLootRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        lootRepository = MockLootRepository()
    }

    override func tearDownWithError() throws {
        lootRepository = nil
        try super.tearDownWithError()
    }

    func testCreateLoot() throws {
        let loot = Loot(id: "1", fish: "Щука", weight: 500, score: 1000)
        XCTAssertNoThrow(try lootRepository.createLoot(loot: loot))
    }
    
    func testUpdateLoot() throws {
        let previousLoot = Loot(id: "1", fish: "Щука", weight: 500, score: 1000)
        let newLoot = Loot(id: "1", fish: "Осетр", weight: 500, score: 1000)
        
        XCTAssertNoThrow(try lootRepository.updateLoot(previousLoot: previousLoot, newLoot: newLoot))
    }
    
    func testUpdateLootNilPrev() throws {
        let previousLoot = Loot(id: "10", fish: "1", weight: 500, score: 1000)
        let newLoot = Loot(id: "2", fish: "Осетр", weight: 500, score: 1000)
        
        XCTAssertThrowsError(try lootRepository.updateLoot(previousLoot: previousLoot, newLoot: newLoot))
    }
    
    func testDeleteLoot() throws {
        let loot = Loot(id: "1", fish: "Щука", weight: 500, score: 1000)
        XCTAssertNoThrow(try lootRepository.deleteLoot(loot: loot))
    }
    
    func testGetLoots() throws {
        let loots = [Loot(id: "1", fish: "Щука", weight: 500, score: 1000)]
        
        XCTAssertEqual(try lootRepository.getLoots(), loots)
    }
    
    func testGetLootByStep() throws {
        let step = Step(id: "1", name: "A", participant: nil, competition: nil, score: 1000)
        let loot = Loot(id: "2", fish: "Щука", weight: 500, step: step, score: 1000)
        
        XCTAssertEqual(try lootRepository.getLootByStep(step: step), [loot])
    }
}
