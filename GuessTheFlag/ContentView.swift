//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by k.patrick on 20/4/2567 BE.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content:Content) -> some View {
        content
            .font(.largeTitle.weight(.bold))
            .foregroundColor(.white)
    }
}
extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct FlagImage: View {
    var image:String
    
    var body: some View {
        Image(image)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var country =  ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Spain", "UK", "US"].shuffled()
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes. Top stripe blue, middle stripe black, bottom stripe white.",
        "France": "Flag with three vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
        "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe red, bottom stripe gold.",
        "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
        "Italy": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe red.",
        "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe green.",
        "Poland": "Flag with two horizontal stripes. Top stripe white, bottom stripe red.",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red.",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background.",
        "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
        "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner."
    ]
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var animationAmount = 0.0
    @State private var tapFlag:Int?
    @State private var opacityAmount = 1.0
    @State private var scaleAmount = 1.0
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.3, green: 0.2, blue: 0.45), location: 0.3),
                .init(color:Color( red: 0.89, green: 0.65, blue: 0.2), location: 0.3)
            ], center: .top, startRadius: 225, endRadius: 700)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess The Flag")
                    .titleStyle()
                VStack(spacing: 15){
                    VStack{
                        Text("Tap The Frag Of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(country[correctAnswer])
                            .foregroundStyle(.black)
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3){ number in
                        Button {
                            withAnimation{
                                animationAmount += 360
                                tapFlag = number
                                opacityAmount = tapFlag == nil ? 1 : 0.5
                                scaleAmount = tapFlag == nil ? 1 : 0.7
                            }
                            flagTap(number)

                        } label: {
                            FlagImage(image:country[number])
                                .accessibilityLabel(labels[country[number], default: "Unknown flag"])
                                .rotation3DEffect(
                                    .degrees(tapFlag == number ? animationAmount : 0),axis: (x: 0.0, y: 1.0, z: 0.0))
                                .opacity(tapFlag == number ? 1 : opacityAmount)
                                .scaleEffect(tapFlag == number ? 1 : scaleAmount)
                                .animation(.default, value: tapFlag)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .fontDesign(.default)
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Countinue", action: askQuestion)
        } message: {
            Text("Your score now is \(score)")
                
        }
    }
    
    func flagTap(_ number:Int){
        if number == correctAnswer {
            scoreTitle = "Corrrect"
            score += 1
        } else {
            scoreTitle = "Wrong"
            score -= 1
        }
        showingScore = true
    }
    
    func askQuestion() {
        country.shuffle()
        correctAnswer = Int.random(in: 0...2)
        tapFlag = nil
        opacityAmount = 1
        scaleAmount = 1
    }
}
#Preview {
    ContentView()
}
