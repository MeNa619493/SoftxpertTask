//
//  ApiService.swift
//  SoftxpertTask
//
//  Created by Mina Ezzat on 9/19/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

protocol ApiService {
    func fetchAllRecipesData(healthFilter: String, completion: @escaping (RecipeJson?,Error?) ->())
    func fetchRecipesOfNextPage(urlString: String, completion: @escaping (RecipeJson?,Error?) ->())
    func fetchSearchedRecipesData(searchInput: String,healthFilter: String, completion: @escaping (RecipeJson?,Error?) ->())
}
