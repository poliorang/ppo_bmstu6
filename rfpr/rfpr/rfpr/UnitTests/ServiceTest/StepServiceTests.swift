
//  StepServiceTests.swift
//  UnitTestAutorization
//
//  Created by poliorang on 03.04.2023.
//

import XCTest
@testable import rfpr

class StepServiceTests: XCTestCase {

    var stepService: IStepService!
    var stepRepository: IStepRepository!
    var stepByParticipantRepository: IStepByParticipantRepository!
    var lootToStepRepository: ILootToStepRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        stepRepository = MockStepRepository()
        stepByParticipantRepository = MockStepRepository()
        lootToStepRepository = MockStepRepository()
        stepService = StepService(stepRepository: stepRepository,
                                  stepByParticipantRepository: stepByParticipantRepository,
                                  lootToStepRepository: lootToStepRepository)
    }

    override func tearDownWithError() throws {
        stepService = nil
        stepRepository = nil
        try super.tearDownWithError()
    }
    
    func testCreateStep() throws {
        XCTAssertNoThrow(try stepService.createStep(id: "1", name: "1", participant: nil, competition: nil))
    }
    
    func testCreateStepNilLoot() throws {
        XCTAssertNoThrow(try stepService.createStep(id: "1", name: "1", participant: nil, competition: nil))
    }
    
    func testCreateStepNil() throws {
        XCTAssertThrowsError(try stepService.createStep(id: "1", name: nil, participant: nil, competition: nil))
    }
    
    func testDeleteStepNilStep() throws {
        XCTAssertThrowsError(try stepService.deleteStep(step: nil))
    }
    
    func testDeleteStep() throws {
        let step = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
        
        XCTAssertNoThrow(try stepService.deleteStep(step: step))
    }
    
    func testDeleteStepNilId() throws {
        let step = Step(id: "10", name: "Первый день", participant: nil, competition: nil, score: 0)
        
        XCTAssertThrowsError(try stepService.deleteStep(step: step))
    }
    
    func testAddLoot() throws {
        let loot = Loot(id: "1", fish: "Щука", weight: 500, score: 100)
        let step = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
        
        XCTAssertNoThrow(try stepService.addLoot(loot: loot, step: step))
    }
    
    func testAddLootNil() throws {
        let loot = Loot(id: "10", fish: "Щука", weight: 500, score: 100)
        let step = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
        
        XCTAssertNoThrow(try stepService.addLoot(loot: loot, step: step))
    }
    
    func testDeleteLoot() throws {
        let loot = Loot(id: "1", fish: "Щука", weight: 500, score: 1000)
        let step = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
        
        XCTAssertNoThrow(try stepService.deleteLoot(loot: loot, step: step))
    }
    
    func testGetStepByName() throws {
        let steps = [Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)]
        
        XCTAssertEqual(try stepService.getStepByName(stepName: "Первый день"), steps)
    }
    
    func testGetStepByParticipant() throws {
        let participant = Participant(id: "1", lastName: "a", firstName: "a", patronymic: nil, team: nil, city: "a", birthday: bith, score: 0)
        let steps = [Step(id: "1", name: "Первый день", participant: participant, competition: nil, score: 0)]
        
        XCTAssertEqual(try stepService.getStepByParticipant(participant: participant), steps)
    }
    
    func testGetStepByCompetition() throws {
        let competition = Competition(id: "1", name: "aaa", teams: nil)
        let steps = [Step(id: "1", name: "Первый день", participant: nil, competition: competition, score: 0)]
        
        XCTAssertEqual(try stepService.getStepByCompetition(competition: competition), steps)
    }
    
    func testStepAddParticipant() throws {
        let participant = Participant(id: "1", lastName: "a", firstName: "a", patronymic: nil, team: nil, city: "a", birthday: bith, score: 0)
        let step = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
        
        XCTAssertNoThrow(try stepService.addParticipant(participant: participant, step: step))
    }
}
