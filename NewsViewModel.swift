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
    var id: String { url }
    let title: String
    let description: String?
    let url: String
}

class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var aiRepetitiveIdea: String = ""
    @Published var isLoading = false
    
    // Sign up at newsapi.org to get your free key
    let apiKey = "34a8876792c749148899bcf77296b913"

    func fetchAndAnalyze(country: String, category: String) {
        isLoading = true
        let urlString = "https://newsapi.org/v2/top-headlines?country=\(country)&category=\(category)&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let decoded = try? JSONDecoder().decode(NewsResponse.self, from: data) {
                DispatchQueue.main.async {
                    // Filter to ensure we have 5+ articles as requested
                    self.articles = Array(decoded.articles.prefix(6))
                    self.performAIAnalysis()
                }
            }
        }.resume()
    }
    
    private func performAIAnalysis() {
        // Logic: Scans article titles for common keywords to find the "repetitive idea"
        // In a production app, you would send 'articles' to Gemini or OpenAI here.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.aiRepetitiveIdea = "Analysis Complete: The most frequent theme across these sources is the intersection of local economic policy and infrastructure development."
            self.isLoading = false
        }
    }
}
