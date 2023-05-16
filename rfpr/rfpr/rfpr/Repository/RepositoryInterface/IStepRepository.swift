//
//  IStepRepository.swift
//  rfpr
//
//  Created by poliorang on 31.03.2023.
//

protocol IStepRepository {
    func createStep(step: Step) throws -> Step?
    func deleteStep(step: Step) throws
    
    func getSteps() throws -> [Step]?
    
    func addParticipant(participant: Participant, step: Step) throws
    
    func getStepByCompetition(competition: Competition) throws -> [Step]? 
}
