//
//  NetworkService.swift
//  SoftxpertTask
//
//  Created by Mina Ezzat on 9/19/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService : NetworkLayer{
    
    func fetchAllRecipesData(healthFilter: String, completion: @escaping (RecipeJson?,Error?) ->()){
        guard let url = URL(string: "\(Url.urlString)\(healthFilter)") else { return }
       
        AF.request(url).validate().responseDecodable(of: RecipeJson.self) { response in
            print(response.result)
            switch response.result {
            case .success(_):
                guard let recipeData = response.value else { return }
                completion(recipeData, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
}
