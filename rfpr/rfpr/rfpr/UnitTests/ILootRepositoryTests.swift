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
        let step = Step(id: 1, name: "1", participant: nil, competition: nil)
        let loot = Loot(id: 1, fish: "Щука", weight: 500, score: 1000, step: step)
        XCTAssertEqual(lootRepository.createLoot(id: 1, fish: "Щука", weight: 500, step: step), loot)
    }
    
    func testCreateLootNilStep() throws {
        let loot = Loot(id: 1, fish: "Щука", weight: 500, score: 1000, step: nil)
        XCTAssertEqual(lootRepository.createLoot(id: 1, fish: "Щука", weight: 500, step: nil), loot)
    }
    
    func testCreateLootNil() throws {
        XCTAssertNil(lootRepository.createLoot(id: 1, fish: "Щука", weight: nil, step: nil))
    }
    
    func testUpdateLoot() throws {
        let loot = Loot(id: 1, fish: "1", weight: 500, score: 1000, step: nil)
        XCTAssertEqual(lootRepository.updateLoot(id: 1, loot: loot) as! String, "Data of loots type was updated")
    }
    
    func testUpdateLootNil() throws {
        let loot = Loot(id: 1, fish: "1", weight: 500, score: 1000, step: nil)
        XCTAssertNil(lootRepository.updateLoot(id: nil, loot: loot))
    }
    
    func testDeleteLoot() throws {
        XCTAssertEqual(lootRepository.deleteLoot(id: 1) as! String, "Data of loots type was deleted")
    }
    
    func testDeleteLootNil() throws {
        XCTAssertNil(lootRepository.deleteLoot(id: nil))
    }
    
}
