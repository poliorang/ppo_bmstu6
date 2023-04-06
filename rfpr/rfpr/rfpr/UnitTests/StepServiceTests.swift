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
        XCTAssertNoThrow(stepService.updateStep(id: 1))
    }
    
    func testUpdateStepNil() throws {
        XCTAssertNoThrow(stepService.updateStep(id: nil))
    }
    
    func testDeleteStep() throws {
        XCTAssertNoThrow(stepService.deleteStep(id: 1))
    }
    
    func testDeleteStepNil() throws {
        XCTAssertNoThrow(stepService.deleteStep(id: nil))
    }

}
