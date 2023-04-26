//
//  IStepToCompetitionRepository.swift
//  rfpr
//
//  Created by poliorang on 02.04.2023.
//

protocol IStepToCompetitionRepository {
    func addStep(step: Step, competition: Competition) throws
}
