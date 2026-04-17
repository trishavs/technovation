import SwiftUI

struct BiasCheckerView: View {
    @StateObject var viewModel = BiasViewModel()
    @State private var domainInput: String = ""
    @Environment(\.dismiss) var dismiss
    
    // Veritas Palette
    let navy = Color(red: 0/255, green: 19/255, blue: 62/255)
    let steelGray = Color(red: 154/255, green: 166/255, blue: 178/255)
    let lightPeriwinkle = Color(red: 236/255, green: 236/255, blue: 255/255) // #ECEAFF
    let darkGray = Color(red: 60/255, green: 60/255, blue: 67/255)

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            HStack(alignment: .bottom) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(navy)
                }
                Spacer()
                VStack(spacing: 4) {
                    HStack(spacing: 15) {
                        Rectangle().fill(steelGray.opacity(0.5)).frame(width: 80, height: 4)
                        Rectangle().fill(steelGray.opacity(0.5)).frame(width: 40, height: 4)
                    }
                    HStack(alignment: .top, spacing: 0) {
                        Text("Veritas")
                            .font(.system(size: 34, weight: .regular, design: .serif))
                            .italic()
                            .foregroundColor(navy)
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20))
                            .foregroundColor(steelGray)
                            .offset(x: -5, y: 5)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)

            // MARK: - Search Pill
            HStack {
                TextField("paste url here....", text: $domainInput)
                    .font(.system(size: 18, design: .serif))
                    .foregroundColor(.white)
                    .accentColor(.white)
                
                if viewModel.isLoading {
                    ProgressView().tint(.white)
                } else {
                    Button(action: {
                        hideKeyboard()
                        viewModel.checkBias(for: domainInput)
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 14)
            .background(navy)
            .cornerRadius(30)
            .padding(.horizontal, 40)
            .padding(.top, 25)

            ScrollView {
                if !viewModel.summary.isEmpty {
                    VStack(spacing: 20) {
                        // Credibility Card (White)
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Credibility Analysis")
                                    .font(.system(size: 24, weight: .bold, design: .serif))
                                    .foregroundColor(navy)
                                Spacer()
                                // Dynamic Stars Fix
                                HStack(spacing: 2) {
                                    ForEach(1...5, id: \.self) { i in
                                        Image(systemName: i <= viewModel.factualScore ? "star.fill" : "star")
                                            .foregroundColor(navy)
                                            .font(.system(size: 18))
                                    }
                                }
                            }
                            
                            Text(viewModel.summary)
                                .font(.system(size: 18, design: .serif))
                                .lineSpacing(4)
                                .foregroundColor(darkGray)
                        }
                        .padding(25)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 10)
                        .padding(.horizontal)

                        // Ideological Leaning Card (Periwinkle)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Ideological Leaning")
                                .font(.system(size: 24, weight: .bold, design: .serif))
                                .foregroundColor(navy)
                            
                            Text(viewModel.biasDescription)
                                .font(.system(size: 18, design: .serif))
                                .lineSpacing(4)
                                .foregroundColor(navy)
                        }
                        .padding(25)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(lightPeriwinkle)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    .padding(.top, 25)
                }
            }
            
            Spacer()
            
            Rectangle()
                .fill(steelGray.opacity(0.3))
                .frame(height: 60)
                .ignoresSafeArea()
        }
        .background(Color.white.ignoresSafeArea())
    } // End of body

    // MARK: - Helpers
    func hideKeyboard() {
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }
} // End of Struct
