//
//  UserRepository.swift
//  rfpr
//
//  Created by poliorang on 15.05.2023.
//

import Foundation
import RealmSwift

class UserRepository: IUserRepository {
    
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
    
    func createUser(user: User) throws -> User? {
        let realmUser: UserRealm
        
        // может быть только 1 участник без авторизации, чтобы не плодить
        let realmUsers = try getUsers()
        if user.role == .participant {
            for user in realmUsers ?? [] {
                if user.role == .participant {
                    return user
                }
            }
        }
        
        do {
            realmUser = try user.convertUserToRealm(realm)
        } catch {
            throw DatabaseError.addError
        }
        
        do {
            try realm.write {
                realm.add(realmUser)
            }
        } catch {
            throw DatabaseError.addError
        }
        
        let createdUser = try getUser(id: "\(realmUser._id)")
     
        return createdUser
    }
    
    func getUser(id: String) throws -> User? {
        let id = try ObjectId.init(string: id)
    
        let findedUser = realm.objects(UserRealm.self).where {
            $0._id == id
        }.first

        if let findedUser = findedUser {
            return findedUser.convertUserFromRealm()
        }
        
        return nil
    }
    
    func updateUser(previousUser: User, newUser: User) throws -> User? {
        var newUser = newUser
        newUser.id = previousUser.id
        
        let realmPreviousUser = try previousUser.convertUserToRealm(realm)
        let realmNewUser = try newUser.convertUserToRealm(realm)
        
        let userFromDB = realm.objects(UserRealm.self).where {
            $0._id == realmPreviousUser._id
        }.first
        
        guard let _ = userFromDB else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try realm.write {
                realm.add(realmNewUser, update: .modified)
            }
        } catch {
            throw DatabaseError.updateError
        }
        
        let updatedUser = try getUser(id: "\(realmNewUser._id)")

        return updatedUser
    }
    
    func deleteUser(user: User) throws {
        let realmUser = try user.convertUserToRealm(realm)
        
        let userFromDB = realm.objects(UserRealm.self).where {
            $0._id == realmUser._id
        }.first
        
        guard let userFromDB = userFromDB else {
            throw ParameterError.funcParameterError
        }
        
        do {
            try realm.write {
                realm.delete(userFromDB)
            }
        } catch {
            throw DatabaseError.updateError
        }
    }
    
    func getUsers() throws -> [User]? {
        let realmUser = realm.objects(UserRealm.self)
        var users = [User]()
        
        for user in realmUser {
            users.append(user.convertUserFromRealm())
        }

        return users.isEmpty ? nil : users
    }
    
    func getUserByAuthorization(authorization: Authorization) throws -> User? {
        let users = try getUsers()
        
        for user in users ?? [] {
            if user.authorization?.login == authorization.login && user.authorization?.password == authorization.password {
                return user
            }
        }
        
        return nil
    }
}
