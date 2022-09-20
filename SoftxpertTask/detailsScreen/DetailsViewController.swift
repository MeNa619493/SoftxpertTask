//
//  DetailsViewController.swift
//  SoftxpertTask
//
//  Created by Mina Ezzat on 9/20/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit
import Kingfisher

class DetailsViewController: UIViewController {

    var recipe: Recipe?
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeIngredientsTable: UITableView! {
        didSet {
            recipeIngredientsTable.delegate = self
            recipeIngredientsTable.dataSource = self
        }
    }
    
    @IBOutlet weak var websiteButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareScreenElements()
        makeWebsiteButtonRounded()
    }
    
    func prepareScreenElements() {
        if let url = URL(string: recipe?.image ?? ""){
            recipeImage.kf.setImage(with: url)
        }
        recipeTitle.text = recipe?.label
    }
    
    func makeWebsiteButtonRounded() {
        websiteButton.layer.cornerRadius = websiteButton.frame.height / 2
        websiteButton.layer.masksToBounds = true
    }
    
    @IBAction func onWebsiteButtonPressed(_ sender: UIButton) {
        guard let url = URL(string: recipe?.url ?? "") else {
            showAlert()
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Sorry", message: "We have not that link.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func onBackButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onShareButtonPressed(_ sender: UIBarButtonItem) {
    }
    
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe?.ingredientLines?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = recipe?.ingredientLines?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        20
    }
}
