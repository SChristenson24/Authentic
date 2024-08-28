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
                            .font(.custom("Lexend-Regular", size: 35))
                            .padding(.leading, 20)
                            .padding(.top, 22290)
                        Text("Authentic.")
                            .font(.custom("Lexend-SemiBold", size: 40))
                            .padding(.leading, 20)
                            //.padding(.top, 40)
                            
                    }
                    Spacer()
                    
                }
                Image("landingStat")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 600)
                
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
