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
    @Environment(\.dismiss) var dismiss // Added to match BlankView's behavior
    
    let countries = ["us", "gb", "ca", "in", "fr"]
    let categories = ["business", "technology", "science", "health"]
    
    // Custom Colors to match your palette
    let deepNavy = Color(red: 0/255, green: 19/255, blue: 62/255)
    let steelGray = Color(red: 154/255, green: 166/255, blue: 178/255)

    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("News Direction")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(deepNavy)
                .padding(.top)

            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // Filter Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Selection Filters")
                            .font(.headline)
                            .foregroundColor(deepNavy)
                        
                        HStack {
                            Picker("Country", selection: $selectedCountry) {
                                ForEach(countries, id: \.self) { Text($0.uppercased()) }
                            }
                            .pickerStyle(.menu)
                            .padding(5)
                            .background(deepNavy.opacity(0.7))
                            .cornerRadius(8)
                            
                            Spacer()
                            
                            Picker("Category", selection: $selectedCategory) {
                                ForEach(categories, id: \.self) { Text($0.capitalized) }
                            }
                            .pickerStyle(.menu)
                            .padding(5)
                            .background(deepNavy.opacity(0.7))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)

                    // Action Button
                    Button(action: {
                        viewModel.fetchAndAnalyze(country: selectedCountry, category: selectedCategory)
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: deepNavy))
                        } else {
                            Text("Generate AI Insights")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(steelGray)
                    .foregroundColor(deepNavy)
                    .cornerRadius(10)

                    // AI Results Section
                    if !viewModel.aiRepetitiveIdea.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Most Repetitive Idea")
                                .font(.headline)
                                .foregroundColor(deepNavy)
                            
                            Text(viewModel.aiRepetitiveIdea)
                                .font(.body)
                                .italic()
                                .foregroundColor(.blue)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.blue.opacity(0.05))
                                .cornerRadius(10)
                        }
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Curated Sources")
                                .font(.headline)
                                .foregroundColor(deepNavy)
                            
                            ForEach(viewModel.articles) { article in
                                Link(destination: URL(string: article.url)!) {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(article.title)
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundColor(deepNavy)
                                            .multilineTextAlignment(.leading)
                                        
                                        if let desc = article.description {
                                            Text(desc)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                                .lineLimit(2)
                                                .multilineTextAlignment(.leading)
                                        }
                                        Divider()
                                    }
                                }
                                .padding(.vertical, 5)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }

            Spacer()
            
            // Bottom Back Button to match BlankView
            Button(action: { dismiss() }) {
                Text("Back to Main")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(steelGray.opacity(0.5)) // Slightly lighter to distinguish from primary action
                    .foregroundColor(deepNavy)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white.ignoresSafeArea())
    }
}
