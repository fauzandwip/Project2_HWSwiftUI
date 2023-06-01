//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Fauzan Dwi Prasetyo on 01/06/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingAlert = false
    
    var body: some View {
        
        // MARK: - Alert Messages
        
        Button("Show Alert") {
            showingAlert = true
        }
        .alert("Important Message", isPresented: $showingAlert) {
            Button("OK", role: .destructive) {}
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Please read this.")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
