//
//  ContentView.swift
//  Veritas v1
//
//  Created by Katelyn Mikheev on 3/29/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // Title
                Text("Veritas")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0/255, green: 19/255, blue: 62/255)) // Dark navy
                    .padding(.bottom, 30)
                
                // Buttons
                NavigationLink(destination: BlankView(title: "Lessons")) {
                    Text("Lessons")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 154/255, green: 166/255, blue: 178/255)) // Button color
                        .foregroundColor(Color(red: 0/255, green: 19/255, blue: 62/255)) // Text color
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: BlankView(title: "Bias Checker")) {
                    Text("Bias Checker")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 154/255, green: 166/255, blue: 178/255))
                        .foregroundColor(Color(red: 0/255, green: 19/255, blue: 62/255))
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: BlankView(title: "News Direction")) {
                    Text("News Direction")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 154/255, green: 166/255, blue: 178/255))
                        .foregroundColor(Color(red: 0/255, green: 19/255, blue: 62/255))
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: BlankView(title: "Something else")) {
                    Text("Something else")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 154/255, green: 166/255, blue: 178/255))
                        .foregroundColor(Color(red: 0/255, green: 19/255, blue: 62/255))
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.white)
        }
    }
}

// MARK: - Blank View with "Back to Main" button
struct BlankView: View {
    var title: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0/255, green: 19/255, blue: 62/255))
            
            Spacer()
            
            Button(action: {
                dismiss()
            }) {
                Text("Back to Main")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 154/255, green: 166/255, blue: 178/255))
                    .foregroundColor(Color(red: 0/255, green: 19/255, blue: 62/255))
                    .cornerRadius(10)
            }
            
        }
        .padding()
        .background(Color.white)
    }
}
