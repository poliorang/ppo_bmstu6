//
//  ICompetitionRepository.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//


protocol ICompetitionRepository {
    func createCompetition(competition: Competition) throws -> Competition? 
    func deleteCompetition(competition: Competition) throws
    
    func getCompetitions() throws -> [Competition]?
}
