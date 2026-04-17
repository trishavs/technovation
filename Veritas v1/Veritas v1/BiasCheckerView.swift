import SwiftUI

struct BiasCheckerView: View {
    @StateObject var viewModel = BiasViewModel()
    @State private var domainInput: String = ""
    @Environment(\.dismiss) var dismiss

    let navy = Color(red: 0/255, green: 19/255, blue: 62/255)
    let steelGray = Color(red: 154/255, green: 166/255, blue: 178/255)

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            HStack(alignment: .bottom) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(navy)
                }
                Spacer()
                VStack(spacing: 4) {
                    HStack(spacing: 15) {
                        Rectangle().fill(steelGray.opacity(0.5)).frame(width: 80, height: 4)
                        Rectangle().fill(steelGray.opacity(0.5)).frame(width: 40, height: 4)
                    }
                    HStack(alignment: .top, spacing: 0) {
                        Text("Veritas").font(.system(size: 34, weight: .regular, design: .serif)).italic().foregroundColor(navy)
                        Image(systemName: "magnifyingglass").font(.system(size: 20)).foregroundColor(steelGray).offset(x: -5, y: 5)
                    }
                }
            }
            .padding(.horizontal).padding(.top, 10)

            ScrollView {
                VStack(spacing: 25) {
                    // MARK: - Search Pill
                    HStack {
                        TextField("paste url here....", text: $domainInput)
                            .font(.system(size: 18, design: .serif))
                            .foregroundColor(navy)

                        if viewModel.isLoading {
                            ProgressView().tint(navy)
                        } else {
                            Button(action: {
                                hideKeyboard()
                                viewModel.checkBias(for: domainInput)
                            }) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.title2).foregroundColor(navy)
                            }
                        }
                    }
                    .padding(.horizontal, 25).padding(.vertical, 14)
                    .background(steelGray.opacity(0.4)).cornerRadius(30)
                    .padding(.horizontal, 40).padding(.top, 30)

                    // MARK: - Credibility Card
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Credibility score").font(.system(size: 24, weight: .bold, design: .serif)).foregroundColor(navy)
                            Spacer()
                            HStack(spacing: 4) {
                                ForEach(1...5, id: \.self) { i in
                                    Image(systemName: starIcon(for: i)).font(.system(size: 22)).foregroundColor(navy)
                                }
                            }
                        }
                        Text(viewModel.rating?.credibility ?? (viewModel.errorMessage ?? "Awaiting source..."))
                            .font(.system(size: 20, weight: .medium, design: .serif)).foregroundColor(navy.opacity(0.8))
                        Spacer()
                    }
                    .padding(30).frame(maxWidth: .infinity, minHeight: 220)
                    .background(steelGray.opacity(0.4)).cornerRadius(5).padding(.horizontal, 25)

                    // MARK: - Biases Card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Biases").font(.system(size: 24, weight: .bold, design: .serif)).foregroundColor(navy)
                        Text(viewModel.rating?.bias ?? "N/A")
                            .font(.system(size: 20, weight: .medium, design: .serif)).foregroundColor(navy.opacity(0.8))
                        Spacer()
                    }
                    .padding(30).frame(maxWidth: .infinity, minHeight: 150)
                    .background(steelGray.opacity(0.4)).cornerRadius(5).padding(.horizontal, 25)
                }
            }
            Rectangle().fill(steelGray.opacity(0.4)).frame(height: 60).ignoresSafeArea()
        }
        .background(Color.white.ignoresSafeArea())
    }

    // FIX: Check "very high" BEFORE "high" so it doesn't get swallowed
    func starIcon(for i: Int) -> String {
        let fact = viewModel.rating?.factual?.lowercased() ?? ""
        var score = 0
        if fact.contains("very high") { score = 5 }
        else if fact.contains("mostly") { score = 3 }
        else if fact.contains("high") { score = 4 }
        else if fact.contains("mixed") { score = 2 }
        else if fact.contains("low") { score = 1 }
        return i <= score ? "star.fill" : "star"
    }

    func hideKeyboard() {
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }
}
