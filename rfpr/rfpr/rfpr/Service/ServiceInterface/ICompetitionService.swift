//
//  ICompetitionService.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//


protocol ICompetitionService {
    func createCompetition(id: String?, name: String?, teams: [Team]?) throws -> Competition
    
    func updateCompetition(previousCompetition: Competition?, newCompetition: Competition?) throws -> Competition
    func deleteCompetition(competition: Competition?) throws
    
    func getCompetition(name: String?) throws -> [Competition]?
    func getCompetitions() throws -> [Competition]?
    
    func addTeam(team: Team?, competition: Competition?) throws
    func addStep(step: Step?, competition: Competition?) throws 
}
