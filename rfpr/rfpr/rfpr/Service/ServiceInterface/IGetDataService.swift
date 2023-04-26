//
//  IGetDataService.swift
//  rfpr
//
//  Created by poliorang on 06.04.2023.
//

protocol IGetDataService {
    func getStepsByParticipant(participant: Participant?, stepName: String?) -> [Step]?
    func getLootsByStep(step: Step?) -> [Loot]?
}
