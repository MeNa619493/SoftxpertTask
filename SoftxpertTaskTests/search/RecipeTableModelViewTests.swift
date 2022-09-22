//
//  RecipeTableModelViewTests.swift
//  SoftxpertTaskTests
//
//  Created by Mina Ezzat on 9/22/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import XCTest
@testable import SoftxpertTask

class RecipeTableModelViewTests: XCTestCase {
    private var sut: RecipeTableModelView!
    
    override func setUp() {
        super.setUp()
        sut = RecipeTableModelView(networkService: MockNetworkService(fileName: "RecipeResponse"))
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testSut_whenInitCalled_networkServiceIsSet() {
        XCTAssertNotNil(sut.networkService)
    }
    
    func testSut_whenFetchRecipesDataCalled_recipesFilledSuccessfully() {
        sut.fetchRecipesData(healthFilter: "")
        XCTAssertNotNil(sut.recipe)
    }
    
    func testSut_whenFetchRecipesDataCalled_recipesUnfilled() {
        sut = RecipeTableModelView(networkService: MockNetworkService(fileName: "Error"))
        sut.fetchRecipesData(healthFilter: "")
        XCTAssertNil(sut.recipe)
    }
    
    func testSut_whenFetchRecipesOfNextPageCalled_recipesFilledSuccessfully() {
        sut.fetchRecipesData(healthFilter: "")
        sut.fetchRecipesOfNextPage(urlString: "")
        XCTAssertEqual(sut.recipe?.hits?.count, 40)
    }
    
    func testSut_whenFetchRecipesOfNextPageCalled_recipesUnfilled() {
        sut = RecipeTableModelView(networkService: MockNetworkService(fileName: "Error"))
        sut.fetchRecipesOfNextPage(urlString: "")
        XCTAssertNil(sut.recipe)
    }
    
    func testSut_whenFetchSearchedRecipesCalled_recipesFilledSuccessfully() {
        sut.fetchSearchedRecipes(searchInput: "", healthFilter: "")
        XCTAssertNotNil(sut.recipe)
    }
    
    func testSut_whenFetchSearchedRecipesCalled_recipesUnfilled() {
        sut = RecipeTableModelView(networkService: MockNetworkService(fileName: "Error"))
        sut.fetchSearchedRecipes(searchInput: "", healthFilter: "")
        XCTAssertNil(sut.recipe)
    }
    
    

}
