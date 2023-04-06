//
//  IStepService.swift
//  rfpr
//
//  Created by poliorang on 29.03.2023.
//

protocol IStepService {
    func createStep(id: Int?, name: String?, participant: Participant?, competition: Competition?) -> Step?
    
    func updateStep(id: Int?)
    func deleteStep(id: Int?) 
}
