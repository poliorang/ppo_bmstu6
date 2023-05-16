//
//  AuthorizationExtencion.swift
//  rfpr
//
//  Created by poliorang on 15.05.2023.
//

import RealmSwift

extension Authorization {
    func convertAuthorizationToRealm(_ realm: Realm) throws -> AuthorizationRealm {
        // проверка, что уже есть в бд
        var authorizationFromDB: AuthorizationRealm? = nil
        if let id = self.id {
            let objId = try ObjectId.init(string: id)
            authorizationFromDB = realm.objects(AuthorizationRealm.self).where {
                $0._id == objId
            }.first
        }
        
        if let authorizationFromDB = authorizationFromDB {
            return authorizationFromDB
        }
        
        do {
            return try AuthorizationRealm(id: self.id, login: self.login, password: self.password)
        } catch {
            throw DatabaseError.addError
        }
    }
}
