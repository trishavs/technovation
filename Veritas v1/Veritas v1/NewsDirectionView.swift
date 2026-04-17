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
    
    // Veritas Palette
    let navy = Color(red: 0/255, green: 19/255, blue: 62/255)
    let steelGray = Color(red: 154/255, green: 166/255, blue: 178/255)
    let lightPeriwinkle = Color(red: 236/255, green: 236/255, blue: 255/255)

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header (Veritas Branding Top Right)
            HStack(alignment: .top) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(navy)
                }
                .padding(.top, 10)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 12) {
                        Rectangle().fill(steelGray.opacity(0.4)).frame(width: 60, height: 4)
                        Rectangle().fill(steelGray.opacity(0.4)).frame(width: 30, height: 4)
                    }
                    Text("Veritas")
                        .font(.system(size: 38, weight: .regular, design: .serif))
                        .italic()
                        .foregroundColor(navy)
                    Text("NEWS DIRECTION")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(3)
                        .foregroundColor(steelGray)
                }
            }
            .padding(.horizontal, 25)
            .padding(.top, 20)

            // MARK: - Filter Section (Themed)
            VStack(spacing: 15) {
                HStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("REGION")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(steelGray)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(countries, id: \.self) { country in
                                    pillButton(text: country.uppercased(), isSelected: selectedCountry == country) {
                                        selectedCountry = country
                                    }
                                }
                            }
                        }
                    }
                }
                
                HStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("CATERGORY")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(steelGray)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(categories, id: \.self) { cat in
                                    pillButton(text: cat.capitalized, isSelected: selectedCategory == cat) {
                                        selectedCategory = cat
                                    }
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        viewModel.fetchAndAnalyze(country: selectedCountry, category: selectedCategory)
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 45))
                            .foregroundColor(navy)
                    }
                }
            }
            .padding(25)
            .background(lightPeriwinkle.opacity(0.4))
            .cornerRadius(25)
            .padding(.horizontal)
            .padding(.top, 25)

            // MARK: - Article Feed
            ScrollView(showsIndicators: false) {
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.top, 50)
                        .tint(navy)
                } else {
                    VStack(spacing: 20) {
                        // AI Synthesis Quote
                        if !viewModel.aiRepetitiveIdea.isEmpty {
                            HStack(alignment: .top) {
                                Image(systemName: "quote.opening")
                                    .foregroundColor(steelGray)
                                Text(viewModel.aiRepetitiveIdea)
                                    .font(.system(size: 16, design: .serif))
                                    .italic()
                                    .foregroundColor(navy)
                                    .lineSpacing(4)
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                        }

                        // Articles
                        ForEach(viewModel.articles) { article in
                            Link(destination: URL(string: article.url ?? "") ?? URL(string: "https://google.com")!) {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text(article.source?.name?.uppercased() ?? "NEWS")
                                            .font(.system(size: 9, weight: .black))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(navy)
                                            .foregroundColor(.white)
                                            .cornerRadius(4)
                                        Spacer()
                                        Image(systemName: "arrow.up.right")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(steelGray)
                                    }
                                    
                                    Text(article.title)
                                        .font(.system(size: 19, weight: .semibold, design: .serif))
                                        .foregroundColor(navy)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(3)
                                    
                                    if let desc = article.description {
                                        Text(desc)
                                            .font(.system(size: 14))
                                            .foregroundColor(navy.opacity(0.7))
                                            .lineLimit(2)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                .padding(20)
                                .background(Color.white)
                                .cornerRadius(18)
                                .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .background(Color.white.ignoresSafeArea())
    }

    // Custom Pill UI for Filters
    func pillButton(text: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 13, weight: .bold))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? navy : Color.white)
                .foregroundColor(isSelected ? .white : navy)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? navy : steelGray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}
