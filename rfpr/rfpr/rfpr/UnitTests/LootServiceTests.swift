//
//  LootServiceTests.swift
//  UnitTestAutorization
//
//  Created by poliorang on 03.04.2023.
//

import XCTest
@testable import rfpr

class LootServiceTests: XCTestCase {
    
    var lootService: ILootService!
    var lootRepository: ILootRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        lootRepository = MockLootRepository()
        lootService = LootService(lootRepository: lootRepository)
    }

    override func tearDownWithError() throws {
        lootService = nil
        lootRepository = nil
        try super.tearDownWithError()
    }

    func testCreateLoot() throws {
        let step = Step(id: 1, name: "1", participant: nil, competition: nil)
        let loot = Loot(id: 1, fish: "Щука", weight: 500, score: 1000, step: step)
        XCTAssertEqual(lootService.createLoot(id: 1, fish: "Щука", weight: 500, step: step), loot)
    }
    
    func testCreateLootNilStep() throws {
        let loot = Loot(id: 1, fish: "Щука", weight: 500, score: 1000, step: nil)
        XCTAssertEqual(lootService.createLoot(id: 1, fish: "Щука", weight: 500, step: nil), loot)
    }
    
    func testUpdateLoot() throws {
        XCTAssertNoThrow(lootService.updateLoot(id: 1))
    }
    
    func testUpdateLootNil() throws {
        XCTAssertNoThrow(lootService.updateLoot(id: nil))
    }
    
    func testDeleteLoot() throws {
        XCTAssertNoThrow(lootService.deleteLoot(id: 1))
    }
    
    func testDeleteLootNil() throws {
        XCTAssertNoThrow(lootService.deleteLoot(id: nil))
    }

}
