//
//  CompetitionServiceTests.swift
//  UnitTestAutorization
//
//  Created by poliorang on 04.04.2023.
//

import XCTest
@testable import rfpr

class CompetitionServiceTests: XCTestCase {

    var competitionService: ICompetitionService!
    var competitionRepository: ICompetitionRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        competitionRepository = MockCompetitionRepository()
        competitionService = CompetitionService(competitionRepository: competitionRepository, stepToCompetitionRepository: competitionRepository as! IStepToCompetitionRepository as! IStepToCompetitionRepository)
    }

    override func tearDownWithError() throws {
        competitionService = nil
        competitionRepository = nil
        try super.tearDownWithError()
    }
    
    func testCreateCompetition() throws {
        let team1 = Team(id: "1", name: "AAA", competitions: nil, score: 0)
        let team2 = Team(id: "2", name: "BBB", competitions: nil, score: 0)
        XCTAssertNoThrow(try competitionService.createCompetition(id: "1", name: "Урал", teams: [team1, team2]))
    }
    
    func testCreateCompetitionNilTeam() throws {
        XCTAssertNoThrow(try competitionService.createCompetition(id: "1", name: "Урал", teams: nil))
    }
    
    func testCreateCompetitionNilName() throws {
        XCTAssertThrowsError(try competitionService.createCompetition(id: "1", name: nil, teams: nil))
    }
    
    func testDeleteCompetition() throws {
        let competition = Competition(id: "1", name: "Урал", teams: nil)
        
        XCTAssertNoThrow(try competitionService.deleteCompetition(competition: competition))
    }
    
    func testDeleteCompetitionNil() throws {
        let competition = Competition(id: "1", name: "Урал", teams: nil)
        
        XCTAssertNoThrow(try competitionService.deleteCompetition(competition: competition))
    }
    
    func testDeleteCompetitionNoComapetition() throws {
        let competition = Competition(id: "1", name: "Akjdcnsj", teams: nil)
        
        XCTAssertThrowsError(try competitionService.deleteCompetition(competition: competition))
    }
    
    func testDeleteCompetitionNilCompetition() throws {
        XCTAssertThrowsError(try competitionService.deleteCompetition(competition: nil))
    }
    
    func testGetCompetitionMany() throws {
        let competitions = [Competition(id: "1", name: "Урал", teams: nil),
                            Competition(id: "1", name: "Урал-Юг", teams: nil)]
        
        XCTAssertEqual(try competitionService.getCompetition(name: "Урал"), competitions)
    }
    
    func testGetCompetitionOne() throws {
        let competitions = [Competition(id: "1", name: "Урал-Юг", teams: nil)]
        
        XCTAssertEqual(try competitionService.getCompetition(name: "Юг"), competitions)
    }
    
    func testGetCompetitionNoName() throws {
        XCTAssertEqual(try competitionService.getCompetition(name: "aaksjnckdacb"), nil)
    }
    
    func testGetCompetitionNilName() throws {
        XCTAssertThrowsError(try competitionService.getCompetition(name: nil))
    }
    
    func testAddStep() throws {
        let competition = Competition(id: "1", name: "Урал", teams: nil)
        let step = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
        
        XCTAssertNoThrow(try competitionService.addStep(step: step, competition: competition))
    }
    
    func testAddStepNilCompetition() throws {
        let competition = Competition(id: "1", name: "", teams: nil)
        let step = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
        
        XCTAssertThrowsError(try competitionService.addStep(step: step, competition: competition))
    }
    
    func testAddStepNilStep() throws {
        let competition = Competition(id: "1", name: "Урал", teams: nil)
        let step = Step(id: "1", name: "", participant: nil, competition: nil, score: 0)

        XCTAssertThrowsError(try competitionService.addStep(step: step, competition: competition))
    }
}
