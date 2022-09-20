//
//  RecipeTableModelView.swift
//  SoftxpertTask
//
//  Created by Mina Ezzat on 9/19/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

class RecipeTableModelView {
    var networkService: NetworkLayer?
    var recipes: RecipeJson? {
        didSet {
            self.bindRecipeViewModelToView(recipes, nil)
        }
    }
    var showError: String? {
        didSet {
            self.bindRecipeViewModelToView(nil, showError)
        }
    }
    
    var bindRecipeViewModelToView: ((RecipeJson?, String?)->Void) = {_,_ in }
    
    init(networkService: NetworkLayer) {
        self.networkService = networkService
    }
    
    func fetchRecipesData(healthFilter: String) {
        networkService?.fetchAllRecipesData(healthFilter: healthFilter, completion: {[weak self] recipesData, error in
            guard let self = self else {return}
            if let error = error {
                let message = error.localizedDescription
                self.showError = message
            } else {
                self.recipes = recipesData
            }
            
        })
    }
    
    func fetchRecipesOfNextPage(urlString: String) {
        networkService?.fetchRecipesOfNextPage(urlString: urlString, completion: {[weak self] recipesData, error in
            guard let self = self else {return}
            if let error = error {
                let message = error.localizedDescription
                self.showError = message
            } else {
                self.recipes?.hits?.append(contentsOf: recipesData ?? Array<Hit>())
            }
        })
    }
}
