//
//  IGetDataRepository.swift
//  rfpr
//
//  Created by poliorang on 06.04.2023.
//

protocol IGetDataRepository {
    func stepsWithParticipantIdWithStepName(participant: Participant, stepName: String) -> [Step]?
    func stepsWithParticipantId(participant: Participant) -> [Step]?
    func lootsWithSteptId(step: Step) -> [Loot]?
}
