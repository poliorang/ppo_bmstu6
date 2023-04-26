//
//  IStepService.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//

protocol IStepService {
    func createStep(id: String?, name: String?, participant: Participant?, competition: Competition?) throws -> Step
    
    func updateStep(previousStep: Step?, newStep: Step?) throws -> Step
    func deleteStep(step: Step?) throws
}
