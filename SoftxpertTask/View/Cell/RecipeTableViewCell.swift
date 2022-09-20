//
//  RecipeTableViewCell.swift
//  SoftxpertTask
//
//  Created by Mina Ezzat on 9/19/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit
import Kingfisher

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var healthLabels: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(recipe: Recipe) {
        title.text = recipe.label
        source.text = recipe.source
//        healthLabels.text = recipe.healthLabels?[0] ?? ""
        
        if let url = URL(string: recipe.image ?? ""){
            recipeImage.kf.setImage(with: url)
        }
    }
    
}
