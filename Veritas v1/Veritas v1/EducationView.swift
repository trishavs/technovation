//
//  MisinformationLessonView.swift
//
//
//  Created by Katelyn Mikheev on 4/17/2026
//
import SwiftUI

struct EducationView: View {
    @Environment(\.dismiss) var dismiss

    // Same colors as the rest of the app
    let navy = Color(red: 0/255, green: 19/255, blue: 62/255)
    let steelGray = Color(red: 154/255, green: 166/255, blue: 178/255)

    // This tracks whether the lesson is open or not
    @State private var showLesson1 = false

    var body: some View {
        VStack(spacing: 20) {

            // Page title
            Text("Lessons")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(navy)
                .padding(.top, 40)

            // Lesson 1 button — tapping this opens the lesson
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

            // Future lesson buttons would go here (same style as above)

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
        // When showLesson1 becomes true, push the lesson view onto the screen
        .navigationDestination(isPresented: $showLesson1) {
            MisinformationLessonView(backToMain: {
                // This closes the lesson and the education page, going all the way home
                showLesson1 = false
                dismiss()
            })
            .navigationBarBackButtonHidden(true)
        }
    }
}
