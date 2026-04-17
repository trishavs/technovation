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
}

class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var aiRepetitiveIdea: String = ""
    @Published var isLoading = false
    
    // Your NewsAPI Key
    let apiKey = "34a8876792c749148899bcf77296b913"

    func fetchAndAnalyze(country: String, category: String) {
        isLoading = true
        self.articles = [] // Clear old articles
        
        // Using the "Everything" endpoint to ensure results always found
        // We search for the category + country name to get specific results
        let countryName = country == "in" ? "India" : country == "us" ? "USA" : country
        let query = "\(countryName) \(category)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? category
        
        let urlString = "https://newsapi.org/v2/everything?q=\(query)&language=en&pageSize=10&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                if let decoded = try? JSONDecoder().decode(NewsResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.articles = Array(decoded.articles.prefix(6))
                        self.performAIAnalysis()
                    }
                }
            }
        }.resume()
    }
    
    private func performAIAnalysis() {
        // Simulating the AI synthesis delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if self.articles.isEmpty {
                self.aiRepetitiveIdea = "No specific trends found for this region/topic today."
            } else {
                self.aiRepetitiveIdea = "Analysis Complete: Significant discourse identified regarding \(self.articles.first?.title.lowercased().prefix(30) ?? "local topics") and its impact on regional development."
            }
            self.isLoading = false
        }
    }
}
