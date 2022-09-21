//
//  RecipeTableModelView.swift
//  SoftxpertTask
//
//  Created by Mina Ezzat on 9/19/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

class RecipeTableModelView {
    var networkService: ApiService?
    var recipe: RecipeJson? {
        didSet {
            self.bindRecipeViewModelToView(recipe, nil)
        }
    }
    var showError: String? {
        didSet {
            self.bindRecipeViewModelToView(nil, showError)
        }
    }
    
    var bindRecipeViewModelToView: ((RecipeJson?, String?)->Void) = {_,_ in }
    
    init(networkService: ApiService) {
        self.networkService = networkService
    }
    
    func fetchRecipesData(healthFilter: String) {
        networkService?.fetchAllRecipesData(healthFilter: healthFilter, completion: {[weak self] recipesData, error in
            guard let self = self else {return}
            if let error = error {
                let message = error.localizedDescription
                self.showError = message
            } else {
                self.recipe = recipesData
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
                self.recipe?.hits?.append(contentsOf: recipesData?.hits ?? Array<Hit>())
                self.recipe?.links?.next?.href = recipesData?.links?.next?.href
            }
        })
    }
    
    func fetchSearchedRecipes(searchInput: String, healthFilter: String) {
        networkService?.fetchSearchedRecipesData(searchInput: searchInput, healthFilter: healthFilter, completion: {[weak self] recipesData, error in
            guard let self = self else {return}
            if let error = error {
                let message = error.localizedDescription
                self.showError = message
            } else {
               self.recipe = recipesData
            }
        })
    }
}
