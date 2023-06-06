//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Fauzan Dwi Prasetyo on 01/06/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
//    @State private var showingScore = false
    @State private var isFinal = false
//    @State private var scoreTitle = ""
    
    @State private var score = 0
    @State private var countChoose = 0
    private var life = 3
    
    // animations
    @State private var spinAnimationAmounts = [0.0, 0.0, 0.0]
    
    var body: some View {
        
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            // full body
            VStack {
                Spacer()
                
                // title section
                Text("Guess The Flag")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                
                // main guess flag
                ZStack {
                    VStack(spacing: 15) {
                        VStack {
                            Text("Tap the flag of")
                                .foregroundStyle(.secondary)
                                .font(.subheadline.weight(.heavy))
                            Text(countries[correctAnswer])
                                .font(.largeTitle.weight(.semibold))
                        }
                        
                        ForEach(0..<3) { number in
                            Button {
                                flaggedTapped(number)
                            } label: {
                                // MARK: - Challenge 2 Project3
                                FlagImage(name: countries[number])
                            }
                            .rotation3DEffect(.degrees(spinAnimationAmounts[number]), axis: (x: 0, y: 1, z: 0))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                // score section
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
//        .alert(scoreTitle, isPresented: $showingScore) {
//            Button("Continue") {
//                askQuestion()
//                if countChoose == life { isFinal = true }
//            }
//        } message: {
//            Text("Your score is \(score)")
//        }
        .alert("Finish", isPresented: $isFinal) {
            Button("Restart") { restart() }
        } message: {
            Text("Your Final Score is \(score)")
        }
    }
    
    func flaggedTapped(_ number: Int) {
        countChoose += 1

        if number == correctAnswer {
//            scoreTitle = "Correct"
            score += 1
            
            withAnimation(.spring(dampingFraction: 1)) {
                spinAnimationAmounts[number] += 360
            }
        } else {
//            scoreTitle = "Wrong!\n That's the flag of \(countries[number])"
        }

        
//        showingScore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if countChoose == life {
                isFinal = true
            } else {
                askQuestion()
            }
        }
        
    }
    
    func askQuestion() {
        self.spinAnimationAmounts = [0.0, 0.0, 0.0]
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func restart() {
        score = 0
        countChoose = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}


// MARK: - Challenge 2 Project3

struct FlagImage: View {
    var name: String
    
    var body: some View {
        Image(name)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
