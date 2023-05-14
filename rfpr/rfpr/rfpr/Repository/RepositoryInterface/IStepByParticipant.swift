//
//  IStepByParticipant.swift
//  rfpr
//
//  Created by poliorang on 10.05.2023.
//


protocol IStepByParticipantRepository {
    func getStepByParticipant(participant: Participant) throws -> [Step]? 
}
