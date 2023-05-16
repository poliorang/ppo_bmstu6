//
//  ITeamRepositoryTests.swift
//  UnitTestAutorization
//
//  Created by poliorang on 04.04.2023.
//

import XCTest
@testable import rfpr

class ITeamRepositoryTests: XCTestCase {
    
    var teamRepository: MockTeamRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        teamRepository = MockTeamRepository()
    }

    override func tearDownWithError() throws {
        teamRepository = nil
        try super.tearDownWithError()
    }

    func testCreateTeam() throws {
        let team = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        XCTAssertNoThrow(try teamRepository.createTeam(team: team))
    }
    
    func testUpdateTeam() {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 0)
        
        XCTAssertNoThrow(try teamRepository.updateTeam(previousTeam: team1, newTeam: team2))
    }
    
    func testDeleteTeam() {
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        
        XCTAssertNoThrow(try teamRepository.deleteTeam(team: team1))
    }
    
    func testGetTeams() throws {
        let competition = Competition(id: "1", name: "Байкал", teams: nil)
        let team1 = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let team2 = Team(id: "1", name: "Барракуда", competitions: nil, score: 0)
        let team3 = Team(id: "1", name: "Пелагик", competitions: [competition], score: 0)
        
        XCTAssertEqual(Set(try (teamRepository.getTeams() ?? [])), Set([team1, team2, team3]))
    }
    
    func testAddCompetition() throws {
        let team = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let competition = Competition(id: "1", name: "Байкал", teams: nil)
        
        XCTAssertNoThrow(try teamRepository.addCompetition(team: team, competition: competition))
    }
    
    func testAddCompetitionNilTeam() throws {
        let team = Team(id: "1", name: "", competitions: nil, score: 0)
        let competition = Competition(id: "1", name: "Байкал", teams: nil)
        
        XCTAssertThrowsError(try teamRepository.addCompetition(team: team, competition: competition))
    }
    
    func testAddCompetitionNilCompetition() throws {
        let team = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let competition = Competition(id: "1", name: "", teams: nil)
        
        XCTAssertThrowsError(try teamRepository.addCompetition(team: team, competition: competition))
    }
    
    func testAddParticipant() throws {
        let team = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Сергей", patronymic: "Сергеевич", team: nil, city: "Москва", birthday: bith, score: 0)
        
        XCTAssertNoThrow(try teamRepository.addParticipant(participant: participant, team: team))
    }
    
    func testAddParticipantNilTeam() throws {
        let team = Team(id: "1", name: "", competitions: nil, score: 0)
        let participant = Participant(id: "1", lastName: "Иванов", firstName: "Сергей", patronymic: "Сергеевич", team: nil, city: "Москва", birthday: bith, score: 0)
        
        XCTAssertThrowsError(try teamRepository.addParticipant(participant: participant, team: team))
    }
    
    func testAddParticipantNilParticipant() throws {
        let team = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let participant = Participant(id: "1", lastName: "", firstName: "Сергей", patronymic: "Сергеевич", team: nil, city: "Москва", birthday: bith, score: 0)
        
        XCTAssertNoThrow(try teamRepository.addParticipant(participant: participant, team: team))
    }
    
    func testGetTeamByParticipant() throws {
        let team = Team(id: "1", name: "Батискаф", competitions: nil, score: 0)
        let participant = Participant(id: "1", lastName: "", firstName: "Сергей", patronymic: "Сергеевич", team: team, city: "Москва", birthday: bith, score: 0)
        
        XCTAssertEqual(try teamRepository.getTeamByParticipant(participant: participant), team)
    }
    
    func testGetTeamByParticipantNil() throws {
        let participant = Participant(id: "1", lastName: "", firstName: "Сергей", patronymic: "Сергеевич", team: nil, city: "Москва", birthday: bith, score: 0)
        
        XCTAssertEqual(try teamRepository.getTeamByParticipant(participant: participant), nil)
    }
}
