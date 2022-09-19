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
    
    func fetchAllRecipesData(completion: @escaping (RecipeJson?,Error?) ->()){
        guard let url = URL(string: "https://api.edamam.com/api/recipes/v2?type=public&q=all&app_id=1be6093f&app_key=74f74cc14ec2e7c3c77f13b86225b230") else { return }
       
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

//
//guard let url = URL(string: "https://api.edamam.com/api/recipes/v2?type=public&q=all&app_id=1be6093f&app_key=74f74cc14ec2e7c3c77f13b86225b230&health=vegan") else {
//     return
// }
