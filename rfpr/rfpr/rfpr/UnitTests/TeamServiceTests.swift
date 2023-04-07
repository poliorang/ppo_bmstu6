//
//  TeamServiceTests.swift
//  UnitTestAutorization
//
//  Created by poliorang on 04.04.2023.
//

import XCTest
@testable import rfpr

class TeamServiceTests: XCTestCase {

    var teamService: ITeamService!
    var teamRepository: ITeamRepository!
    var getDataRepository: IGetDataRepository!
    var getDataService: IGetDataService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        teamRepository = MockTeamRepository()
        getDataRepository = MockGetDataRepository()
        getDataService = GetDataService(getDataRepository: getDataRepository)
        teamService = TeamService(teamRepository: teamRepository, getDataService: getDataService)
    }

    override func tearDownWithError() throws {
        teamService = nil
        teamRepository = nil
        try super.tearDownWithError()
    }
    
    func testCreateTeam() throws {
        let participants = [Participant(id: 1, fullname: "Ivan", city: "Moscow", role: "Refeere", autorization: nil, score: 0)]
        let competitions = [Competition(id: 1, name: "Урал", teams: nil)]
        let team = Team(id: 1, name: "AAA", participants: participants, competitions: competitions, score: 0)
        
        XCTAssertEqual(teamService.createTeam(id: 1, name: "AAA", participants: participants, competitions: competitions, score: 0), team)
    }
    
    func testCreateTeamNilParticipants() throws {
        let competitions = [Competition(id: 1, name: "Урал", teams: nil)]
        let team = Team(id: 1, name: "AAA", participants: nil, competitions: competitions, score: 0)
        
        XCTAssertEqual(teamService.createTeam(id: 1, name: "AAA", participants: nil, competitions: competitions, score: 0), team)
    }
    
    func testCreateTeamNilCompetition() throws {
        let participants = [Participant(id: 1, fullname: "Ivan", city: "Moscow", role: "Refeere", autorization: nil, score: 0)]
        let team = Team(id: 1, name: "AAA", participants: participants, competitions: nil, score: 0)
        
        XCTAssertEqual(teamService.createTeam(id: 1, name: "AAA", participants: participants, competitions: nil, score: 0), team)
    }
    
    func testUpdateTeam() {
        let team = Team(id: 1, name: "1", participants: nil, competitions: nil, score: 0)
        XCTAssertNoThrow(teamService.updateTeam(name: "Aaa", team: team))
    }
    
    func testUpdateTeamNil() {
        let team = Team(id: 1, name: "1", participants: nil, competitions: nil, score: 0)
        XCTAssertNoThrow(teamService.updateTeam(name: nil, team: team))
    }
    
    func testDeleteTeam() {
        XCTAssertNoThrow(teamService.deleteTeam(name: "Aaa"))
    }
    
    func testDeleteTeamNil() {
        XCTAssertNoThrow(teamService.deleteTeam(name: nil))
    }
    
    func testGetTeam() throws {
        let team = Team(id: 1, name: "1", participants: nil, competitions: nil, score: 0)
        XCTAssertEqual(teamService.getTeam(name: "1"), team)
    }
    
    func testGetTeamNil() throws {
        XCTAssertNil(teamService.getTeam(name: nil))
    }
    
    func testGetTeamNilId() throws {
        XCTAssertNil(teamService.getTeam(name: "aaa"))
    }
    
    func testsGetTeamsByAscending() throws {
        let participants = [Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 6600),
                            Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 9800),
                            Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 2650)]
        
            
        
        let teams = [Team(id: 2, name: "Подводный мир", participants: [participants[2], participants[0]], competitions: nil, score: 9250),
                     Team(id: 1, name: "Скумбрия", participants: [participants[1], participants[2]], competitions: nil, score: 12450),
                     Team(id: 0, name: "Батискаф", participants: [participants[0], participants[1]], competitions: nil, score: 16400)]
        
        XCTAssertEqual(teamService.getTeams(parameter: SortParameter.ascending, stepName: nil), teams)
    }

    func testsGetTeamsByDecreasing() throws {
        let participants = [Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 6600),
                            Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 9800),
                            Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 2650)]
        
            
        
        let teams = [Team(id: 0, name: "Батискаф", participants: [participants[0], participants[1]], competitions: nil, score: 16400),
                     Team(id: 1, name: "Скумбрия", participants: [participants[1], participants[2]], competitions: nil, score: 12450),
                     Team(id: 2, name: "Подводный мир", participants: [participants[2], participants[0]], competitions: nil, score: 9250)]
        
        XCTAssertEqual(teamService.getTeams(parameter: SortParameter.decreasing, stepName: nil), teams)
    }

    func testsGetTeamsByNil() throws {
        let participants = [Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 0),
                            Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 0),
                            Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 0)]
        
            
        
        let teams = [Team(id: 0, name: "Батискаф", participants: [participants[0], participants[1]], competitions: nil, score: 0),
                     Team(id: 1, name: "Скумбрия", participants: [participants[1], participants[2]], competitions: nil, score: 0),
                     Team(id: 2, name: "Подводный мир", participants: [participants[2], participants[0]], competitions: nil, score: 0)]
        
        XCTAssertEqual(teamService.getTeams(parameter: nil, stepName: nil), teams)
    }

    func testsGetTeamsByStepByAscending() throws {
        let participants = [Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 5000),
                            Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 8500),
                            Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 450)]
        
            
        
        let teams = [Team(id: 2, name: "Подводный мир", participants: [participants[2], participants[0]], competitions: nil, score: 5450),
                     Team(id: 1, name: "Скумбрия", participants: [participants[1], participants[2]], competitions: nil, score: 8950),
                     Team(id: 0, name: "Батискаф", participants: [participants[0], participants[1]], competitions: nil, score: 13500)]
        
        XCTAssertEqual(teamService.getTeams(parameter: SortParameter.ascending, stepName: "1"), teams)
    }

    func testsGetTeamsByStepByDecreasing() throws {
        let participants = [Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 1600),
                            Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 1300),
                            Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 2200)]
        
            
        
        let teams = [Team(id: 2, name: "Подводный мир", participants: [participants[2], participants[0]], competitions: nil, score: 3800),
                     Team(id: 1, name: "Скумбрия", participants: [participants[1], participants[2]], competitions: nil, score: 3500),
                     Team(id: 0, name: "Батискаф", participants: [participants[0], participants[1]], competitions: nil, score: 2900)]
                     
        XCTAssertEqual(teamService.getTeams(parameter: SortParameter.decreasing, stepName: "2"), teams)
    }

    func testsGetTeamsByStepByNil() throws {
        let participants = [Participant(id: 0, fullname: "Иванов", city: "Ижевск", birthday: nil, role: "Участник", autorization: nil, score: 0),
                            Participant(id: 1, fullname: "Петров", city: "Москва", birthday: nil, role: "Участник", autorization: nil, score: 0),
                            Participant(id: 2, fullname: "Сидоров", city: "Челябинск", birthday: nil, role: "Участник", autorization: nil, score: 0)]
        
            
        
        let teams = [Team(id: 0, name: "Батискаф", participants: [participants[0], participants[1]], competitions: nil, score: 0),
                     Team(id: 1, name: "Скумбрия", participants: [participants[1], participants[2]], competitions: nil, score: 0),
                     Team(id: 2, name: "Подводный мир", participants: [participants[2], participants[0]], competitions: nil, score: 0)]
        
        XCTAssertEqual(teamService.getTeams(parameter: nil, stepName: "1"), teams)

    }
}
