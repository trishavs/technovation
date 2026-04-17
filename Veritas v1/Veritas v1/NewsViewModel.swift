//
//  NewsViewModel.swift
//  
//
//  Created by Nishi Patel on 4/16/26.
//
import Foundation
import Combine

struct NewsResponse: Codable {
    let articles: [Article]
}

struct Article: Codable, Identifiable {
    var id: String { url ?? UUID().uuidString }
    let title: String
    let description: String?
    let url: String?
    let source: Source?
}

struct Source: Codable {
    let name: String?
}

class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var aiRepetitiveIdea: String = ""
    @Published var isLoading = false
    
    let apiKey = "34a8876792c749148899bcf77296b913"

    func fetchAndAnalyze(country: String, category: String) {
        isLoading = true
        let query = "\(country) \(category)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? category
        let urlString = "https://newsapi.org/v2/everything?q=\(query)&language=en&pageSize=10&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let decoded = try? JSONDecoder().decode(NewsResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.articles = Array(decoded.articles.prefix(6))
                    self.aiRepetitiveIdea = "Trends in \(category.capitalized) within \(country.uppercased()) indicate a shift toward localized digital infrastructure."
                    self.isLoading = false
                }
            }
        }.resume()
    }
}

