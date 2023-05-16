//
//  AuthorizationRepository.swift
//  rfpr
//
//  Created by poliorang on 15.05.2023.
//

import Foundation
import RealmSwift

class AuthorizationRepository: IAuthorizationRepository {
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
    
    func createAuthorization(authorization: Authorization) throws -> Authorization? {
        let realmAuthorization: AuthorizationRealm
        
        do {
            realmAuthorization = try authorization.convertAuthorizationToRealm(realm)
        } catch {
            throw DatabaseError.addError
        }
        
        do {
            try realm.write {
                realm.add(realmAuthorization)
            }
        } catch {
            throw DatabaseError.addError
        }
        
        let createdAuthorization = try getAuthorizationByLoginPassword(authorization: authorization)
     
        return createdAuthorization
    }
    
    func updateAuthorization(previousAuthorization: Authorization, newAuthorization: Authorization) throws -> Authorization? {
        var newAuthorization = newAuthorization
        newAuthorization.id = previousAuthorization.id
        
        let realmPreviousAuthorization = try previousAuthorization.convertAuthorizationToRealm(realm)
        let realmNewAuthorization = try newAuthorization.convertAuthorizationToRealm(realm)
        
        let authorizationFromDB = realm.objects(AuthorizationRealm.self).where {
            $0._id == realmPreviousAuthorization._id
        }.first
        
        guard let _ = authorizationFromDB else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try realm.write {
                realm.add(realmNewAuthorization, update: .modified)
            }
        } catch {
            throw DatabaseError.updateError
        }
        
        let updatedAuthorization = try getAuthorizationByLoginPassword(authorization: newAuthorization)

        return updatedAuthorization
    }
    
    func deleteAuthorization(authorization: Authorization) throws {
        let realmAuthorization = try authorization.convertAuthorizationToRealm(realm)
        
        let authorizationFromDB = realm.objects(AuthorizationRealm.self).where {
            $0._id == realmAuthorization._id
        }.first
        
        guard let authorizationFromDB = authorizationFromDB else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try realm.write {
                realm.delete(authorizationFromDB)
            }
        } catch {
            throw DatabaseError.updateError
        }
    }
    
    func getAuthorizationByLoginPassword(authorization findAuthorization: Authorization) throws -> Authorization? {
        let authorizations = try getAuthorizations()
        
        for authorization in authorizations ?? [] {
            if authorization.password == findAuthorization.password &&
                authorization.login == findAuthorization.login {
                return authorization
            }
        }
        
        return nil
    }
    
    func getAuthorizations() throws -> [Authorization]? {
        let realmAuthorization = realm.objects(AuthorizationRealm.self)
        var authorizations = [Authorization]()
        
        for authorization in realmAuthorization {
            authorizations.append(authorization.convertAuthorizationFromRealm())
        }

        return authorizations.isEmpty ? nil : authorizations
    }
}
