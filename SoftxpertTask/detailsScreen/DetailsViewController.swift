//
//  DetailsViewController.swift
//  SoftxpertTask
//
//  Created by Mina Ezzat on 9/20/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit
import Kingfisher
import ProgressHUD

class DetailsViewController: UIViewController {

    var recipe: Recipe?
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    
    @IBOutlet weak var websiteButton: UIButton!
   
    @IBOutlet weak var ingredientsStack: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        showprogress()
        prepareScreenElements()
        prepareIngredientsTable()
        makeWebsiteButtonRounded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ProgressHUD.dismiss()
    }
    
    func showprogress() {
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.show()
    }
    
    func prepareScreenElements() {
        if let url = URL(string: recipe?.image ?? ""){
            recipeImage.kf.setImage(with: url)
        }
        recipeTitle.text = recipe?.label
    }
    
    func prepareIngredientsTable() {
        if let textArray = recipe?.ingredientLines {
            for text in textArray {
                let label = UILabel()
                label.widthAnchor.constraint(equalToConstant: ingredientsStack.frame.width).isActive = true
                label.text  = "- \(text)"
                label.numberOfLines = 0
                label.textAlignment = .left
                ingredientsStack.addArrangedSubview(label)
            }
        }
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
        guard let url = URL(string: recipe?.url ?? "") else { return }
        let objectToShare = [url]
        let activityViewController = UIActivityViewController(activityItems: objectToShare, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
}

