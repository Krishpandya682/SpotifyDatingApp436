//
//  ContentView.swift
//  SpotifyDatingApp
//
//  Created by Krish Pandya on 4/24/23.
//

import SwiftUI


struct ContentView: View {
    
    
    @EnvironmentObject var spotifyAuthManager: SpotifyAuthManager
    
    var body: some View {
        VStack {
            LoginView()

        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
