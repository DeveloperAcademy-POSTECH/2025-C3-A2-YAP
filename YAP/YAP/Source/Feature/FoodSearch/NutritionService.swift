//
//  NutritionService.swift
//  YAP
//
//  Created by 조재훈 on 5/29/25.
//

import Foundation

// MARK: - 음식 영양성분 검색 (Swift Concurrency)
@MainActor
class NutritionService: ObservableObject {
  @Published var foodItem : [FoodItem] = []
  
  // API 기본 정보
  private let URL = "https://apis.data.go.kr/1471000/FoodNtrCpntDbInfo02/getFoodNtrCpntDbInq02?"
  private let serviceKey = "jEXxxB7Q8KlPvUhb6pnfndpHx3tkbcB7xfNq6NvwHWYbWXRpHo4otl8aiWrC3A9WQUE5UIT7byapJ7zvReoNZA%3D%3D&type=json"
  
  // MARK: - 음식 검색 메서드
  func searchFood(query: String) async {
    do {
      let food = try await fetchNutritionData(query: query)
      self.foodItem = food
    } catch {
      print("\(error)")
    }
  }
  
  // MARK: - API 호출 로직
  func fetchNutritionData(query: String) async throws -> [FoodItem] {
    
  }
  
}

