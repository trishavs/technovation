import SwiftUI

struct ContentView: View {
    // Signature colors
    let deepNavy = Color(red: 0/255, green: 19/255, blue: 62/255)
    let steelGray = Color(red: 154/255, green: 166/255, blue: 178/255)
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Top Decorative Bars
                HStack(spacing: 20) {
                    Rectangle()
                        .fill(steelGray.opacity(0.5))
                        .frame(height: 6)
                    Rectangle()
                        .fill(steelGray.opacity(0.5))
                        .frame(height: 6)
                }
                .padding(.horizontal, 40)
                .padding(.top, 40)
                
                Spacer()
                
                // MARK: - Template Logo Section
                // Restored to the simple, clean look from your reference image
                ZStack {
                    Text("Veritas")
                        .font(.custom("Snell Roundhand", size: 90))
                        .fontWeight(.bold)
                        .foregroundColor(deepNavy)
                    
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 130)
                        .foregroundColor(steelGray.opacity(0.7))
                        .fontWeight(.light)
                        // Adjusted offset to circle the 'as' naturally
                        .offset(x: 65, y: 10)
                }
                .padding(.bottom, 60)
                
                // MARK: - Navigation Buttons
                VStack(spacing: 18) {
                    navButton(title: "Bias Checker", destination: BiasCheckerView().navigationBarBackButtonHidden(true))
                    
                    navButton(title: "Education", destination: EducationView().navigationBarBackButtonHidden(true))
                    
                    navButton(title: "News Direction", destination: NewsDirectionView())
                    
                }
                .padding(.horizontal, 50)
                
                Spacer()
                
                // MARK: - Bottom Bar
                Rectangle()
                    .fill(steelGray.opacity(0.3))
                    .frame(height: 50)
                    .ignoresSafeArea()
            }
            .background(Color.white)
        }
    }
    
    @ViewBuilder
    func navButton<Target: View>(title: String, destination: Target) -> some View {
        NavigationLink(destination: destination) {
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .serif))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(steelGray)
                .foregroundColor(deepNavy)
                .cornerRadius(25)
        }
    }
}


// MARK: - Placeholder View for Education and Mini-Games
struct BlankView: View {
    var title: String
    @Environment(\.dismiss) var dismiss
    
    // Colors to match your theme
    let deepNavy = Color(red: 0/255, green: 19/255, blue: 62/255)
    let steelGray = Color(red: 154/255, green: 166/255, blue: 178/255)
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(deepNavy)
            
            Spacer()
            
            Button(action: {
                dismiss()
            }) {
                Text("Back to Main")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(steelGray)
                    .foregroundColor(deepNavy)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
    }
}
