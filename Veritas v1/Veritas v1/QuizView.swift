//
//  QuizView.swift
//
//
//  Created by Katelyn Mikheev on 4/17/2026
//
import SwiftUI

struct QuizAnswer {
    let text: String
    let isCorrect: Bool
}

struct QuizQuestion {
    let text: String
    let answers: [QuizAnswer]  // always exactly 4
}

// Quiz view

struct QuizView: View {
    var backToMain: () -> Void

    @State private var currentIndex = 0
    @State private var selectedIndex: Int? = nil  // which button the user tapped
    @State private var score = 0
    @State private var quizFinished = false

    let navy = Color(red: 0/255, green: 19/255, blue: 62/255)
    let steelGray = Color(red: 154/255, green: 166/255, blue: 178/255)
    let lightPeriwinkle = Color(red: 236/255, green: 236/255, blue: 255/255)

    // Quiz questions
    let questions: [QuizQuestion] = [

        // Question 1
        QuizQuestion(text: "1. Which of the following best describes emotional manipulation in misinformation?", answers: [
            QuizAnswer(text: "Using long explanations and data",  isCorrect: false),   // wrong
            QuizAnswer(text: "Encouraging readers to stay calm and research more",  isCorrect: false),  // wrong
            QuizAnswer(text: "Trying to make readers feel fear or anger so they react quickly",  isCorrect: true),  // right
            QuizAnswer(text: "Listing multiple reliable sources",  isCorrect: false),  // wrong
        ]),

        // Question 2
        QuizQuestion(text: "2. You see a post that says, 'If you care about your family, you should be furious about this!!!' Which misinformation red flag does this example show?", answers: [
            QuizAnswer(text: "Vague sources",  isCorrect: false),  // wrong
            QuizAnswer(text: "Emotional manipulation",  isCorrect: true),   // right
            QuizAnswer(text: "Outdated information",  isCorrect: false),  // wrong
            QuizAnswer(text: "Poor grammar",  isCorrect: false),  // wrong
        ]),

        // Question 3
        QuizQuestion(text: "3. Which phrase is an example of a vague source?", answers: [
            QuizAnswer(text: "'According to a 2022 report by the CDC...'",  isCorrect: false),  // wrong
            QuizAnswer(text: "'A study published in Nature found...'",  isCorrect: false),  // wrong
            QuizAnswer(text: "'Experts say this is dangerous.'",  isCorrect: true),   // right
            QuizAnswer(text: "'The World Health Organization reports...'",  isCorrect: false),  // wrong
        ]),

        // Question 4
        QuizQuestion(text: "4. If an article says 'studies show' but does not name or link to the studies, this is a red flag for misinformation.", answers: [
            QuizAnswer(text: "True",  isCorrect: true),  // right
            QuizAnswer(text: "False",  isCorrect: false),  // wrong
            QuizAnswer(text: "Maybe",  isCorrect: false),  // wrong
            QuizAnswer(text: "I don't know",  isCorrect: false),   // wrong
        ]),

        // Question 5
        QuizQuestion(text: "5. A post says, 'Share this now before it gets deleted!'", answers: [
            QuizAnswer(text: "Emotional manipulation",  isCorrect: false),  // wrong
            QuizAnswer(text: "Vague sources",  isCorrect: false),   // wrong
            QuizAnswer(text: "Manipulation with urgancy or pressure",  isCorrect: true),  // right
            QuizAnswer(text: "Outdated information",  isCorrect: false),  // wrong
        ]),

        // Question 6
        QuizQuestion(text: "6. Why do misinformation posts often create a sense of urgency?", answers: [
            QuizAnswer(text: "To help readers stay informed",  isCorrect: false),   // wrong
            QuizAnswer(text: "To prevent people from fact checking",  isCorrect: true),  // right
            QuizAnswer(text: "To encourage discussion",  isCorrect: false),  // wrong
            QuizAnswer(text: "To provide accurate updates",  isCorrect: false),  // wrong
        ]),

        // Question 7
        QuizQuestion(text: "7. An image from 2015 is reposted online in 2024 and presented as if it just happened, without any date or background information. Which red flag does this show?", answers: [
            QuizAnswer(text: "Emotional manipulation",  isCorrect: false),  // wrong
            QuizAnswer(text: "Outdated or missing context",  isCorrect: true),  // right
            QuizAnswer(text: "Poor grammar",  isCorrect: false),  // wrong
            QuizAnswer(text: "Vague sources",  isCorrect: false),   // wrong
        ]),

        // Question 8
        QuizQuestion(text: "8. Why is missing context dangerous in misinformation?", answers: [
            QuizAnswer(text: "It makes posts harder to read",  isCorrect: false),  // wrong
            QuizAnswer(text: "It makes information seem older",  isCorrect: false),  // wrong
            QuizAnswer(text: "It can make information misleading or false",  isCorrect: true),   // right
            QuizAnswer(text: "It lowers internet speed",  isCorrect: false),  // wrong
        ]),

        // Question 9
        QuizQuestion(text: "9. Which sign most strongly suggests poor credibility?", answers: [
            QuizAnswer(text: "Calm tone and clear writing",  isCorrect: false),   // wrong
            QuizAnswer(text: "Proper grammar and punctuation",  isCorrect: false),  // wrong
            QuizAnswer(text: "Excessive capital letters, emojis, and spelling errors",  isCorrect: true),  // right
            QuizAnswer(text: "Quoting names experts",  isCorrect: false),  // wrong
        ]),
    ]

    // Body

    var body: some View {
        if quizFinished {
            scoreScreen
        } else {
            quizScreen
        }
    }

    // Quiz screen
    var quizScreen: some View {
        VStack(spacing: 0) {

            // Question number indicator
            Text("Question \(currentIndex + 1) of \(questions.count)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(steelGray)
                .padding(.top, 12)

            // Question text
            Text(questions[currentIndex].text)
                .font(.system(size: 22, weight: .bold, design: .serif))
                .foregroundColor(navy)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 25)
                .padding(.top, 16)
                .padding(.bottom, 24)

            // 2x2 answer grid
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    answerButton(index: 0)
                    answerButton(index: 1)
                }
                HStack(spacing: 12) {
                    answerButton(index: 2)
                    answerButton(index: 3)
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            // "Next" button that only shows when user chooses an answert
            if selectedIndex != nil {
                Button(action: {
                    if currentIndex < questions.count - 1 {
                        // Go to the next question and reset the selection
                        currentIndex += 1
                        selectedIndex = nil
                    } else {
                        quizFinished = true
                    }
                }) {
                    Text(currentIndex < questions.count - 1 ? "Next Question" : "See Results")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(navy)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 10)
            }

            // "Back to Lessons" button
            Button(action: { backToMain() }) {
                Text("Back to Lessons")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(steelGray)
                    .foregroundColor(navy)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 30)
        }
        .background(Color.white.ignoresSafeArea())
    }

    // Answer reveal
    func answerButton(index: Int) -> some View {
        let answer = questions[currentIndex].answers[index]

        var bgColor: Color = lightPeriwinkle
        if selectedIndex != nil {
            if answer.isCorrect {
                bgColor = Color(red: 0/255, green: 180/255, blue: 80/255)  // bright green = correct
            } else if selectedIndex == index {
                bgColor = Color(red: 210/255, green: 40/255, blue: 40/255) // bright red = wrong pick
            } else {
                bgColor = lightPeriwinkle.opacity(0.35)  // dim the other options
            }
        }

        return Button(action: {
            // Only allow one selection per question
            if selectedIndex == nil {
                selectedIndex = index
                if answer.isCorrect {
                    score += 1
                }
            }
        }) {
            Text(answer.text)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(selectedIndex == nil ? navy : .white)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(bgColor)
                .cornerRadius(14)
        }
        .animation(.easeInOut(duration: 0.25), value: selectedIndex)
    }
    
    // Score feedback
    var scoreScreen: some View {
        VStack(spacing: 30) {
            Spacer()

            Text("Quiz Complete!")
                .font(.system(size: 36, weight: .bold, design: .serif))
                .foregroundColor(navy)

            Text("You got \(score) out of \(questions.count)!")
                .font(.system(size: 28, weight: .bold, design: .serif))
                .foregroundColor(navy)

            Text(scoreMessage)
                .font(.system(size: 18, design: .serif))
                .foregroundColor(navy)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()

            Button(action: { backToMain() }) {
                Text("Back to Main")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(steelGray)
                    .foregroundColor(navy)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 40)
        }
        .background(Color.white.ignoresSafeArea())
    }

    // Encouragement message based on your score
    var scoreMessage: String {
        if score >= 7 {
            return "Congratulations! You can spot misinformation red flags!"
        } else {
            return "Not quite! Go back through the lesson and give it another try."
        }
    }
}
