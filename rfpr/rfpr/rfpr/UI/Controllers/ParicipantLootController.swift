//
//  ParicipantLootController.swift
//  rfpr
//
//  Created by poliorang on 10.05.2023.
//

import UIKit

protocol ToLootDelegateProtocol {
    func sendPartToLootViewController(participant: Participant?)
}

protocol ToDetailLootDelegateProtocol {
    func sendCompetitionDetailToLootViewController(competition: Competition?)
    func sendUpdatedLootDetailToLootViewController(loot: Loot?)
}

class ParicipantLootViewController: UIViewController, ToParticipantLootDelegateProtocol, ToParticipantLoot2DelegateProtocol {
    
    typealias TeamTableViewCell = UITableViewCell
    
    var services: ServicesManager! = nil
    let alertManager = AlertManager.shared
    
    var participantDelegatePartLoot: ToLootDelegateProtocol? = nil
    var detailLootDelegate: ToDetailLootDelegateProtocol? = nil
    
    var participant: Participant?       // получить из LootController
    var steps: [Step]?
    var loots: [Loot]?
    var competition: Competition?       // получить из LootController
    
    let headerLabel = UILabel()
    let tableView = UITableView.init(frame: .zero, style: UITableView.Style.grouped)
    let createLootButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground

        guard let _ = participant else {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "Участник не распознан")
            return
        }
        
        setupServices()
        
        getSteps()
        getLoots()
        
        setupTable()
        setupHeaderLabel(headerLabel)
        setupCreateLootButton(createLootButton)
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
    
    func sendPartToPartLootViewController(participant: Participant?) {
        guard let participant = participant else {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "Участник не распознан")
            return
        }

        self.participant = participant
    }
    
    func sendCompetitionToLootViewController(competition: Competition?) {
        guard let competition = competition else {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "Соревнование не распознано")
            return
        }

        self.competition = competition
    }
    
    func setupHeaderLabel(_ label: UILabel) {
        view.addSubview(label)
        label.frame = CGRect(x: 30, y: 95, width: view.frame.width, height: view.frame.height / 6)
        label.text = "\(participant!.lastName) \(participant!.firstName)"
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.sizeToFit()
    }
    
    private func setupTable() {
        view.addSubview(tableView)
        
        tableView.register(TeamTableViewCell.self, forCellReuseIdentifier: "TeamTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.frame = CGRect.init(origin: .zero, size: self.view.frame.size)
    }
    
    func setupCreateLootButton(_ button: UIButton) {
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
        
        createLootButton.addTarget(self, action: #selector(buttonCreateLootTapped(sender:)), for: .touchUpInside)
    }
    
    private func getSteps() {
        do {
            steps = try services.stepService.getStepByParticipant(participant: participant)
            print("STEPS ")
            for step in steps ?? [] {
                print(step.name, " ", step.score)
            }
            if steps == nil || steps!.isEmpty {
                alertManager.showAlert(presentTo: self, title: "Внимание",
                                       message: "У участника нет ни одного зачета")
            }
            
        } catch {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "У участника нет ни одного зачета")
        }
    }
    
    private func getLoots() {
        guard let steps = steps else {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "У участника нет ни одного зачета")
            return
        }

        
        loots = []
        for step in steps {
            do {
                let lootsByStep = try services.lootService.getLootByStep(step: step)
                for loot in lootsByStep ?? [] { loots!.append(loot) }
            } catch {
                alertManager.showAlert(presentTo: self, title: "Внимание",
                                       message: "У зачета нет ни одного улова")
            }
        }
    
        print("LOOTS ", loots)
    }
    
    @objc
    func buttonCreateLootTapped(sender: UIButton) {
       let detailLootController = DetailLootViewController()
            
        // чтобы можно было использовать только методы, определенные протоколе
        participantDelegatePartLoot = detailLootController
        participantDelegatePartLoot?.sendPartToLootViewController(participant: participant)
        
        detailLootDelegate = detailLootController
        detailLootDelegate?.sendCompetitionDetailToLootViewController(competition: competition)
        
        let updateTableCompletion:() -> Void = {
            self.getSteps()
            self.getLoots()
            self.tableView.reloadData()
        }
        
        detailLootController.gettedCompletion = updateTableCompletion
        
        present(detailLootController, animated: true, completion: nil)
    }
}

extension ParicipantLootViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        
        case self.tableView:
            return loots?.count ?? 0
        
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TeamTableViewCell", for: indexPath)

        let loot = self.loots?[indexPath.row]
        guard let loot = loot else {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "Улов не распознан")
            return cell
        }
        
        let resultString = loot.fish + " | " + "\(loot.step?.name ?? "")" + " | " + "очки " + "\(loot.score)"
        
        cell.textLabel?.text = resultString
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {

            let cell = tableView.cellForRow(at: indexPath)!
    
            var loot: Loot?
            do {
                var fishName = cell.textLabel?.text?.components(separatedBy: "|")[0]
                var stepName = cell.textLabel?.text?.components(separatedBy: "|")[1]
                var score = cell.textLabel?.text?.components(separatedBy: "|")[2].components(separatedBy: " ")[2]
                
                if let _ = fishName {
                    fishName = fishName!.removingLeadingSpaces().removingFinalSpaces()
                }
                
                if let _ = stepName {
                    stepName = stepName!.removingLeadingSpaces().removingFinalSpaces()
                }
                
                if let _ = score {
                    score = score!.removingLeadingSpaces().removingFinalSpaces()
                }
                
                for step in steps ?? [] {
                    if step.name == stepName {
                        _ = try services.lootService.getLootByStep(step: step)
                        loot = try services.lootService.getLoot(fishName: fishName, score: Int(score ?? ""))
                        if let _ = loot { break }
                    }
                }
                
                print("LOOT ", loot as Any)
                
                do {
                    try services.lootService.deleteLoot(loot: loot)
                } catch {
                    alertManager.showAlert(presentTo: self, title: "Внимание",
                                           message: "Не удалось удалить улов")
                }
                
            } catch {
                alertManager.showAlert(presentTo: self, title: "Внимание",
                                       message: "Улов не найден")
                return
            }
            
            tableView.beginUpdates()
            loots!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            if loots!.count <= 0 {
                alertManager.showAlert(presentTo: self, title: "Внимание",
                                       message: "Нет ни одного улова")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        
        let loot: Loot?
        
        let fishName = "\(loots?[indexPath.row].fish ?? "")"
        let fishScore = loots?[indexPath.row].score ?? 0
        do {
            try loot = services.lootService.getLoot(fishName: fishName, score: fishScore)
        } catch {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "Улов не найден")
            return
        }
        
        let detailLootController = DetailLootViewController()
             
         // чтобы можно было использовать только методы, определенные протоколе
         participantDelegatePartLoot = detailLootController
         participantDelegatePartLoot?.sendPartToLootViewController(participant: participant)
         
         detailLootDelegate = detailLootController
         detailLootDelegate?.sendCompetitionDetailToLootViewController(competition: competition)
         detailLootDelegate?.sendUpdatedLootDetailToLootViewController(loot: loot)
         
         let updateTableCompletion:() -> Void = {
             self.getSteps()
             self.getLoots()
             self.tableView.reloadData()
         }
         
         detailLootController.gettedCompletion = updateTableCompletion
         
         present(detailLootController, animated: true, completion: nil)
    }
}
