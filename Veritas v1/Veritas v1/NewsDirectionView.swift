//
//  NewsDirectionView.swift
//  
//
//  Created by Nishi Patel on 4/16/26.
//
import SwiftUI

struct NewsDirectionView: View {
    @StateObject var viewModel = NewsViewModel()
    @State private var selectedCountry = "us"
    @State private var selectedCategory = "technology"
    
    let countries = ["us", "gb", "ca", "in", "fr"]
    let categories = ["business", "technology", "science", "health"]

    var body: some View {
        VStack {
            Text("News Direction")
                .font(.title).bold()
                .foregroundColor(Color(red: 0/255, green: 19/255, blue: 62/255))
                .padding()

            Form {
                Section("Selection Filters") {
                    Picker("Country", selection: $selectedCountry) {
                        ForEach(countries, id: \.self) { Text($0.uppercased()) }
                    }
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { Text($0.capitalized) }
                    }
                }
                
                Button("Generate AI Insights") {
                    viewModel.fetchAndAnalyze(country: selectedCountry, category: selectedCategory)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 154/255, green: 166/255, blue: 178/255))
                .foregroundColor(Color(red: 0/255, green: 19/255, blue: 62/255))
                .cornerRadius(10)

                if viewModel.isLoading {
                    ProgressView("Analyzing articles...")
                } else if !viewModel.aiRepetitiveIdea.isEmpty {
                    Section("Most Repetitive Idea") {
                        Text(viewModel.aiRepetitiveIdea)
                            .font(.body).italic()
                            .foregroundColor(.blue)
                    }
                    
                    Section("Curated Sources (5+)") {
                        ForEach(viewModel.articles) { article in
                            Link(destination: URL(string: article.url)!) {
                                VStack(alignment: .leading) {
                                    Text(article.title).font(.subheadline).bold()
                                    if let desc = article.description {
                                        Text(desc).font(.caption).lineLimit(2)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
