//
//  LootController.swift
//  rfpr
//
//  Created by poliorang on 10.05.2023.
//

import UIKit

protocol ToParticipantLootDelegateProtocol {
    func sendPartToPartLootViewController(participant: Participant?)
}

protocol ToParticipantLoot2DelegateProtocol {
    func sendCompetitionToLootViewController(competition: Competition?)
}

class LootViewController: UIViewController, ToLootFromSetupDelegateProtocol {
    
    typealias TeamTableViewCell = UITableViewCell
    
    var services: ServicesManager! = nil
    let alertManager = AlertManager.shared
    
    var participantDelegatePartLoot: ToParticipantLootDelegateProtocol? = nil
    var participantLoot2Delegate: ToParticipantLoot2DelegateProtocol? = nil
    
    let tableView = UITableView.init(frame: .zero, style: UITableView.Style.grouped)
    let searchBar = UISearchBar()
    let competitionButton = UIButton()
    let picker = UIPickerView()
    let pickerToolBar = UIToolbar()
    let setupButton = UIButton()
    
    var participants: [Participant]?
    var competitions: [Competition]?
    var competition: Competition?
    
    var sortParameter = SortParameter.decreasing
    var stepName: StepsName? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        setupServices()
        getCompetitions()
        competition = competitions?[0]
        
        getParticipants()
        getScoreByCompetitionByStep()
        setupTable()
        setupSearchBar(searchBar)
        setupCompetitionButton(competitionButton)
        setupSetupButton(setupButton)
        
        setupPicker(picker)
        setupPickerToolBar(pickerToolBar)
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Улов | \(competition?.name ?? "")"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getParticipants()
        getCompetitions()
        getScoreByCompetitionByStep()
        
        self.tableView.reloadData()
    }
    
    func sendSortParamsToLootViewController(stepName: StepsName?, sortParameter: SortParameter) {
        self.stepName = stepName
        self.sortParameter = sortParameter
    }

    private func setupServices() {
        do {
            try services = ServicesManager()
        } catch {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Не удалось получить доступ к базе данных")
        }
    }
    
    private func setupTable() {
        view.addSubview(tableView)
        
        tableView.register(TeamTableViewCell.self, forCellReuseIdentifier: "TeamTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        let yOffset = 190.0
        self.tableView.frame = CGRect.init(x: view.frame.origin.x, y: view.frame.origin.y + yOffset,
                                            width: view.frame.size.width, height: view.frame.size.height)
    }
    
    private func getCompetitions() {
        do {
            try competitions = services.competitionService.getCompetitions() ?? []
        } catch {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "В базе данных нет ни одного соревнования")
        }
    }
    
    private func getParticipants() {
        do {
            let teams = try services.teamService.getTeamsByCompetition(competitionName: competition?.name)
            participants = []
            for team in teams ?? [] {
                let participantsByTeam = try services.participantService.getParticipantByTeam(team: team)
                participants?.append(contentsOf: participantsByTeam ?? [])
            }
        } catch {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Ошибка базы данных")
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
    }
    
    func setupCompetitionButton(_ button: UIButton) {
        self.view.addSubview(button)
        
        button.tintColor = .label
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Соревнование", for: .normal)
        button.layer.cornerRadius = 10
        button.alpha = 0.5
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 135),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        competitionButton.addTarget(self, action: #selector(buttonCompetitionTapped(sender:)), for: .touchUpInside)
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
    
    private func setupSearchBar(_ searchBar: UISearchBar) {
        self.view.addSubview(searchBar)
        searchBar.placeholder = "ФИО участника"
        
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.backgroundColor = .systemGroupedBackground
        
        searchBar.sizeToFit()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.autocorrectionType = UITextAutocorrectionType.no
        searchBar.keyboardType = UIKeyboardType.default
        searchBar.returnKeyType = UIReturnKeyType.search
        searchBar.enablesReturnKeyAutomatically = false
        
        searchBar.delegate = self
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 144),
            searchBar.heightAnchor.constraint(equalToConstant: 45),
            searchBar.widthAnchor.constraint(equalToConstant: view.frame.width - 50),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }
    
    private func setupPicker(_ picker: UIPickerView) {
        self.view.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        picker.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            picker.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            picker.widthAnchor.constraint(equalToConstant: view.frame.width),
            picker.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        picker.delegate = self
        picker.dataSource = self
        
        picker.isHidden = true
    }
    
    private func setupPickerToolBar(_ toolBar: UIToolbar) {
        self.view.addSubview(toolBar)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        toolBar.backgroundColor = .white
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        NSLayoutConstraint.activate([
            toolBar.bottomAnchor.constraint(equalTo: picker.topAnchor),
            toolBar.widthAnchor.constraint(equalToConstant: view.frame.width),
            toolBar.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        toolBar.setItems([doneButton], animated: false)
        
        toolBar.isHidden = true
    }
    
    @objc
    func buttonCompetitionTapped(sender: UIButton) {
        getCompetitions()

        if picker.isHidden {
            picker.isHidden = false
            pickerToolBar.isHidden = false
        }
    }
    
    @objc
    func donePicker() {
        getParticipants()
        getScoreByCompetitionByStep()
        self.tableView.reloadData()
        
        if picker.isHidden == false {
            picker.isHidden = true
            pickerToolBar.isHidden = true
        }
    }
    
    @objc
    func buttonSetupTapped(sender: UIButton) {
        let setupSortingViewController = SetupSortingViewController()
        
        let updateTableCompletion:() -> Void = {
            self.getScoreByCompetitionByStep()
            self.tableView.reloadData()
        }
        
        setupSortingViewController.gettedCompletion = updateTableCompletion
        setupSortingViewController.lootViewController = self
        
        present(setupSortingViewController, animated: true, completion: nil)
    }
}

extension LootViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            return self.participants?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TeamTableViewCell", for: indexPath)
        
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


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let participant: Participant?
        
        let fullname = "\(participants?[indexPath.row].lastName ?? "") \(participants?[indexPath.row].firstName ?? "")"
        do {
            try participant = services.participantService.getParticipant(fullname: fullname)?.first
        } catch {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "Участник не найден")
            return
        }
        
        
        let paricipantLootViewController = ParicipantLootViewController()
        
        // чтобы можно было использовать только методы, определенные протоколе
        participantDelegatePartLoot = paricipantLootViewController
        participantDelegatePartLoot?.sendPartToPartLootViewController(participant: participant)
        
        participantLoot2Delegate = paricipantLootViewController
        participantLoot2Delegate?.sendCompetitionToLootViewController(competition: competition)
        
        navigationController?.pushViewController(paricipantLootViewController, animated: true)
    }
    
}


extension LootViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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

extension LootViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return competitions?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return competitions?[row].name ?? ""
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        competition = competitions?[row]
        self.navigationItem.title = "Улов | \(competition?.name ?? "")"
    }
}
