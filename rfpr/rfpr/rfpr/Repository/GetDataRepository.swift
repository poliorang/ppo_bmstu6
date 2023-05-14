//
//  GetDataRepository.swift
//  rfpr
//
//  Created by poliorang on 01.05.2023.
//

import Foundation
import RealmSwift

class GetDataRepository: IGetDataRepository {
   
    let realm: Realm!
    var config: Realm.Configuration!
    init(configRealm: String) throws {
        do {
            config = Realm.Configuration.defaultConfiguration
            config.fileURL!.deleteLastPathComponent()
            config.fileURL!.appendPathComponent("\(configRealm).realm")
            
            self.realm = try Realm(configuration: config)
        } catch {
            throw ConnectionError.realmConnectError
        }
    }
    
    func realmDeleteAll() throws {
        do {
            try realm.write {
              realm.deleteAll()
            }
        } catch {
            throw DatabaseError.deleteAllError
        }
    }
    
    func stepsWithParticipantIdWithStepName(participant: Participant, stepName: String) -> [Step]? {
        return nil
    }
    
    func stepsWithParticipantId(participant: Participant) -> [Step]? {
        return nil
    }
    
    func lootsWithSteptId(step: Step) -> [Loot]? {
        return nil
    }

}
