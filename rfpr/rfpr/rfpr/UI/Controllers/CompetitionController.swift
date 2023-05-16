//
//  ViewController.swift
//  rfpr
//
//  Created by poliorang on 28.03.2023.
//

import UIKit
import RealmSwift

protocol CompetitionToTeamDelegateProtocol {
    func sendCompetitionToTeamViewController(competition: Competition?)
}

class CompetitionViewController: UIViewController {
    typealias CompetitionTableViewCell = UITableViewCell
    
    var competitionDelegate: CompetitionToTeamDelegateProtocol? = nil
    
    var services: ServicesManager! = nil
    let alertManager = AlertManager.shared
    let authorizationManager = AuthorizationManager.shared
    
    var setupViews: CompetitionViews! = nil
    var competitions = [Competition]()
    
    let tableView = UITableView.init(frame: .zero, style: UITableView.Style.grouped)
    let addCompetitionButton = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Соревнования"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        setupServices()
        getCompetitions()
        
        setupViews = CompetitionViews(view: self.view)

        setupTable()
        setupViews.setupAddCompetitionButton(addCompetitionButton)

        addCompetitionButton.addTarget(self, action: #selector(buttonAddCompetitionTapped(sender:)), for: .touchUpInside)
        
        let authorizationViewController = AuthorizationViewController()
        present(authorizationViewController, animated: true, completion: nil)
    }
    
    private func setupTable() {
        view.addSubview(tableView)
        
        tableView.register(CompetitionTableViewCell.self, forCellReuseIdentifier: "CompetitionTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.frame = CGRect.init(origin: .zero, size: self.view.frame.size)
        
    }
    
    func setupServices() {
        do {
            try services = ServicesManager()
        } catch {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "Не удалось получить доступ к базе данных")
        }
    }
    
    private func getCompetitions() {
        do {
            try competitions = services.competitionService.getCompetitions() ?? []
        } catch {
            alertManager.showAlert(presentTo: self, title: "Внимание",
                                   message: "В базе данных нет ни одного соревнования")
        }
    }

    
    @objc
    func buttonAddCompetitionTapped(sender: UIButton) {
        if !authorizationManager.getRight() {
            alertManager.showAlert(presentTo: self, title: "Доступ запрещен",
                                   message: "Создавать соревнования может только судья")
            return
        }
        
        let updateTableCompletion:() -> Void = { 
            self.getCompetitions()
            self.tableView.reloadData()
        }
        
        let addCompetitionController = AddCompetitionController()
        addCompetitionController.gettedCompletion = updateTableCompletion
        present(addCompetitionController, animated: true, completion: nil)
    }

}


