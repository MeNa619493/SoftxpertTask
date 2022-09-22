//
//  HealthCollectionViewCell.swift
//  SoftxpertTask
//
//  Created by Mina Ezzat on 9/20/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit

class HealthCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureCell(health: [String]) {
        for text in health {
            let label = UILabel()
            label.text  = text
            label.textAlignment = .left
            cellStack.addArrangedSubview(label)
        }
    }

}
