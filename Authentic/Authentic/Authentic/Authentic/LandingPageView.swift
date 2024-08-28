import SwiftUI

struct LandingPageView: View {
    private let quotes = [
        "Quote 1",
        "Quote 2",
        "Quote 3",
        "Quote 4"
    ]
    
    @State private var currentQuoteIndex = 0
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color("lpink").edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Welcome to")
                            .foregroundColor(Color("darkgray"))
                            .font(.custom("Lexend-Regular", size: 35))
                            .padding(.top, 20)
                            .padding(.leading, 30)
                        Text("Authentic.")
                            .foregroundColor(Color("darkgray"))
                            .font(.custom("Lexend-Bold", size: 40))
                            .padding(.leading, 30)
                            
                    }
                    Spacer()
                    
                }
                Image("landingStat")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 390, height: 550)
                    .padding(.top, -90)
                
                TabView(selection: $currentQuoteIndex) {
                    ForEach(0..<quotes.count, id: \.self) { index in
                        Text(self.quotes[index])
                            .tabItem { EmptyView() }
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 50)
                .onReceive(timer) { _ in
                    withAnimation {
                        currentQuoteIndex = (currentQuoteIndex + 1) % quotes.count
                    }
                }
                
                Button(action: {
                }) {
                    Text("Get Started")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("lighterpink"))
                        .cornerRadius(25)
                        .padding(.horizontal, 50)
                }
                Spacer()
            }
        }
        .onAppear {
            _ = self.timer
        }
    }
}

struct LandingPageView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPageView()
    }
}
