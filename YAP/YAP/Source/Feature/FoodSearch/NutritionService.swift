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
    
    var components = URLComponents(string: URL)!
    
    components.queryItems = [
      URLQueryItem(name: "servicekey", value: serviceKey),
      URLQueryItem(name: "type", value: "json"),
      URLQueryItem(name: "FOOD_NM_KR", value: query)
    ]
    
    guard let url = components.url else {
      throw URLError(.badURL)
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse,
          (200..<299).contains(httpResponse.statusCode) else {
      throw URLError(.badServerResponse)
    }
    
    let decoder = JSONDecoder()
    let foodData = try decoder.decode(NutritionResponse.self, from: data)
    
    return foodData.body.items
  }
}

