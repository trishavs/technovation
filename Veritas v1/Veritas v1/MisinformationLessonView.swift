//
//  MisinformationLessonView.swift
//
//
//  Created by Katelyn Mikheev on 4/17/2026
//
import SwiftUI

struct MisinformationLessonView: View {
    var backToMain: () -> Void

    // Tracks which page (1 through 7) the user is on
    @State private var currentPage = 1

    // Total number of pages in this lesson (including quiz)
    let totalPages = 7

    let navy = Color(red: 0/255, green: 19/255, blue: 62/255)
    let steelGray = Color(red: 154/255, green: 166/255, blue: 178/255)
    let lightPeriwinkle = Color(red: 236/255, green: 236/255, blue: 255/255)

    // --- PAGE TITLES ---
    let pageTitles = [
        "Misinformation Red Flags",  // Page 1
        "Red Flag 1: Emotional Manipulation",  // Page 2 — Emotional manipulation
        "Red Flag 2: Vague Sources",   // Page 3 — Vague sources
        "Red Flag 3: Urgency or Pressure Manipulation",   // Page 4 — urgency/pressure manipulation
        "Red Flag 4: Outdated/No Context",    // Page 5 — outdated or no context
        "Red Flag 5: Poor Quality",   // Page 6 — poor quality or improper grammer/writing
        "Quiz",                          // Page 7 — mini quiz
    ]

    // --- PAGE TEXT CONTENT ---
    let pageTexts = [
        "In this lesson, we will be covering what red flags you can identify in order to discern whether a source is credible or not. You can also click the buttons below to quickly get to any topic of the lesson you would like. ",  // Page 1 text
        "What it is: When misinformation tries to make you scared, angry, etc. so that you react quickly instead of thinking carefully. The goal is to influence you rather than inform you.",  // Page 2 text
        "What it is: When a claim doesn’t give any clear name for where its information comes from. Examples of this are vague phrases like, 'experts say…' or 'studies show…'.",  // Page 3 text
        "What it is: When posts demand immediate action by saying things like, 'Share now!' or 'This will be deleted!' to prevent you from fact checking.", // Page 4 text
        "What it is: When old photos/videos/quotes are reposted as if they are new. Without the context and dates in the original post, it can be heavily misleading.",  // Page 5 text
        "What it is: When articles/posts have lots of grammatical errors, excessive capital letters or emojis, clickbait headings, and so on. These signs signal low credibility.",  // Page 6 text
        "Now that you have learned about the different types of misinformation red flags, it's time for a quiz! Click the button below to start the quiz.",  // Page 7 text
    ]

    var body: some View {
        VStack(spacing: 0) {

            // Page title formatting
            Text(pageTitles[currentPage - 1])
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(navy)
                .multilineTextAlignment(.center)
                .padding(.top, 50)
                .padding(.horizontal, 25)

            // Small page indicator
            Text("Page \(currentPage) of \(totalPages)")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(steelGray)
                .padding(.top, 8)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Page text
                    Text(pageTexts[currentPage - 1])
                        .font(.system(size: 17, design: .serif))
                        .foregroundColor(navy)
                        .lineSpacing(6)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Page 1 (Misinformation Red Flags) buttons
                    if currentPage == 1 {
                        VStack(spacing: 10) {
                            ForEach(1...5, id: \.self) { buttonNumber in
                                Button(action: {
                                    currentPage = buttonNumber + 1
                                }) {
                                    Text(pageTitles[buttonNumber])
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(lightPeriwinkle)
                                        .foregroundColor(navy)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(steelGray.opacity(0.4), lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }

                    // "Start Quiz" button — only shown on page 7 (the quiz page)
                    if currentPage == 7 {
                        Button(action: {
                        }) {
                            Text("Start Quiz")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(navy)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(25)
            }
            .padding(.top, 20)

            // Bottom button formatting
            HStack(spacing: 15) {
                // "Back to Main" always shows on every page
                Button(action: {
                    backToMain()
                }) {
                    Text("Back to Main")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(steelGray)
                        .foregroundColor(navy)
                        .cornerRadius(10)
                }

                // "Back to Lesson 1" shows on pages 2 through 7 (not on page 1 since that is lesson 1)
                if currentPage >= 2 {
                    Button(action: {
                        currentPage = 1
                    }) {
                        Text("Back to Lesson 1")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(lightPeriwinkle)
                            .foregroundColor(navy)
                            .cornerRadius(10)
                    }
                }

                // "Next" shows on every page except the last one (page 7, which is the quiz)
                if currentPage < totalPages {
                    Button(action: {
                        currentPage += 1
                    }) {
                        Text("Next")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(navy)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 30)
        }
        .background(Color.white.ignoresSafeArea())
    }
}
