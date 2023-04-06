//
//  CompetitionRepositoryTests.swift
//  UnitTestAutorization
//
//  Created by poliorang on 03.04.2023.
//

import XCTest
@testable import rfpr

class ICompetitionRepositoryTests: XCTestCase {
    
    var competitionRepository: MockCompetitionRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        competitionRepository = MockCompetitionRepository()
    }

    override func tearDownWithError() throws {
        competitionRepository = nil
        try super.tearDownWithError()
    }

    func testCreateCompetition() throws {
        let team1 = Team(id: 1, name: "AAA", participants: nil, competitions: nil, score: 0)
        let team2 = Team(id: 2, name: "BBB", participants: nil, competitions: nil, score: 0)
        
        let competition = Competition(id: 1, name: "Уральский этап", teams: [team1, team2])
        
        XCTAssertEqual(competitionRepository.createCompetition(id: 1, name: "Уральский этап", teams: [team1, team2]), competition)
    }
    
    func testCreateCompetitionNilTeam() throws {
        let competition = Competition(id: 1, name: "Уральский этап", teams: nil)
        
        XCTAssertEqual(competitionRepository.createCompetition(id: 1, name: "Уральский этап", teams: nil), competition)
    }
    
    func testCreateCompetitionNilId() throws {
        XCTAssertNil(competitionRepository.createCompetition(id: nil, name: "Уральский этап", teams: nil))
    }
    
    func testCreateCompetitionNilName() throws {
        XCTAssertNil(competitionRepository.createCompetition(id: 1, name: nil, teams: nil))
    }
    
    func testUpdateCompetition() throws {
        XCTAssertEqual(competitionRepository.updateCompetition(name: "Aaa") as! String, "Data of competitions type was updated")
    }
    
    func testUpdateCompetitionNil() throws {
        XCTAssertNil(competitionRepository.updateCompetition(name: nil))
    }
    
    func testDeleteCompetition() throws {
        XCTAssertEqual(competitionRepository.deleteCompetition(name: "Aaa") as! String, "Data of competitions type was deleted")
    }
    
    func testDeleteCompetitionNil() throws {
        XCTAssertNil(competitionRepository.deleteCompetition(name: nil))
    }
    
    func testAddStep() throws {
        let step = Step(id: 1, name: "1", participant: nil, competition: nil)
        
        let team1 = Team(id: 1, name: "AAA", participants: nil, competitions: nil, score: 0)
        let team2 = Team(id: 2, name: "BBB", participants: nil, competitions: nil, score: 0)
        
        let competition = Competition(id: 1, name: "Уральский этап", teams: [team1, team2])
        
        XCTAssertEqual(competitionRepository.addStep(step: step, competition: competition) as! String, "steps was added to competitions")
    }
    
    func testAddStepNilStep() throws {
        let team1 = Team(id: 1, name: "AAA", participants: nil, competitions: nil, score: 0)
        let team2 = Team(id: 2, name: "BBB", participants: nil, competitions: nil, score: 0)
        
        let competition = Competition(id: 1, name: "Уральский этап", teams: [team1, team2])
        
        XCTAssertNil(competitionRepository.addStep(step: nil, competition: competition))
    }
    
    func testAddStepNilCompetition() throws {
        let step = Step(id: 1, name: "1", participant: nil, competition: nil)
        
        XCTAssertNil(competitionRepository.addStep(step: step, competition: nil))
    }
    
    func testAddTeam() throws {
        let team = Team(id: 3, name: "CCC", participants: nil, competitions: nil, score: 0)
        
        let team1 = Team(id: 1, name: "AAA", participants: nil, competitions: nil, score: 0)
        let team2 = Team(id: 2, name: "BBB", participants: nil, competitions: nil, score: 0)
        let competition = Competition(id: 1, name: "Уральский этап", teams: [team1, team2])
        
        XCTAssertEqual(competitionRepository.addTeam(team: team, competition: competition) as! String, "teams was added to competitions")
    }
    
    func testAddTeamNilTeam() throws {
        let team1 = Team(id: 1, name: "AAA", participants: nil, competitions: nil, score: 0)
        let team2 = Team(id: 2, name: "BBB", participants: nil, competitions: nil, score: 0)
        let competition = Competition(id: 1, name: "Уральский этап", teams: [team1, team2])
        
        XCTAssertNil(competitionRepository.addTeam(team: nil, competition: competition))
    }
    
    func testAddTeamNilCompetition() throws {
        let team = Team(id: 1, name: "AAA", participants: nil, competitions: nil, score: 0)
        
        XCTAssertNil(competitionRepository.addTeam(team: team, competition: nil))
    }
    
    func testGetCompetition() throws {
        let competition = Competition(id: 1, name: "1", teams: nil)
        XCTAssertEqual(competitionRepository.getCompetition(id: 1), competition)
    }
    
    func testGetCompetitionNil() throws {
        XCTAssertNil(competitionRepository.getCompetition(id: 5))
    }
    
    func testGetCompetitionNilId() throws {
        XCTAssertNil(competitionRepository.getCompetition(id: nil))
    }

}
