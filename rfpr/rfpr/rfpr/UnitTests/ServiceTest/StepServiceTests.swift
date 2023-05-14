
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
    
    func testUpdateStep() throws {
        let previousStep = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
        let newStep = Step(id: "1", name: "2", participant: nil, competition: nil, score: 0)
        
        XCTAssertNoThrow(try stepService.updateStep(previousStep: previousStep, newStep: newStep))
    }
    
    func testUpdateStepNilPrev() throws {
        let newStep = Step(id: "1", name: "2", participant: nil, competition: nil, score: 0)
        
        XCTAssertThrowsError(try stepService.updateStep(previousStep: nil, newStep: newStep))
    }
    
    func testUpdateStepNilNew() throws {
        let previousStep = Step(id: "1", name: "2", participant: nil, competition: nil, score: 0)
        
        XCTAssertThrowsError(try stepService.updateStep(previousStep: previousStep, newStep: nil))
    }
    
    func testUpdateStepNil() throws {
        XCTAssertThrowsError(try stepService.updateStep(previousStep: nil, newStep: nil))
    }
    
    func testUpdateStepNoPrev() throws {
        let previousStep = Step(id: "1", name: "aaa", participant: nil, competition: nil, score: 0)
        let newStep = Step(id: "1", name: "2", participant: nil, competition: nil, score: 0)
        
        XCTAssertThrowsError(try stepService.updateStep(previousStep: previousStep, newStep: newStep))
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
}
