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
        let participants = [Participant(id: 1, fullname: "Ivan", city: "Moscow", role: "Refeere", autorization: nil, score: 0)]
        let competitions = [Competition(id: 1, name: "Урал", teams: nil)]
        let team = Team(id: 1, name: "AAA", participants: participants, competitions: competitions, score: 0)
        
        XCTAssertEqual(teamRepository.createTeam(id: 1, name: "AAA", participants: participants, competitions: competitions, score: 0), team)
    }
    
    func testCreateTeamNilParticipants() throws {
        let competitions = [Competition(id: 1, name: "Урал", teams: nil)]
        let team = Team(id: 1, name: "AAA", participants: nil, competitions: competitions, score: 0)
        
        XCTAssertEqual(teamRepository.createTeam(id: 1, name: "AAA", participants: nil, competitions: competitions, score: 0), team)
    }
    
    func testCreateTeamNilCompetition() throws {
        let participants = [Participant(id: 1, fullname: "Ivan", city: "Moscow", role: "Refeere", autorization: nil, score: 0)]
        let team = Team(id: 1, name: "AAA", participants: participants, competitions: nil, score: 0)
        
        XCTAssertEqual(teamRepository.createTeam(id: 1, name: "AAA", participants: participants, competitions: nil, score: 0), team)
    }
    
    func testUpdateTeam() {
        let team = Team(id: 1, name: "1", participants: nil, competitions: nil, score: 0)
        XCTAssertEqual(teamRepository.updateTeam(name: "Aaa", team: team) as! String, "Data of teams type was updated")
    }
    
    func testUpdateTeamNil() {
        let team = Team(id: 1, name: "1", participants: nil, competitions: nil, score: 0)
        XCTAssertNil(teamRepository.updateTeam(name: nil, team: team))
    }
    
    func testDeleteTeam() {
        XCTAssertEqual(teamRepository.deleteTeam(name: "Aaa") as! String, "Data of teams type was deleted")
    }
    
    func testDeleteTeamNil() {
        XCTAssertNil(teamRepository.deleteTeam(name: nil))
    }
    
    func testGetTeam() throws {
        let team = Team(id: 1, name: "1", participants: nil, competitions: nil, score: 0)
        XCTAssertEqual(teamRepository.getTeam(name: "1"), team)
    }
    
    func testGetTeamNil() throws {
        XCTAssertNil(teamRepository.getTeam(name: nil))
    }
    
    func testGetTeamNilId() throws {
        XCTAssertNil(teamRepository.getTeam(name: "aaa"))
    }
    
    func testAddCompetition() throws {
        let team = Team(id: 3, name: "CCC", participants: nil, competitions: nil, score: 0)
        
        let team1 = Team(id: 1, name: "AAA", participants: nil, competitions: nil, score: 0)
        let team2 = Team(id: 2, name: "BBB", participants: nil, competitions: nil, score: 0)
        let competition = Competition(id: 1, name: "Уральский этап", teams: [team1, team2])
        
        XCTAssertEqual(teamRepository.addCompetition(competition: competition, team: team) as! String, "competitions was added to teams")
    }
    
    func testAddCompetitionNilTeam() throws {
        let team1 = Team(id: 1, name: "AAA", participants: nil, competitions: nil, score: 0)
        let team2 = Team(id: 2, name: "BBB", participants: nil, competitions: nil, score: 0)
        let competition = Competition(id: 1, name: "Уральский этап", teams: [team1, team2])
        
        XCTAssertNil(teamRepository.addCompetition(competition: competition, team: nil))
    }
    
    func testAddCompetitionNilCompetitions() throws {
        let team = Team(id: 3, name: "CCC", participants: nil, competitions: nil, score: 0)
        
        XCTAssertNil(teamRepository.addCompetition(competition: nil, team: team))
    }
        
    func testAddParticipant() throws {
        let participant = Participant(id: 1, fullname: "1", city: "Moscow", birthday: nil, role: "Participant", autorization: nil, score: 0)
        let team = Team(id: 1, name: "AAA", participants: nil, competitions: nil, score: 0)
        
        XCTAssertEqual(teamRepository.addParticipant(participant: participant, team: team) as! String, "participants was added to teams")
    }
    
    func testAddParticipantNilParticipant() throws {
        let team = Team(id: 1, name: "AAA", participants: nil, competitions: nil, score: 0)
        
        XCTAssertNil(teamRepository.addParticipant(participant: nil, team: team))
    }
    
    func testAddParticipantNilTeam() throws {
        let participant = Participant(id: 1, fullname: "1", city: "Moscow", birthday: nil, role: "Participant", autorization: nil, score: 0)
        XCTAssertNil(teamRepository.addParticipant(participant: participant, team: nil))
    }
    
    func testGetParticipantByTeam() throws {
        let participants = [Participant(id: 1, fullname: "Иванов", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 0)]

        XCTAssertEqual(teamRepository.getParticipantByTeam(id: 1), participants)
    }
    
    func testGetParticipantByTeamNil() throws {
        XCTAssertNil(teamRepository.getParticipantByTeam(id: 3))
    }

}
