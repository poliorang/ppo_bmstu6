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
        competitionService = CompetitionService(competitionRepository: competitionRepository)
    }

    override func tearDownWithError() throws {
        competitionService = nil
        competitionRepository = nil
        try super.tearDownWithError()
    }
    
    func testCreateCompetition() throws {
        let team1 = Team(id: 1, name: "AAA", participants: nil, competitions: nil, score: 0)
        let team2 = Team(id: 2, name: "BBB", participants: nil, competitions: nil, score: 0)
        
        let competition = Competition(id: 1, name: "Уральский этап", teams: [team1, team2])
        
        XCTAssertEqual(competitionService.createCompetition(id: 1, name: "Уральский этап", teams: [team1, team2]), competition)
    }
    
    func testCreateCompetitionNilTeam() throws {
        let competition = Competition(id: 1, name: "Уральский этап", teams: nil)
        
        XCTAssertEqual(competitionService.createCompetition(id: 1, name: "Уральский этап", teams: nil), competition)
    }
    
    func testCreateCompetitionNilId() throws {
        XCTAssertNil(competitionService.createCompetition(id: nil, name: "Уральский этап", teams: nil))
    }
    
    func testCreateCompetitionNilName() throws {
        XCTAssertNil(competitionService.createCompetition(id: 1, name: nil, teams: nil))
    }
    
    func testUpdateCompetition() throws {
        XCTAssertNoThrow(competitionService.updateCompetition(name: "Aaa"))
    }
    
    func testUpdateCompetitionNil() throws {
        XCTAssertNoThrow(competitionService.updateCompetition(name: nil))
    }
    
    func testDeleteCompetition() throws {
        XCTAssertNoThrow(competitionService.deleteCompetition(name: "Aaa"))
    }
    
    func testDeleteCompetitionNil() throws {
        XCTAssertNoThrow(competitionService.deleteCompetition(name: nil))
    }
    
    func testGetCompetition() throws {
        let competition = Competition(id: 1, name: "1", teams: nil)
        XCTAssertEqual(competitionService.getCompetition(id: 1), competition)
    }
    
    func testGetCompetitionNil() throws {
        XCTAssertNil(competitionService.getCompetition(id: 5))
    }
    
    func testGetCompetitionNilId() throws {
        XCTAssertNil(competitionService.getCompetition(id: nil))
    }

}
