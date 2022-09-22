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
    var recipe: Recipe?

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var source: UILabel!
    
    @IBOutlet weak var healthCollectionView: UICollectionView! {
        didSet {
            healthCollectionView.delegate = self
            healthCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerNibFile()
    }

    func configureCell(recipe: Recipe) {
        self.recipe = recipe
        title.text = recipe.label
        source.text = recipe.source

        if let url = URL(string: recipe.image ?? ""){
            recipeImage.kf.setImage(with: url)
        }
    }
    
    func registerNibFile() {
        healthCollectionView.register(UINib(nibName: CellFilesName.HealthCollectionViewCell.rawValue, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.HealthCollectionViewCell.rawValue)
    }
    
}

extension RecipeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recipe?.healthLabels?.count==0 ? 0 : 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.HealthCollectionViewCell.rawValue, for: indexPath) as! HealthCollectionViewCell

        if let healthLabels = recipe?.healthLabels {
            cell.configureCell(health: healthLabels)
        }
        return cell
    }

}
