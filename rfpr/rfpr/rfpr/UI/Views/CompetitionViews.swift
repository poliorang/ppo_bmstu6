//
//  CompetitionViewa.swift
//  rfpr
//
//  Created by poliorang on 02.05.2023.
//

import UIKit

class CompetitionViews {
    let view: UIView!
    
    init(view: UIView) {
        self.view = view
    }
    
    func setupAddCompetitionButton(_ button: UIButton) {
        view.addSubview(button)
        
        button.tintColor = .label
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus")!, for: .normal)
        button.layer.cornerRadius = 10
        button.alpha = 0.5
        view.bringSubviewToFront(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 110),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
}
