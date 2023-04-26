//
//  TeamExtension.swift
//  rfpr
//
//  Created by poliorang on 21.04.2023.
//

import RealmSwift

extension Team {
    func convertTeamToRealm() throws -> TeamRealm {
        let competitionsRealm = List<CompetitionRealm>()
        
        if let competitions = self.competitions {
            for competition in competitions {
                try competitionsRealm.append(competition.convertCompetitionToRealm())
            }
        }
    
        return TeamRealm(id: self.id, name: self.name, competitions: competitionsRealm, score: self.score)
    }
}
