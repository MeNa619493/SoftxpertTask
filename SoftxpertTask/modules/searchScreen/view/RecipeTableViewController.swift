//
//  ViewController.swift
//  SoftxpertTask
//
//  Created by Mina Ezzat on 9/19/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit
import ProgressHUD

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
    @IBOutlet weak var noResultImage: UIImageView!
    
    var recipe: RecipeJson?
    var recipeViewModel: RecipeTableModelView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibFiles()
        
        recipeViewModel = RecipeTableModelView(networkService: NetworkService())
        
        recipeViewModel?.bindRecipeViewModelToView = {[weak self] recipeData, error in
            guard let self = self else { return }
            if let recipeData = recipeData {
                self.recipe = recipeData
                self.handleNoSearchResult()
                self.recipesTable.reloadData()
            }
            
            if let error = error {
                self.showErrorAlert(error: error)
            }
            
            self.hideProgress()
            self.recipesTable.tableFooterView = nil
        }
        
        recipeViewModel?.fetchRecipesData(healthFilter: "")
    }

    func registerNibFiles() {
        recipesTable.register(UINib(nibName: CellFilesName.RecipeTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.RecipeTableViewCell.rawValue)
    }
    
    func showErrorAlert(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in }
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleNoSearchResult() {
        if recipe?.hits?.count == 0 {
            self.noResultImage.isHidden = false
            self.recipesTable.isHidden = true
        } else {
            self.noResultImage.isHidden = true
            self.recipesTable.isHidden = false
        }
    }
    
    func showprogress() {
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.show()
    }
    
    func hideProgress() {
        ProgressHUD.dismiss()
    }
    
    @IBAction func onSegmentedControlPressed(_ sender: UISegmentedControl) {
        showprogress()
        
        switch sender.selectedSegmentIndex {
        case 0:
            recipeViewModel?.fetchRecipesData(healthFilter: HealthFilters.none.rawValue)
        case 1:
            recipeViewModel?.fetchRecipesData(healthFilter: HealthFilters.lowSugar.rawValue)
        case 2:
            recipeViewModel?.fetchRecipesData(healthFilter: HealthFilters.keto.rawValue)
        case 3:
            recipeViewModel?.fetchRecipesData(healthFilter: HealthFilters.vegan.rawValue)
        default:
            recipeViewModel?.fetchRecipesData(healthFilter: HealthFilters.none.rawValue)
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
        return recipe?.hits?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.RecipeTableViewCell.rawValue, for: indexPath) as! RecipeTableViewCell
        if let recipe = recipe?.hits?[indexPath.row].recipe {
            cell.configureCell(recipe: recipe)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let count = recipe?.hits?.count else { return }
        guard let nextPage = recipe?.links?.next?.title?.rawValue else { return }
        
        if indexPath.row == count-1 && nextPage == "Next page" {
            recipesTable.tableFooterView = createSpinnerFooter()
            if let url = recipe?.links?.next?.href {
                recipeViewModel?.fetchRecipesOfNextPage(urlString: url)
            }
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
        let vc = storyboard?.instantiateViewController(withIdentifier: ModulsIdentifier.DetailsViewController.rawValue) as! DetailsViewController
        vc.modalPresentationStyle = .fullScreen
        vc.recipe = recipe?.hits?[indexPath.row].recipe
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
        showprogress()
        
        switch segmentedIndex {
        case 0:
            recipeViewModel?.fetchSearchedRecipes(searchInput: textFieldInput, healthFilter: HealthFilters.none.rawValue)
        case 1:
            recipeViewModel?.fetchSearchedRecipes(searchInput: textFieldInput, healthFilter: HealthFilters.lowSugar.rawValue)
        case 2:
            recipeViewModel?.fetchSearchedRecipes(searchInput: textFieldInput, healthFilter: HealthFilters.keto.rawValue)
        case 3:
            recipeViewModel?.fetchSearchedRecipes(searchInput: textFieldInput, healthFilter: HealthFilters.vegan.rawValue)
        default:
            recipeViewModel?.fetchSearchedRecipes(searchInput: textFieldInput, healthFilter: HealthFilters.none.rawValue)
        }
    }
}



