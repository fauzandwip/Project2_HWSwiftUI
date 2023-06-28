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
    @State private var wrongCountry = ""
    
    @State private var isFinal = false
    @State private var score = 0
    @State private var tapCount = 0
    private var life = 8
    
    // animations
    @State private var spinAnimationAmounts = [0.0, 0.0, 0.0]
    @State private var shakeAnimationAmounts = [0.0, 0.0, 0.0]
    @State private var shouldShake = false
    
    @State private var animateOpacity = false
    @State private var animateScore = false
    @State private var animateWrong = false
    
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
                            .opacity(animateOpacity ? (number == correctAnswer ? 1 : 0.25) : 1)
                            .rotationEffect(shouldShake ? .degrees(shakeAnimationAmounts[number]) : .degrees(0))
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
                ZStack {
                    Text("Score: \(score)")
                        .foregroundColor(animateScore ? (animateWrong ? .red : .green) : .white)
                        .font(.title.bold())
                }
                
                Spacer()
                
                Text("That was \(wrongCountry)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .opacity(animateWrong ? 1 : 0)
                
            }
            .padding()
        }
        .alert("Finish", isPresented: $isFinal) {
            Button("Restart") { restart() }
        } message: {
            Text("Your Final Score is \(score)")
        }
    }
    
    func flaggedTapped(_ number: Int) {
        tapCount += 1
        
        withAnimation(.easeOut(duration: 0.5)) {
            animateOpacity = true
        }

        if number == correctAnswer {
            score += 1
            
            withAnimation(.spring(dampingFraction: 1)) {
                self.spinAnimationAmounts[number] += 360
            }
            
            withAnimation {
                animateScore = true
                animateWrong = false
            }
        } else {
            withAnimation(.easeOut(duration: 0.1).repeatCount(5)) {
                shouldShake = true
                shakeAnimationAmounts[number] = 10
            }
            
            withAnimation {
                animateScore = true
                animateWrong = true
            }
            
            withAnimation {
                wrongCountry = countries[number]
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeOut(duration: 0.1)) {
                    shouldShake = false
                }
            }
            
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.tapCount == self.life {
                self.isFinal = true
            } else {
                self.askQuestion()
            }
        }
        
    }
    
    func askQuestion() {
        animateOpacity = false
        spinAnimationAmounts = [0.0, 0.0, 0.0]
        shakeAnimationAmounts = [0.0, 0.0, 0.0]
        animateScore = false
        animateWrong = false
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func restart() {
        score = 0
        tapCount = 0
        
        askQuestion()
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
