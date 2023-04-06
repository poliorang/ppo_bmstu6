//
//  IStepRepository.swift
//  rfpr
//
//  Created by poliorang on 31.03.2023.
//

protocol IStepRepository {
    func createStep(id: Int?, name: String?, participant: Participant?, competition: Competition?) -> Step?
    
    func updateStep(id: Int?) -> Any?
    func deleteStep(id: Int?) -> Any?
}
