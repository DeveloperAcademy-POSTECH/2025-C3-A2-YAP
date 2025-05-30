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
  @Published var foodItem: [FoodItem] = []
  @Published var errorMessage: String?
  
  // API 기본 정보
  private let URL = "https://apis.data.go.kr/1471000/FoodNtrCpntDbInfo02/getFoodNtrCpntDbInq02?"
  private let serviceKey = "jEXxxB7Q8KlPvUhb6pnfndpHx3tkbcB7xfNq6NvwHWYbWXRpHo4otl8aiWrC3A9WQUE5UIT7byapJ7zvReoNZA%3D%3D&type=json"
  
  // MARK: - 음식 검색 메서드
  func searchFood(query: String) async {
    do {
      let food = try await fetchNutritionData(query: query)
      self.foodItem = food
    } catch {
      if let urlError = error as? URLError {
        switch urlError.code {
        case .notConnectedToInternet:
          errorMessage = "인터넷 연결되어 있지 않습니다."
        case .badServerResponse:
          errorMessage = "서버와 통신이 원활하지 않습니다."
        case .timedOut:
          errorMessage = "요청 시간이 초과됐어요. 다시 시도해주세요."
        case .badURL:
          errorMessage = "올바른 URL이 아닙니다."
        default:
          errorMessage = "알 수 없는 오류가 발생했어요."
        }
      }
      print("\(error)")
    }
  }
  
  // MARK: - API 호출 로직
  func fetchNutritionData(query: String) async throws -> [FoodItem] {
    
    var components = URLComponents(string: URL)
    
    components?.queryItems = [
      URLQueryItem(name: "servicekey", value: serviceKey),
      URLQueryItem(name: "type", value: "json"),
      URLQueryItem(name: "FOOD_NM_KR", value: query)
    ]
    
    guard let url = components?.url else {
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
