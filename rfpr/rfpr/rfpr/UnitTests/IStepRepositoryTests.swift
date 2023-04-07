//
//  StepRepositoryTests.swift
//  UnitTestAutorization
//
//  Created by poliorang on 03.04.2023.
//

import XCTest
@testable import rfpr

class IStepRepositoryTests: XCTestCase {
    
    var stepRepository: MockStepRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        stepRepository = MockStepRepository()
    }

    override func tearDownWithError() throws {
        stepRepository = nil
        try super.tearDownWithError()
    }

    func testCreateStep() throws {
        let step = Step(id: 1, name: "1", participant: nil, competition: nil)
        XCTAssertEqual(stepRepository.createStep(id: 1, name: "1", participant: nil, competition: nil), step)
    }
    
    func testCreateStepNil() throws {
        XCTAssertNil(stepRepository.createStep(id: 1, name: nil, participant: nil, competition: nil))
    }
    
    func testUpdateStep() throws {
        let step = Step(id: 1, name: "1", participant: nil, competition: nil)
        XCTAssertEqual(stepRepository.updateStep(id: 1, step: step) as! String, "Data of steps type was updated")
    }
    
    func testUpdateStepNil() throws {
        let step = Step(id: 1, name: "1", participant: nil, competition: nil)
        XCTAssertNil(stepRepository.updateStep(id: nil, step: step))
    }
    
    func testDeleteStep() throws {
        XCTAssertEqual(stepRepository.deleteStep(id: 1) as! String, "Data of steps type was deleted")
    }
    
    func testDeleteStepNil() throws {
        XCTAssertNil(stepRepository.deleteStep(id: nil))
    }
    
    func testAddLoot() throws {
        let loot = Loot(id: 1, fish: "Щука", weight: 500, score: 100, step: nil)
        let step = Step(id: 1, name: "1", participant: nil, competition: nil)
        
        XCTAssertEqual(stepRepository.addLoot(loot: loot, step: step) as! String, "loots was added to steps")
    }
    
    func testAddLootNilLoot() throws {
        let step = Step(id: 1, name: "1", participant: nil, competition: nil)
        
        XCTAssertNil(stepRepository.addLoot(loot: nil, step: step))
    }
    
    func testAddLootNilStep() throws {
        let loot = Loot(id: 1, fish: "Щука", weight: 500, score: 100, step: nil)
        
        XCTAssertNil(stepRepository.addLoot(loot: loot, step: nil))
    }
    
    func testAddLootNil() throws {
        XCTAssertNil(stepRepository.addLoot(loot: nil, step: nil))
    }
    
    func testDeleteLoot() throws {
        let loot = Loot(id: 1, fish: "Щука", weight: 500, score: 100, step: nil)
        let step = Step(id: 1, name: "1", participant: nil, competition: nil)
        
        XCTAssertEqual(stepRepository.deleteLoot(loot: loot, step: step) as! String, "loots was deleted from steps")
    }
    
    func testDeleteLootNilLoot() throws {
        let step = Step(id: 1, name: "1", participant: nil, competition: nil)
        
        XCTAssertNil(stepRepository.deleteLoot(loot: nil, step: step))
    }
    
    func testDeleteLootNilStep() throws {
        let loot = Loot(id: 1, fish: "Щука", weight: 500, score: 100, step: nil)
        
        XCTAssertNil(stepRepository.deleteLoot(loot: loot, step: nil))
    }
    
    func testDeleteLootNil() throws {
        XCTAssertNil(stepRepository.deleteLoot(loot: nil, step: nil))
    }
}
