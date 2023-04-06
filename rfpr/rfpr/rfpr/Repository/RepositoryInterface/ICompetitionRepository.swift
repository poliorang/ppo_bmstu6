//
//  ICompetitionRepository.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//


protocol ICompetitionRepository {
    func createCompetition(id: Int?, name: String?, teams: [Team]?) -> Competition?
    
    func getCompetition(id: Int?) -> Competition?
    func updateCompetition(name: String?) -> Any?
    func deleteCompetition(name: String?) -> Any?
}
