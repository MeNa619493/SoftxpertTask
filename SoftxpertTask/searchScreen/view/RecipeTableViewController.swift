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
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    @IBOutlet weak var categoriesSegmentedControl: UISegmentedControl!
    
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
            
            self.recipesTable.tableFooterView = nil
        }
        
        recipeViewModel?.fetchRecipesData(healthFilter: "")
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
    
    @IBAction func onSegmentedControlPressed(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            recipeViewModel?.fetchRecipesData(healthFilter: "")
        case 1:
            recipeViewModel?.fetchRecipesData(healthFilter: "&health=low-sugar")
        case 2:
            recipeViewModel?.fetchRecipesData(healthFilter: "&health=keto-friendly")
        case 3:
            recipeViewModel?.fetchRecipesData(healthFilter: "&health=vegan")
        default:
            recipeViewModel?.fetchRecipesData(healthFilter: "")
        }
    }

    @IBAction func onSearchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
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
        return 120
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (recipes?.hits!.count)!-1 && (recipes?.links?.next?.title)!.rawValue == "Next page" {
            recipesTable.tableFooterView = createSpinnerFooter()
            recipeViewModel?.fetchRecipesOfNextPage(urlString: recipes?.links?.next?.href ?? "")
        }
    }
    
    func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 120))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsViewController
        vc.modalPresentationStyle = .fullScreen
        vc.recipe = recipes?.hits?[indexPath.row].recipe
        self.present(vc, animated: true, completion: nil)
    }
}

extension RecipeTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

       if range.location == 0 && string == " " { // prevent space on first character
           return false
       }

       if textField.text?.last == " " && string == " " { // allowed only single space
           return false
       }

       if string == " " { return true } // now allowing space between name

       if string.rangeOfCharacter(from: CharacterSet.letters.inverted) != nil {
           return false
       }

       return true
   }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let input = searchTextField.text {
            searchForWordInCategroy(segmentedIndex: categoriesSegmentedControl.selectedSegmentIndex, textFieldInput: input.trimmingCharacters(in: .whitespacesAndNewlines) )
        }
        searchTextField.text = ""
    }
    
    func searchForWordInCategroy(segmentedIndex: Int, textFieldInput: String) {
        switch segmentedIndex {
        case 0:
            recipeViewModel?.fetchSearchedRecipes(searchInput: textFieldInput, healthFilter: "")
        case 1:
            recipeViewModel?.fetchSearchedRecipes(searchInput: textFieldInput, healthFilter: "&health=low-sugar")
        case 2:
            recipeViewModel?.fetchSearchedRecipes(searchInput: textFieldInput, healthFilter: "&health=keto-friendly")
        case 3:
            recipeViewModel?.fetchSearchedRecipes(searchInput: textFieldInput, healthFilter: "&health=vegan")
        default:
            recipeViewModel?.fetchSearchedRecipes(searchInput: textFieldInput, healthFilter: "")
        }
    }
}



