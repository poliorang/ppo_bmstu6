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
    var lootByStepRepository: ILootByStepRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        lootRepository = MockLootRepository()
        lootByStepRepository = MockLootRepository()
        lootService = LootService(lootRepository: lootRepository, lootByStepRepository: lootByStepRepository)
    }

    override func tearDownWithError() throws {
        lootService = nil
        lootRepository = nil
        try super.tearDownWithError()
    }

    func testCreateLoot() throws {
        let step = Step(id: "1", name: "1", participant: nil, competition: nil, score: 0)
        XCTAssertNoThrow(try lootService.createLoot(id: "1", fish: "Щука", step: step, weight: 500))
    }
    
    func testCreateLootNilId() throws {
        let step = Step(id: "1", name: "1", participant: nil, competition: nil, score: 0)
        XCTAssertNoThrow(try lootService.createLoot(id: nil, fish: "Щука", step: step, weight: 500))
    }
    
    func testCreateLootNilName() throws {
        let step = Step(id: "1", name: "1", participant: nil, competition: nil, score: 0)
        XCTAssertThrowsError(try lootService.createLoot(id: "1", fish: nil, step: step, weight: 500))
    }
    
    func testCreateLootWeightNil() throws {
        let step = Step(id: "1", name: "1", participant: nil, competition: nil, score: 0)
        XCTAssertThrowsError(try lootService.createLoot(id: "1", fish: "Щука", step: step, weight: nil))
    }
    
    func testUpdateLoot() throws {
        let previousLoot = Loot(id: "1", fish: "Щука", weight: 500, score: 1000)
        let newLoot = Loot(id: "1", fish: "Осетр", weight: 500, score: 1000)
        
        XCTAssertNoThrow(try lootService.updateLoot(previousLoot: previousLoot, newLoot: newLoot))
    }
    
    func testUpdateLootNoPrev() throws {
        let previousLoot = Loot(id: "10", fish: "Щука", weight: 500, score: 1000)
        let newLoot = Loot(id: "1", fish: "Осетр", weight: 500, score: 1000)
        
        XCTAssertThrowsError(try lootService.updateLoot(previousLoot: previousLoot, newLoot: newLoot))
    }
    
    func testUpdateLootNilPrev() throws {
        let newLoot = Loot(id: "2", fish: "Осетр", weight: 500, score: 1000)
        
        XCTAssertThrowsError(try lootService.updateLoot(previousLoot: nil, newLoot: newLoot))
    }
    
    func testUpdateLootNilNew() throws {
        let previousLoot = Loot(id: "2", fish: "Щука", weight: 500, score: 1000)
        
        XCTAssertThrowsError(try lootService.updateLoot(previousLoot: previousLoot, newLoot: nil))
    }
    
    func testDeleteLoot() throws {
        let loot = Loot(id: "1", fish: "Щука", weight: 500, score: 1000)
        
        XCTAssertNoThrow(try lootService.deleteLoot(loot: loot))
    }
    
    func testDeleteLootNilId() throws {
        XCTAssertThrowsError(try lootService.deleteLoot(loot: nil))
    }
    
    func testDeleteLootNoLoot() throws {
        let loot = Loot(id: "10", fish: "ААА", weight: 1000, score: 1500)
        
        XCTAssertThrowsError(try lootService.deleteLoot(loot: loot))
    }
    
    func testGetLoot() throws {
        let loot = Loot(id: "1", fish: "Щука", weight: 500, score: 1000)
        
        XCTAssertEqual(try lootService.getLoot(fishName: "Щука", score: 1000), loot)
    }
    
    func testGetLootByStep() throws {
        let step = Step(id: "1", name: "A", participant: nil, competition: nil, score: 1000)
        let loot = Loot(id: "2", fish: "Щука", weight: 500, step: step, score: 1000)
        
        XCTAssertEqual(try lootService.getLootByStep(step: step), [loot])
    }
}
