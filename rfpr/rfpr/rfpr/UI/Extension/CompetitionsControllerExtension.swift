//
//  CompetitionsControllerExtension.swift
//  rfpr
//
//  Created by poliorang on 01.05.2023.
//

import UIKit



extension CompetitionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            return self.competitions.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CompetitionTableViewCell", for: indexPath)
        cell.textLabel?.text = self.competitions[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {

            let cell = tableView.cellForRow(at: indexPath)!
            var competition: Competition?
            do {
                competition = try services.competitionService.getCompetition(name: cell.textLabel?.text)?.first
            } catch {
                alertManager.showAlert(presentTo: self,
                                       title: "Внимание",
                                       message: "Не найдено соревнование")
                return
            }
            
            do {
                try services.competitionService.deleteCompetition(competition: competition)
            } catch {
                alertManager.showAlert(presentTo: self,
                                       title: "Внимание",
                                       message: "Не удалось удалить соревнование")
            }
            
            tableView.beginUpdates()
            competitions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            if competitions.count <= 0 {
                alertManager.showAlert(presentTo: self,
                                       title: "Внимание",
                                       message: "Не создано ни одно соревнование")
            }
        }
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: indexPath!)!
        
        let teamViewController = TeamViewController()
        // чтобы можно было использовать только методы, определенные протоколе
        competitionDelegate = teamViewController
        
        do {
            let competition = try services.competitionService.getCompetition(name: cell.textLabel?.text)?.first
            competitionDelegate?.sendCompetitionToTeamViewController(competition: competition)
            print("COMPETITION ", competition!)
        } catch {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Не найдено соревнование")
            return
        }
        
        
        // это когда не вышло получить соревнование
        guard let _ = self.competitionDelegate else {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Ошибка делегата")
            return
        }
        
        navigationController?.pushViewController(teamViewController, animated: true)
    }
    
}


