//
//  TeamExtension.swift
//  rfpr
//
//  Created by poliorang on 21.04.2023.
//

import RealmSwift

extension Team {
    func convertTeamToRealm(_ realm: Realm) throws -> TeamRealm {
        // проверка, что уже есть в бд
        var teamFromDB: TeamRealm? = nil
        if let id = self.id {
            let objId = try ObjectId.init(string: id)
            teamFromDB = realm.objects(TeamRealm.self).where {
                $0._id == objId
            }.first
        }
        
        if let teamFromDB = teamFromDB {
            return teamFromDB
        }
        
        let competitionsRealm = List<CompetitionRealm>()
        
        if let competitions = self.competitions {
            for competition in competitions {
                try competitionsRealm.append(competition.convertCompetitionToRealm(realm))
            }
        }
    
        return TeamRealm(id: self.id, name: self.name, competitions: competitionsRealm, score: self.score)
    }
}
