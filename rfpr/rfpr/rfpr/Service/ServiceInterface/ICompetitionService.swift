//
//  ICompetitionService.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//


protocol ICompetitionService {
    func createCompetition(id: String?, name: String?, teams: [Team]?) throws -> Competition
    func deleteCompetition(competition: Competition?) throws
    
    func getCompetitions() throws -> [Competition]? 
    func getCompetition(name: String?) throws -> [Competition]?
    
    func addStep(step: Step?, competition: Competition?) throws
}
