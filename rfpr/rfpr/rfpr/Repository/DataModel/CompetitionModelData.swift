//
//  CompetitionModelData.swift
//  rfpr
//
//  Created by poliorang on 08.04.2023.
//

import RealmSwift

class CompetitionRealm: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var teams: List<TeamRealm>
    
    convenience init(id: String?, name: String, teams: List<TeamRealm>) {
        self.init()
        
        self._id = ObjectId.generate()
        if let id = id { self._id = try! ObjectId.init(string: id) }
        self.name = name
        self.teams = teams 
    }
}


extension CompetitionRealm {
    func convertCompetitionFromRealm() -> Competition {
        if teams.isEmpty { return Competition(id: "\(self._id)", name: name, teams: nil) }
        
        var teams = [Team]()
        for team in self.teams {
            teams.append(team.convertTeamFromRealm())
        }
    
        return Competition(id: "\(self._id)", name: name, teams: teams)
    }
}


extension CompetitionRealm {
    static func compareCompetitionsRealm(listRealm1: List<CompetitionRealm>, listRealm2: List<CompetitionRealm>) -> Bool {
        if listRealm1.count != listRealm2.count { return false }
        
        var set1 = Set<Competition>()
        var set2 = Set<Competition>()
        
        for i in 0..<listRealm1.count {
            set1.insert(listRealm1[i].convertCompetitionFromRealm())
            set2.insert(listRealm2[i].convertCompetitionFromRealm())
        }
        
        return set1 == set2 ? true : false
    }
}

