//
//  NutritionService.swift
//  YAP
//
//  Created by 조재훈 on 5/29/25.
//

import Foundation

@MainActor

class NutritionService: ObservableObject {
  @Published var foodItem : [FoodItem] = []
}
