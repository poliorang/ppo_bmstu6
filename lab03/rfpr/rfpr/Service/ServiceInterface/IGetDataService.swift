//
//  IGetDataService.swift
//  rfpr
//
//  Created by poliorang on 06.04.2023.
//

protocol IGetDataService {
    func getStepsByParticipant(id: Int?, stepName: String?) -> [Step]?
    func getLootsByStep(id: Int?) -> [Loot]?
}
