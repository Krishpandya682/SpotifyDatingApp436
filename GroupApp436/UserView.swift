//
//  UserView.swift
//  SpotifyDatingApp
//
//  Created by Krish Pandya on 4/25/23.
//

import Foundation
import SwiftUI

func calculateMatchVal(features: Features) -> Double{
    (features.acousticness+features.danceability+features.duration_ms+features.energy+features.instrumentalness+features.key+features.liveness+features.loudness+features.mode+features.speechiness+features.tempo+features.time_signature)/13
}
struct UserView: View {
    let spotifyId: String
    @State private var user: User? = nil
    
    var body: some View {
        VStack {
            if let user = user {
                Text("Welcome to the Spotify Matchmaking App, \(user.name)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
            } else {
                Text("Loading user...")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
            }
        }
        .onAppear {
            getUser(spotifyId) { (user, error) in
                if let error = error {
                    print("Error retrieving user: \(error.localizedDescription)")
                    return
                }
                
                if let user = user {
                    self.user = user
                }
            }
        }
    }
}
