//
//  TeamController.swift
//  rfpr
//
//  Created by poliorang on 06.05.2023.
//

import Foundation
import UIKit

protocol ToDetailTeamDelegateProtocol {
    func sendCompetitionToTeamViewController(competition: Competition?)
}

protocol ToDetailParticipantDelegateProtocol {
    func sendCompetitionToParticipantViewController(competition: Competition?)
}

protocol ToDetailParticipantUpdateDelegateProtocol {
    func sendParticipantToParticipantViewController(participant: Participant?)
}

protocol ToDetailTeamtUpdateDelegateProtocol {
    func sendTeamToTeamViewController(team: Team?)
}

class TeamViewController: UIViewController, CompetitionToTeamDelegateProtocol {
    typealias TeamTableViewCell = UITableViewCell
    
    var competitionDelegateTeam: ToDetailTeamDelegateProtocol? = nil
    var competitionDelegateParticipant: ToDetailParticipantDelegateProtocol? = nil
    var participantDelegateParticipant: ToDetailParticipantUpdateDelegateProtocol? = nil
    var teamDelegateTeam: ToDetailTeamtUpdateDelegateProtocol? = nil
    
    var services: ServicesManager! = nil
    let alertManager = AlertManager.shared
    
    var competition: Competition?   // получается из CompetitionController
    var teams: [Team]?              // получается из CompetitionController
    var participants: [Participant]?
    
    var sortParameter = SortParameter.decreasing
    var stepName: StepsName? = nil
    
    let searchBar = UISearchBar()
    let tableView = UITableView.init(frame: .zero, style: UITableView.Style.grouped)
    let headerLabel = UILabel()
    var teamsOrParticipantsButton: UIBarButtonItem? = nil
    let sortButton = UIButton()
    let createTeamButton = UIButton()
    
    let setupButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        guard let _ = competition else {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Соревнование не распознано")
            return
        }
        
        setupServices()
        getTeamsByCompetition()
        getParticipants()
        getScoreByCompetitionByStep()
        
        setupTable()
        setupHeaderLabel(headerLabel)
    
        setupTeamsOrParticipantsBarButton()
        setupCreateTeamsButton(createTeamButton)
        setupSetupButton(setupButton)
        
        setupSearchBar(searchBar)
    }

    
    // делегат
    func sendCompetitionToTeamViewController(competition: Competition?) {
        guard let competition = competition else {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Соревнование не распознано")
            return
        }

        self.competition = competition
        self.teams = competition.teams
    }
    
    
    
    func getParticipants() {
        do {
            participants = [Participant]()
            if let teams = teams {
                for team in teams {
                    let cur = try services.participantService.getParticipantByTeam(team: team)
                    cur?.forEach({
                        participants?.append($0)
                    })
                }
            }
            
        } catch {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Ошибка базы данных")
        }
    }
    
    func getTeamsByCompetition() {
        do {
            teams = try services.teamService.getTeamsByCompetition(competitionName: competition?.name)
        } catch {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Ошибка базы данных")
        }
    }
    
    func setupServices() {
        do {
            try services = ServicesManager()
        } catch {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Не удалось получить доступ к базе данных")
        }
    }
    
    private func getScoreByCompetitionByStep() {
        do {
            participants = try services.participantService.getParticipantsScoreByCompetition(participants: participants, competition: competition, stepName: stepName, parameter: sortParameter)
        } catch {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Не удалось получить данные об участниках")
        }
        
        do {
            teams = try services.teamService.getTeamsScoreByCompetition(teams: teams, competition: competition, stepName: stepName, parameter: sortParameter)
        } catch {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Не удалось получить данные о командах")
        }
    }
    
    
    func setupHeaderLabel(_ label: UILabel) {
        view.addSubview(label)
        label.frame = CGRect(x: 30, y: 95, width: view.frame.width, height: view.frame.height / 6)
        label.text = competition!.name
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.sizeToFit()
    }
    
    func setupTeamsOrParticipantsBarButton() {
        self.teamsOrParticipantsButton = UIBarButtonItem(title: tableMode.teams.rawValue, style: UIBarButtonItem.Style.done,
                                                    target: self, action: #selector(teamsOrParticipantsPressed(_:)))
        self.navigationItem.rightBarButtonItem = teamsOrParticipantsButton
    }
    
    func setupCreateTeamsButton(_ button: UIButton) {
        self.view.addSubview(button)
        
        button.tintColor = .label
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+", for: .normal)
        button.layer.cornerRadius = 10
        button.alpha = 0.5
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 110),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        createTeamButton.addTarget(self, action: #selector(buttonCreateTeamTapped(sender:)), for: .touchUpInside)
    }
    
    private func setupSearchBar(_ searchBar: UISearchBar) {
        self.view.addSubview(searchBar)
        if teamsOrParticipantsButton?.title == tableMode.teams.rawValue {
            searchBar.placeholder = "Название команды"
        }
        if teamsOrParticipantsButton?.title == tableMode.participants.rawValue {
            searchBar.placeholder = "Имя участника"
        }
        
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.backgroundColor = .systemBackground
        
        searchBar.sizeToFit()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.autocorrectionType = UITextAutocorrectionType.no
        searchBar.keyboardType = UIKeyboardType.default
        searchBar.returnKeyType = UIReturnKeyType.search
        searchBar.enablesReturnKeyAutomatically = false
        
        searchBar.delegate = self
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            searchBar.heightAnchor.constraint(equalToConstant: 45),
            searchBar.widthAnchor.constraint(equalToConstant: view.frame.width - 50),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }
    
    func setupSetupButton(_ button: UIButton) {
        self.view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 144),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 50),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -9)
        ])
        
        button.addTarget(self, action: #selector(buttonSetupTapped(sender:)), for: .touchUpInside)
    }
    
    private func setupTable() {
        view.addSubview(tableView)
        
        tableView.register(TeamTableViewCell.self, forCellReuseIdentifier: "TeamTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = UIColor.systemBackground
        
//        NSLayoutConstraint.activate([
//            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
//            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130)
//        ])
//        self.tableView.frame = CGRect.init(origin: .zero, size: self.view.frame.size)
        let yOffset = 190.0
        self.tableView.frame = CGRect.init(x: view.frame.origin.x, y: view.frame.origin.y + yOffset,
                                            width: view.frame.size.width, height: view.frame.size.height)
    }
    
    @objc
    func buttonCreateTeamTapped(sender: UIButton) {
        if teamsOrParticipantsButton?.title == tableMode.teams.rawValue {
            let detailTeamController = DetailTeamViewController()
            
            // чтобы можно было использовать только методы, определенные протоколе
            competitionDelegateTeam = detailTeamController
            competitionDelegateTeam?.sendCompetitionToTeamViewController(competition: competition)
            
            // чтобы обновлять в динамике таблицу
            // (после нажатия на кнопку создания нового соревнования в другом контроллере
            // таблица обновится в этом)
            let updateTableCompletion:() -> Void = {
                self.getTeamsByCompetition()
                self.tableView.reloadData()
            }
            
            detailTeamController.gettedCompletion = updateTableCompletion
            present(detailTeamController, animated: true, completion: nil)
        }
       
        if teamsOrParticipantsButton?.title == tableMode.participants.rawValue {
            let detailParticipantController = DetailParticipantViewController()
            
            // чтобы можно было использовать только методы, определенные протоколе
            competitionDelegateParticipant = detailParticipantController
            competitionDelegateParticipant?.sendCompetitionToParticipantViewController(competition: competition)
            
            let updateTableCompletion:() -> Void = {
                self.getParticipants()
                self.tableView.reloadData()
            }
            
            detailParticipantController.gettedCompletion = updateTableCompletion
            present(detailParticipantController, animated: true, completion: nil)
        }
    }
    
    @objc
    func teamsOrParticipantsPressed(_ sender: UIBarButtonItem ) {
        switch sender.title {
        
        case tableMode.participants.rawValue:
            sender.title = tableMode.teams.rawValue
            searchBar.placeholder = "Название команды"
            getTeamsByCompetition()
            self.tableView.reloadData()
        
        case tableMode.teams.rawValue:
            sender.title = tableMode.participants.rawValue
            searchBar.placeholder = "Имя участника"
            getParticipants()
            self.tableView.reloadData()
        
        default:
            return
        }
    }
    
    @objc
    func buttonSetupTapped(sender: UIButton) {
        let setupSortingViewController = SetupSortingViewController()
        
        let updateTableCompletion:() -> Void = {
            self.getTeamsByCompetition()
            self.getParticipants()
            self.getScoreByCompetitionByStep()
            self.tableView.reloadData()
            
            print("S ", self.sortParameter, self.stepName)
        }
        
        setupSortingViewController.gettedCompletion = updateTableCompletion
        setupSortingViewController.teamViewController = self
        
        present(setupSortingViewController, animated: true, completion: nil)
    }
}

extension TeamViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            if teamsOrParticipantsButton?.title == tableMode.teams.rawValue {
                guard let teams = self.teams else {
                    alertManager.showAlert(presentTo: self, title: "Внимание",
                                           message: "Нет ни одной команды")
                    return 0
                }
                
                return teams.count
            }
            
            
            guard let participants = self.participants else {
                alertManager.showAlert(presentTo: self, title: "Внимание",
                                       message: "Нет ни одного участника")
                return 0
            }
            
            return participants.count
            
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TeamTableViewCell", for: indexPath)

//        getTeamsByCompetition()
//        getParticipants()
        
        if teamsOrParticipantsButton?.title == tableMode.teams.rawValue {
            let team = self.teams?[indexPath.row]
            guard let team = team else {
                alertManager.showAlert(presentTo: self, title: "Внимание",
                                       message: "Команда не распознана")
                return cell
            }
            
            let resultString = team.name + "  |  " + "рейтинг " + "\(team.score)"
            
            cell.textLabel?.text = resultString
            return cell
        }
        
        let participant = self.participants?[indexPath.row]
        guard let participant = participant else {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "Участник не распознан")
            return cell
        }
        
        let resultString = participant.lastName + " " + participant.firstName + "  |  " + "рейтинг " + "\(participant.score)"
        
        cell.textLabel?.text = resultString
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {

            let cell = tableView.cellForRow(at: indexPath)!
            getTeamsByCompetition()
            getParticipants()
            
            if teamsOrParticipantsButton?.title == tableMode.teams.rawValue {
                
                var team: Team?
                do {
                    var name = cell.textLabel?.text?.components(separatedBy: "|").first
                    if let _ = name {
                        name = name!.removingLeadingSpaces().removingFinalSpaces()
                    }

                    team = try services.teamService.getTeam(name: name)?.first
                } catch {
                    alertManager.showAlert(presentTo: self, title: "Внимание",
                                           message: "Команды не найдена")
                    return
                }
                
                do {
                    try services.teamService.deleteTeam(team: team)
                } catch {
                    alertManager.showAlert(presentTo: self, title: "Внимание",
                                           message: "Не удалось удалить команду")
                }
                
                tableView.beginUpdates()
                teams!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
                
                if teams!.count <= 0 {
                    alertManager.showAlert(presentTo: self, title: "Внимание",
                                           message: "Нет ни одной команды")
                }
                
                return
            }
            
            
            var participant: Participant?
            do {
                var fullname = cell.textLabel?.text?.components(separatedBy: "|").first
                if let _ = fullname {
                    fullname = fullname!.removingLeadingSpaces().removingFinalSpaces()
                }

                participant = try services.participantService.getParticipant(fullname: fullname)?.first
            } catch {
                alertManager.showAlert(presentTo: self, title: "Внимание",
                                       message: "Участник не найден")
                return
            }
            
            do {
                try services.participantService.deleteParticipant(participant: participant)
            } catch {
                alertManager.showAlert(presentTo: self, title: "Внимание",
                                       message: "Не удалось удалить участника")
            }
            
            tableView.beginUpdates()
            participants!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            if participants!.count <= 0 {
                alertManager.showAlert(presentTo: self, title: "Внимание",
                                       message: "Нет ни одного участника")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        
        if teamsOrParticipantsButton?.title == tableMode.participants.rawValue {
            let participant: Participant?
            
            let fullname = "\(participants?[indexPath.row].lastName ?? "") \(participants?[indexPath.row].firstName ?? "")"
            do {
                try participant = services.participantService.getParticipant(fullname: fullname)?.first
            } catch {
                alertManager.showAlert(presentTo: self, title: "Внимание",
                                       message: "Участник не найден")
                return 
            }
            
            
            let detailParticipantController = DetailParticipantViewController()
            
            // чтобы можно было использовать только методы, определенные протоколе
            competitionDelegateParticipant = detailParticipantController
            competitionDelegateParticipant?.sendCompetitionToParticipantViewController(competition: competition)
            
            participantDelegateParticipant = detailParticipantController
            participantDelegateParticipant?.sendParticipantToParticipantViewController(participant: participant)
            
            let updateTableCompletion:() -> Void = {
                self.getParticipants()
                self.tableView.reloadData()
            }
            
            detailParticipantController.gettedCompletion = updateTableCompletion
            present(detailParticipantController, animated: true, completion: nil)
        }
        
        if teamsOrParticipantsButton?.title == tableMode.teams.rawValue {
            let team: Team?
            
            let teamName = teams?[indexPath.row].name
            do {
                try team = services.teamService.getTeam(name: teamName)?.first
            } catch {
                alertManager.showAlert(presentTo: self, title: "Внимание",
                                       message: "Команда не найдена")
                return
            }
            
            
            let detailTeamController = DetailTeamViewController()
            
            // чтобы можно было использовать только методы, определенные протоколе
            competitionDelegateTeam = detailTeamController
            competitionDelegateTeam?.sendCompetitionToTeamViewController(competition: competition)
            
            teamDelegateTeam = detailTeamController
            teamDelegateTeam?.sendTeamToTeamViewController(team: team)
            
            let updateTableCompletion:() -> Void = {
                self.getTeamsByCompetition()
                self.tableView.reloadData()
            }
            
            detailTeamController.gettedCompletion = updateTableCompletion
            present(detailTeamController, animated: true, completion: nil)
        }
    }
}



extension TeamViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if teamsOrParticipantsButton?.title == tableMode.teams.rawValue {
            if searchText == "" {
                getTeamsByCompetition()
            } else {
                
                do {
                    let teamBySearchBar = try services.teamService.getTeam(name: searchText)
                    let teamsByCompetitions = try services.teamService.getTeamsByCompetition(competitionName: competition?.name)
                    self.teams = Array(Set(teamBySearchBar ?? []).intersection(Set(teamsByCompetitions ?? [])))
                } catch {
                    alertManager.showAlert(presentTo: self,
                                           title: "Внимание",
                                           message: "Не найдена ни одна команда")
                }
            }
            
            self.tableView.reloadData()
            return
        }
        
        if searchText == "" {
            getParticipants()
        } else {
            do {
                let participantsBySearchBar = try services.participantService.getParticipant(fullname: searchText)
                getParticipants()
                self.participants = Array(Set(participantsBySearchBar ?? []).intersection(Set(participants ?? [])))
            } catch {
                alertManager.showAlert(presentTo: self,
                                       title: "Внимание",
                                       message: "Не найден ни один участник")
            }
        }
        
        self.tableView.reloadData()
        return
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if teamsOrParticipantsButton?.title == tableMode.teams.rawValue {
            if searchBar.text == "" {
                getTeamsByCompetition()
            } else {
                do {
                    let teamBySearchBar = try services.teamService.getTeam(name: searchBar.text)
                    let teamsByCompetitions = try services.teamService.getTeamsByCompetition(competitionName: competition?.name)
                    self.teams = Array(Set(teamBySearchBar ?? []).intersection(Set(teamsByCompetitions ?? [])))
                } catch {
                    alertManager.showAlert(presentTo: self,
                                           title: "Внимание",
                                           message: "Не найдена ни одна команда")
                }
            }
            self.tableView.reloadData()
            return
        }
        
        if searchBar.text == "" {
            getParticipants()
        } else {
            do {
                let participantsBySearchBar = try services.participantService.getParticipant(fullname: searchBar.text)
                getParticipants()
                self.participants = Array(Set(participantsBySearchBar ?? []).intersection(Set(participants ?? [])))
            } catch {
                alertManager.showAlert(presentTo: self,
                                       title: "Внимание",
                                       message: "Не найден ни один участник")
            }
        }
        
        self.tableView.reloadData()
        return
    }
}
