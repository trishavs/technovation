//
//  Education.swift
//
//
//  Created by Katelyn Mikheev on 4/17/2026
//
import SwiftUI

struct EducationView: View {
    @Environment(\.dismiss) var dismiss

    let navy = Color(red: 0/255, green: 19/255, blue: 62/255)
    let steelGray = Color(red: 154/255, green: 166/255, blue: 178/255)

    @State private var showLesson1 = false
    @State private var showLesson2 = false
    @State private var showLesson3 = false

    var body: some View {
        VStack(spacing: 20) {

            // Page title
            Text("Lessons")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(navy)
                .padding(.top, 40)

            // Lesson 1 button
            Button(action: {
                showLesson1 = true
            }) {
                Text("Lesson 1: Misinformation Red Flags")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(steelGray)
                    .foregroundColor(navy)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            // Lesson 2 button
            Button(action: {
                showLesson2 = true
            }) {
                Text("Lesson 2: Artificial Intelligence")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(steelGray)
                    .foregroundColor(navy)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            // Lesson 3 button
            Button(action: {
                showLesson3 = true
            }) {
                Text("Lesson 3: Privacy and Cybersecurity")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(steelGray)
                    .foregroundColor(navy)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()

            // Back to Main button
            Button(action: {
                dismiss()
            }) {
                Text("Back to Main")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(steelGray)
                    .foregroundColor(navy)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(Color.white.ignoresSafeArea())
        // When showLesson1 becomes true, put the lesson view onto the screen
        .navigationDestination(isPresented: $showLesson1) {
            MisinformationLessonView(backToMain: {
                showLesson1 = false
                dismiss()
            })
            .navigationBarBackButtonHidden(true)
        }
        .navigationDestination(isPresented: $showLesson2) {
            BlankLessonView(dismissToRoot: {
                showLesson2 = false
                dismiss()
            })
            .navigationBarBackButtonHidden(true)
        }
        .navigationDestination(isPresented: $showLesson3) {
            BlankLessonView(dismissToRoot: {
                showLesson3 = false
                dismiss()
            })
            .navigationBarBackButtonHidden(true)
        }
    }
}

// Page for lessons 2 and 3
struct BlankLessonView: View {
    var dismissToRoot: () -> Void

    var body: some View {
        Color.white.ignoresSafeArea()
    }
}
