//
//  ICompetitionService.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//


protocol ICompetitionService {
    func createCompetition(id: Int?, name: String?, teams: [Team]?) -> Competition?
    
    func updateCompetition(name: String?, competition: Competition?)
    func deleteCompetition(name: String?)
    
    func getCompetition(id: Int?) -> Competition?
}
