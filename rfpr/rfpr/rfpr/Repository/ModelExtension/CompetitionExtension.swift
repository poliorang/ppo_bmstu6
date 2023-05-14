//
//  CompetitionExtension.swift
//  rfpr
//
//  Created by poliorang on 21.04.2023.
//

import RealmSwift

extension Competition {
    func convertCompetitionToRealm(_ realm: Realm) throws -> CompetitionRealm {
        // проверка, что уже есть в бд
        var competitionFromDB: CompetitionRealm? = nil
        if let id = self.id {
            let objId = try ObjectId.init(string: id)
            competitionFromDB = realm.objects(CompetitionRealm.self).where {
                $0._id == objId
            }.first
        }
        
        if let competitionFromDB = competitionFromDB {
            return competitionFromDB
        }
        
        let teamsRealm = List<TeamRealm>()
        if let teams = self.teams {
            for team in teams {
                do {
                    try teamsRealm.append(team.convertTeamToRealm(realm))
                } catch {
                    throw DatabaseError.addError
                }
            }
        }
    
        return CompetitionRealm(id: self.id, name: self.name, teams: teamsRealm)
    }
}
