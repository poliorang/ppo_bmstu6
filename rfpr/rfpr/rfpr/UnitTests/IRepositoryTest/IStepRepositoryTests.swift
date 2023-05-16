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
        let step = Step(id: "1", name: "1", participant: nil, competition: nil, score: 0)
        XCTAssertNoThrow(try stepRepository.createStep(step: step))
    }
                         
    func testCreateStepNilLoot() throws {
        let step = Step(id: "1", name: "1", participant: nil, competition: nil, score: 0)
        XCTAssertNoThrow(try stepRepository.createStep(step: step))
    }
    
    func testUpdateStep() throws {
        let previousStep = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
        let newStep = Step(id: "1", name: "2", participant: nil, competition: nil, score: 0)
        XCTAssertNoThrow(try stepRepository.updateStep(previousStep: previousStep, newStep: newStep))
    }
    
    func testUpdateStepNil() throws {
        let previousStep = Step(id: "10", name: "Первый день", participant: nil, competition: nil, score: 0)
        let newStep = Step(id: "1", name: "2", participant: nil, competition: nil, score: 0)
        XCTAssertThrowsError(try stepRepository.updateStep(previousStep: previousStep, newStep: newStep))
    }
    
    func testDeleteStep() throws {
        let step = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
        XCTAssertNoThrow(try stepRepository.deleteStep(step: step))
    }
    
    func testDeleteStepNil() throws {
        let step = Step(id: "10", name: "Первый день", participant: nil, competition: nil, score: 0)
        XCTAssertThrowsError(try stepRepository.deleteStep(step: step))
    }
    
    func testAddLoot() throws {
        let loot = Loot(id: "1", fish: "Щука", weight: 500, score: 100)
        let step = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
        
        XCTAssertNoThrow(try stepRepository.addLoot(loot: loot, step: step))
    }
    
    func testAddLootNil() throws {
        let loot = Loot(id: "10", fish: "Щука", weight: 500, score: 100)
        let step = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
        
        XCTAssertNoThrow(try stepRepository.addLoot(loot: loot, step: step))
    }
    
    func testDeleteLoot() throws {
        let loot = Loot(id: "1", fish: "Щука", weight: 500, score: 1000)
        let step = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
        
        XCTAssertNoThrow(try stepRepository.deleteLoot(loot: loot, step: step))
    }
    
    func testGetSteps() throws {
        let steps = [Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)]
        
        XCTAssertEqual(try stepRepository.getSteps(), steps)
    }
    
    func testGetStepByParticipant() throws {
        let participant = Participant(id: "1", lastName: "a", firstName: "a", patronymic: nil, team: nil, city: "a", birthday: bith, score: 0)
        let steps = [Step(id: "1", name: "Первый день", participant: participant, competition: nil, score: 0)]
        
        XCTAssertEqual(try stepRepository.getStepByParticipant(participant: participant), steps)
    }
    
    func testGetStepByCompetition() throws {
        let competition = Competition(id: "1", name: "aaa", teams: nil)
        let steps = [Step(id: "1", name: "Первый день", participant: nil, competition: competition, score: 0)]
        
        XCTAssertEqual(try stepRepository.getStepByCompetition(competition: competition), steps)
    }
    
    func testStepAddParticipant() throws {
        let participant = Participant(id: "1", lastName: "a", firstName: "a", patronymic: nil, team: nil, city: "a", birthday: bith, score: 0)
        let step = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
        
        XCTAssertNoThrow(try stepRepository.addParticipant(participant: participant, step: step))
    }
}
