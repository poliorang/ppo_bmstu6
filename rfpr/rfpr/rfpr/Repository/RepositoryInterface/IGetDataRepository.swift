//
//  IGetDataRepository.swift
//  rfpr
//
//  Created by poliorang on 06.04.2023.
//

protocol IGetDataRepository {
    func stepsWithParticipantIdWithStepName(id: Int, stepName: String) -> [Step]?
    func stepsWithParticipantId(id: Int) -> [Step]?
    func lootsWithSteptId(id: Int) -> [Loot]?
}
