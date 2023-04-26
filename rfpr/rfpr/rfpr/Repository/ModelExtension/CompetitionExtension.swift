//
//  CompetitionExtension.swift
//  rfpr
//
//  Created by poliorang on 21.04.2023.
//

import RealmSwift

extension Competition {
    func convertCompetitionToRealm() throws -> CompetitionRealm {
        let teamsRealm = List<TeamRealm>()
        if let teams = self.teams {
            for team in teams {
                do {
                    try teamsRealm.append(team.convertTeamToRealm())
                } catch {
                    throw DatabaseError.addError
                }
            }
        }
    
        return CompetitionRealm(id: self.id, name: self.name, teams: teamsRealm)
    }
}
