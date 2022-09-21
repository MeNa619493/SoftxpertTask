//
//  recipeJson.swift
//  SoftxpertTask
//
//  Created by Mina Ezzat on 9/19/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

struct RecipeJson: Codable {
    let from, to, count: Int?
    var links: WelcomeLinks?
    var hits: [Hit]?

    enum CodingKeys: String, CodingKey {
        case from, to, count
        case links = "_links"
        case hits
    }
}

struct Hit: Codable {
    let recipe: Recipe?

    enum CodingKeys: String, CodingKey {
        case recipe
    }
}

struct Next: Codable {
    var href: String?
    let title: Title?
}

enum Title: String, Codable {
    case nextPage = "Next page"
    case titleSelf = "Self"
}

struct Recipe: Codable {
    let label: String?
    let image: String?
    let source: String?
    let url: String?
    let healthLabels: [String]?
    let ingredientLines: [String]?
}

struct WelcomeLinks: Codable {
    var next: Next?
}
