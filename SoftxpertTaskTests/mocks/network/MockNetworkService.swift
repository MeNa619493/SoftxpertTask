//
//  MockNetworkService.swift
//  SoftxpertTaskTests
//
//  Created by Mina Ezzat on 9/22/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation
@testable import SoftxpertTask

class MockNetworkService: NetwokProtocol {
    var fileName: String?
       
    init(fileName: String) {
        self.fileName = fileName
    }
       
       
    func data(in fileName: String?, extension: String?) -> Data? {
        guard let path = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: `extension`) else {
            assertionFailure("Unable to find file name \(String(describing: fileName))")
            return nil
        }
           
        guard let data = try? Data(contentsOf: path) else {
            assertionFailure("Unable to parse data")
            return nil
        }
           
        return data
    }
    
    func fetchAllRecipesData(healthFilter: String, completion: @escaping (RecipeJson?, Error?) -> ()) {
        guard let data = data(in: fileName, extension: "json") else {
            assertionFailure("Unable to find the file with name: RecipeResponse")
            return
        }
        do {
            let apiResponse = try JSONDecoder().decode(RecipeJson.self, from: data)
            completion(apiResponse, nil)
        } catch {
            completion(nil, DecodingError.decodingError)
            print(error.localizedDescription)
        }
    }
    
    func fetchRecipesOfNextPage(urlString: String, completion: @escaping (RecipeJson?, Error?) -> ()) {
        guard let data = data(in: fileName, extension: "json") else {
            assertionFailure("Unable to find the file with name: RecipeResponse")
            return
        }
        do {
            let apiResponse = try JSONDecoder().decode(RecipeJson.self, from: data)
            completion(apiResponse, nil)
        } catch {
            completion(nil, DecodingError.decodingError)
            print(error.localizedDescription)
        }
    }
    
    func fetchSearchedRecipesData(searchInput: String, healthFilter: String, completion: @escaping (RecipeJson?, Error?) -> ()) {
        guard let data = data(in: fileName, extension: "json") else {
            assertionFailure("Unable to find the file with name: RecipeResponse")
            return
        }
        do {
            let apiResponse = try JSONDecoder().decode(RecipeJson.self, from: data)
            completion(apiResponse, nil)
        } catch {
            completion(nil, DecodingError.decodingError)
            print(error.localizedDescription)
        }
    }
    
    enum DecodingError: Error {
        case decodingError
    }
}
