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
    @Environment(\.dismiss) var dismiss
    
    let countries = ["us", "gb", "ca", "in", "fr"]
    let categories = ["business", "technology", "science", "health"]
    
    // Your signature colors
    let deepNavy = Color(red: 0/255, green: 19/255, blue: 62/255)
    let steelGray = Color(red: 154/255, green: 166/255, blue: 178/255)

    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("News Direction")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(deepNavy)
                .padding(.vertical, 20)

            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // Filter Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Selection Filters")
                            .font(.headline)
                            .foregroundColor(deepNavy)
                        
                        HStack {
                            filterPicker(title: "Country", selection: $selectedCountry, options: countries, isCaps: true)
                            Spacer()
                            filterPicker(title: "Category", selection: $selectedCategory, options: categories, isCaps: false)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)

                    // Action Button
                    Button(action: {
                        viewModel.fetchAndAnalyze(country: selectedCountry, category: selectedCategory)
                    }) {
                        ZStack {
                            if viewModel.isLoading {
                                ProgressView().tint(deepNavy)
                            } else {
                                Text("Generate AI Insights")
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(steelGray) // Using Steel Gray for the main button
                        .foregroundColor(deepNavy)
                        .cornerRadius(12)
                    }

                    // AI Results Section
                    if !viewModel.aiRepetitiveIdea.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Most Repetitive Idea")
                                .font(.headline)
                                .foregroundColor(deepNavy)
                            
                            Text(viewModel.aiRepetitiveIdea)
                                .font(.body)
                                .italic()
                                .foregroundColor(deepNavy.opacity(0.8)) // Navy text for AI summary
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(steelGray.opacity(0.15)) // Light Steel Gray background
                                .cornerRadius(12)
                        }
                        
                        // --- THE VISUALLY APPEALING ARTICLE CARDS ---
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Curated Sources")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(deepNavy)
                            
                            ForEach(viewModel.articles) { article in
                                if let urlString = article.url, let url = URL(string: urlString) {
                                    Link(destination: url) {
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text(article.title)
                                                .font(.headline)
                                                .foregroundColor(deepNavy) // Navy Title
                                                .multilineTextAlignment(.leading)
                                                .lineLimit(3)
                                            
                                            if let desc = article.description {
                                                Text(desc)
                                                    .font(.subheadline)
                                                    .foregroundColor(deepNavy.opacity(0.6)) // Subdued Navy description
                                                    .lineLimit(2)
                                                    .multilineTextAlignment(.leading)
                                            }
                                            
                                            HStack {
                                                Text("View Source")
                                                    .font(.caption.bold())
                                                Image(systemName: "chevron.right")
                                                    .font(.caption2)
                                            }
                                            .foregroundColor(steelGray) // Steel Gray for the "Action" link
                                            .padding(.top, 5)
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color(white: 0.98)) // Very light gray card
                                        .cornerRadius(15)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(steelGray.opacity(0.2), lineWidth: 1) // Subtle Steel Gray border
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }

            // Bottom Navigation
            Button(action: { dismiss() }) {
                Text("Back to Main")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(steelGray.opacity(0.2))
                    .foregroundColor(deepNavy)
                    .cornerRadius(12)
            }
            .padding()
        }
        .background(Color.white.ignoresSafeArea())
        .preferredColorScheme(.light)
    }
    
    @ViewBuilder
    func filterPicker(title: String, selection: Binding<String>, options: [String], isCaps: Bool) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title).font(.caption2).bold().foregroundColor(deepNavy.opacity(0.5))
            Picker(title, selection: selection) {
                ForEach(options, id: \.self) {
                    Text(isCaps ? $0.uppercased() : $0.capitalized)
                        .foregroundColor(deepNavy)
                }
            }
            .pickerStyle(.menu)
            .padding(.horizontal, 8)
            .background(steelGray.opacity(0.2))
            .cornerRadius(8)
        }
    }
}
