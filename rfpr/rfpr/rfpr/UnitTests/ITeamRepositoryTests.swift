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
        XCTAssertEqual(teamRepository.updateTeam(name: "Aaa") as! String, "Data of teams type was updated")
    }
    
    func testUpdateTeamNil() {
        XCTAssertNil(teamRepository.updateTeam(name: nil))
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
        let team = [Team(id: 1, name: "1", participants: participants, competitions: nil, score: 0)]
        
        XCTAssertEqual(teamRepository.getParticipantByTeam(id: 1), participants)
    }
    
    func testGetParticipantByTeamNil() throws {
        XCTAssertNil(teamRepository.getParticipantByTeam(id: 3))
    }
    
    func testsGetTeamsByAscending() throws {
        let participants = [Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 6600),
                            Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 9800),
                            Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 2650)]
        
            
        
        let teams = [Team(id: 2, name: "Подводный мир", participants: [participants[2], participants[0]], competitions: nil, score: 9250),
                     Team(id: 1, name: "Скумбрия", participants: [participants[1], participants[2]], competitions: nil, score: 12450),
                     Team(id: 0, name: "Батискаф", participants: [participants[0], participants[1]], competitions: nil, score: 16400)]
        
        XCTAssertEqual(teamRepository.getTeams(parameter: SortParameter.ascending, stepName: nil), teams)
    }
    
    func testsGetTeamsByDecreasing() throws {
        let participants = [Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 6600),
                            Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 9800),
                            Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 2650)]
        
            
        
        let teams = [Team(id: 0, name: "Батискаф", participants: [participants[0], participants[1]], competitions: nil, score: 16400),
                     Team(id: 1, name: "Скумбрия", participants: [participants[1], participants[2]], competitions: nil, score: 12450),
                     Team(id: 2, name: "Подводный мир", participants: [participants[2], participants[0]], competitions: nil, score: 9250)]
        
        XCTAssertEqual(teamRepository.getTeams(parameter: SortParameter.decreasing, stepName: nil), teams)
    }
    
    func testsGetTeamsByNil() throws {
        let participants = [Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 0),
                            Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 0),
                            Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 0)]
        
            
        
        let teams = [Team(id: 0, name: "Батискаф", participants: [participants[0], participants[1]], competitions: nil, score: 0),
                     Team(id: 1, name: "Скумбрия", participants: [participants[1], participants[2]], competitions: nil, score: 0),
                     Team(id: 2, name: "Подводный мир", participants: [participants[2], participants[0]], competitions: nil, score: 0)]
        
        XCTAssertEqual(teamRepository.getTeams(parameter: nil, stepName: nil), teams)
    }
    
    func testsGetTeamsByStepByAscending() throws {
        let participants = [Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 5000),
                            Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 8500),
                            Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 450)]
        
            
        
        let teams = [Team(id: 2, name: "Подводный мир", participants: [participants[2], participants[0]], competitions: nil, score: 5450),
                     Team(id: 1, name: "Скумбрия", participants: [participants[1], participants[2]], competitions: nil, score: 8950),
                     Team(id: 0, name: "Батискаф", participants: [participants[0], participants[1]], competitions: nil, score: 13500)]
        
        XCTAssertEqual(teamRepository.getTeams(parameter: SortParameter.ascending, stepName: "1"), teams)
    }
    
    func testsGetTeamsByStepByDecreasing() throws {
        let participants = [Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 1600),
                            Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 1300),
                            Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 2200)]
        
            
        
        let teams = [Team(id: 2, name: "Подводный мир", participants: [participants[2], participants[0]], competitions: nil, score: 3800),
                     Team(id: 1, name: "Скумбрия", participants: [participants[1], participants[2]], competitions: nil, score: 3500),
                     Team(id: 0, name: "Батискаф", participants: [participants[0], participants[1]], competitions: nil, score: 2900)]
                     
        XCTAssertEqual(teamRepository.getTeams(parameter: SortParameter.decreasing, stepName: "2"), teams)
    }
    
    func testsGetTeamsByStepByNil() throws {
        let participants = [Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 0),
                            Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 0),
                            Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 0)]
        
            
        
        let teams = [Team(id: 0, name: "Батискаф", participants: [participants[0], participants[1]], competitions: nil, score: 0),
                     Team(id: 1, name: "Скумбрия", participants: [participants[1], participants[2]], competitions: nil, score: 0),
                     Team(id: 2, name: "Подводный мир", participants: [participants[2], participants[0]], competitions: nil, score: 0)]
        
        XCTAssertEqual(teamRepository.getTeams(parameter: nil, stepName: "1"), teams)
    }
}
