//
//  DataError.swift
//  rfpr
//
//  Created by poliorang on 13.04.2023.
//

enum DatabaseError: Error {
    case openError
    case addError
    case updateError
    case deleteError
    case getError
    case deleteAllError
    case triggerError
}
