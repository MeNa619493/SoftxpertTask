//
//  ViewController.swift
//  SoftxpertTask
//
//  Created by Mina Ezzat on 9/19/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit

class RecipeTableViewController: UIViewController {

    @IBOutlet weak var recipesTable: UITableView! {
        didSet {
            recipesTable.delegate = self
            recipesTable.dataSource = self
        }
    }
    
    var recipes: RecipeJson?
    var recipeViewModel: RecipeTableModelView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibFiles()
        
        recipeViewModel = RecipeTableModelView(networkService: NetworkService())
        
        recipeViewModel?.bindRecipeViewModelToView = {[weak self] recipesArray, error in
            guard let self = self else {return}
            if let recipesArray = recipesArray {
                self.recipes = recipesArray
                self.recipesTable.reloadData()
            }
            
            if let error = error {
                self.showErrorAlert(error: error)
            }
        }
        
        recipeViewModel?.fetchRecipesData()
    }

    func registerNibFiles() {
        recipesTable.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeCell")
    }
    
    func showErrorAlert(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in }
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}

extension RecipeTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipes?.hits?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        if let recipe = recipes?.hits?[indexPath.row].recipe {
            cell.configureCell(recipe: recipe)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

