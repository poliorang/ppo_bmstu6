//
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
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        stepRepository = MockStepRepository()
        stepService = StepService(stepRepository: stepRepository)
    }

    override func tearDownWithError() throws {
        stepService = nil
        stepRepository = nil
        try super.tearDownWithError()
    }
    
    func testCreateStep() throws {
        let step = Step(id: 1, name: "1", participant: nil, competition: nil)
        XCTAssertEqual(stepService.createStep(id: 1, name: "1", participant: nil, competition: nil), step)
    }
    
    func testCreateStepNil() throws {
        XCTAssertNil(stepService.createStep(id: 1, name: nil, participant: nil, competition: nil))
    }
    
    func testUpdateStep() throws {
        let step = Step(id: 1, name: "1", participant: nil, competition: nil)
        XCTAssertNoThrow(stepService.updateStep(id: 1, step: step))
    }
    
    func testUpdateStepNil() throws {
        let step = Step(id: 1, name: "1", participant: nil, competition: nil)
        XCTAssertNoThrow(stepService.updateStep(id: nil, step: step))
    }
    
    func testDeleteStep() throws {
        XCTAssertNoThrow(stepService.deleteStep(id: 1))
    }
    
    func testDeleteStepNil() throws {
        XCTAssertNoThrow(stepService.deleteStep(id: nil))
    }

}
