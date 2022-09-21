//
//  Url.swift
//  SoftxpertTask
//
//  Created by Mina Ezzat on 9/19/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

struct UrlServices {
    var queryParamter: String = ""
    var healthFilter: String = ""
    var url: String {
        return "https://api.edamam.com/api/recipes/v2?type=public&q=\(queryParamter)&app_id=1be6093f&app_key=74f74cc14ec2e7c3c77f13b86225b230\(healthFilter)"
    }
}

enum HealthFilters: String {
    case none = ""
    case lowSugar = "&health=low-sugar"
    case keto = "&health=keto-friendly"
    case vegan = "&health=vegan"
}
