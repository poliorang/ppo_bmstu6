//
//  StepRepositoryTest.swift
//  UnitTestAutorization
//
//  Created by poliorang on 09.04.2023.
//

import XCTest
import RealmSwift
@testable import rfpr

fileprivate var stepRepository: StepRepository!
fileprivate var config = "StepRepositoryTest"
fileprivate var beforeTestClass: BeforeStepRepositoryTest!

class StepRepositoryTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        do {
            stepRepository = try StepRepository(configRealm: config)
        } catch {
            print("Не удалось открыть Realm: \(config)")
            exit(-1)
        }
        
        beforeTestClass = BeforeStepRepositoryTest()
        
        do {
            try beforeTestClass.setupRepository(config: config)
            try beforeTestClass.createData()
        } catch {
            print("Не удалось загрузить данные: \(config)")
            exit(-1)
        }
    }

    override class func tearDown() {
        stepRepository = nil
        beforeTestClass = nil
        super.tearDown()
    }

    func testCreateStep() throws {
        let step = Step(id: "6442852b2b74d595cb4f4150", name: "Первый день", participant: nil, competition: nil, score: 0)
        var createdStep: Step?
        
        XCTAssertNoThrow(try createdStep = stepRepository.createStep(step: step))
        XCTAssertEqual(createdStep, step)
    }
//    
//    func testUpdateStep() throws {
//        let previousStep = Step(id: "6442852b2b74d595cb4f4164", name: "Третий день", participant: nil, competition: nil, score: 0)
//        let newStep = Step(id: "6442852b2b74d595cb4f4164", name: "3 день", participant: nil, competition: nil, score: 0)
//        var updatedStep: Step?
//        
//        XCTAssertNoThrow(try updatedStep = stepRepository.updateStep(previousStep: previousStep, newStep: newStep))
//        XCTAssertEqual(updatedStep, newStep)
//    }
    
//    func testUpdateLootNilPrev() throws {
//        let previousStep = Step(id: "6442852b2b74d595cb4f4740", name: "Пятый день", participant: nil, competition: nil, score: 0)
//        let newStep = Step(id: "6442852b2b74d595cb4f4740", name: "Третий день", participant: nil, competition: nil, score: 0)
//        var updatedStep: Step?
//        
//        XCTAssertThrowsError(try updatedStep = stepRepository.updateStep(previousStep: previousStep, newStep: newStep))
//        XCTAssertEqual(updatedStep, nil)
//    }
    
    func testDeleteStep() throws {
        let step = Step(id: "6442852b2b74d595cb4f4768", name: "Пятый день", participant: nil, competition: nil, score: 0)
        
        XCTAssertNoThrow(try stepRepository.deleteStep(step: step))
        XCTAssertEqual(try stepRepository.getStep(id: "6442852b2b74d595cb4f4768"), nil)
    }

    func testDeleteStepNilLoot() throws {
        let step = Step(id: "6442852b2b74d595cb4f4740", name: "FFF", participant: nil, competition: nil, score: 0)
        
        XCTAssertThrowsError(try stepRepository.deleteStep(step: step))
    }
    
    func testAddLoot() throws {
        let loot = Loot(id: "6442852b2b74d595cb4f4784", fish: "Осетр", weight: 350, score: 850)
        let step = Step(id: "6442852b2b74d595cb4f4772", name: "A день", participant: nil, competition: nil, score: 0)
        
        XCTAssertNoThrow(try stepRepository.addLoot(loot: loot, step: step))
    }
    
    func testAddLootNil() throws {
        let loot = Loot(id: "6442852b2b74d595cb4f4784", fish: "Осетр", weight: 350, score: 850)
        let step = Step(id: "6442852b2b74d595cb4f4730", name: "Y день", participant: nil, competition: nil, score: 0)
        
        XCTAssertThrowsError(try stepRepository.addLoot(loot: loot, step: step))
    }
    
    func testDeleteLoot() throws {
        let loot = Loot(id: "6442852b2b74d595cb4f4768", fish: "Щука", weight: 350, score: 850)
        let step = Step(id: "6442852b2b74d595cb4f4780", name: "D день", participant: nil, competition: nil, score: 0)
        
        XCTAssertNoThrow(try stepRepository.deleteLoot(loot: loot, step: step))
    }
    
    func testDeleteLootNil() throws {
        let step = Step(id: "6442852b2b74d595cb4f4710", name: "Y день", participant: nil, competition: nil, score: 0)
        let loot = Loot(id: "6442852b2b74d595cb4f1168", fish: "Щука", weight: 350, step: step, score: 850)
        
        XCTAssertThrowsError(try stepRepository.deleteLoot(loot: loot, step: step))
    }
}
