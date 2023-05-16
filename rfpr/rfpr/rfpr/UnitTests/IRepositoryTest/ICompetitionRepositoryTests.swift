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
        let team1 = Team(id: "1", name: "AAA", competitions: nil, score: 0)
        let team2 = Team(id: "2", name: "BBB", competitions: nil, score: 0)
        
        let competition = Competition(id: "1", name: "Урал", teams: [team1, team2])
        
        XCTAssertNoThrow(try competitionRepository.createCompetition(competition: competition))
    }
    
    func testCreateCompetitionNilTeam() throws {
        let competition = Competition(id: "1", name: "Урал", teams: nil)
        
        XCTAssertNoThrow(try competitionRepository.createCompetition(competition: competition))
    }
    
    func testDeleteCompetition() throws {
        let competition = Competition(id: "1", name: "Урал", teams: nil)
        
        XCTAssertNoThrow(try competitionRepository.deleteCompetition(competition: competition))
    }
    
    func testDeleteCompetitionNil() throws {
        let competition = Competition(id: "1", name: "Атлантика", teams: nil)
        
        XCTAssertThrowsError(try competitionRepository.deleteCompetition(competition: competition))
    }
    
    func testGetCompetition() throws {
        let competition1 = Competition(id: "1", name: "Урал", teams: nil)
        let competition2 = Competition(id: "1", name: "Урал-Юг", teams: nil)
        let competition3 = Competition(id: "1", name: "Байкал", teams: nil)
        
        let competitions = [competition1, competition2, competition3]
        
        XCTAssertEqual(try competitionRepository.getCompetitions(), competitions)
    }
    
    func testAddStep() throws {
        let competition = Competition(id: "1", name: "Урал", teams: nil)
        let step = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
        
        XCTAssertNoThrow(try competitionRepository.addStep(step: step, competition: competition))
    }
    
    func testAddStepNilCompetition() throws {
        let competition = Competition(id: "1", name: "", teams: nil)
        let step = Step(id: "1", name: "Первый день", participant: nil, competition: nil, score: 0)
        
        XCTAssertThrowsError(try competitionRepository.addStep(step: step, competition: competition))
    }
    
    func testAddStepNilStep() throws {
        let competition = Competition(id: "1", name: "Урал", teams: nil)
        let step = Step(id: "1", name: "", participant: nil, competition: nil, score: 0)

        XCTAssertThrowsError(try competitionRepository.addStep(step: step, competition: competition))
    }

}
