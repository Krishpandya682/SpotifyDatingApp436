//
//  UserView.swift
//  SpotifyDatingApp
//
//  Created by Krish Pandya on 4/25/23.
//

import Foundation
import SwiftUI

func normalize(featureValue: Double, min: Double, max: Double) -> Double {
    let normalizedValue = (featureValue - min) / (max - min)
    return normalizedValue
}

func calculateMatchVal(features: Features) -> Double {
    // Normalize each feature based on its respective range
    
    let normalizedAcousticness = normalize(featureValue: features.acousticness, min: 0.0, max: 1.0)
    let normalizedDanceability = normalize(featureValue: features.danceability, min: 0, max: 1)
    let normalizedDuration = normalize(featureValue: features.duration_ms, min: 0, max: 300000) // Example range for duration_ms
    let normalizedEnergy = normalize(featureValue: features.energy, min: 0, max: 1)
    let normalizedInstrumentalness = normalize(featureValue: features.instrumentalness, min: 0, max: 1)
    let normalizedKey = normalize(featureValue: features.key, min: -1, max: 11) // Example range for key
    let normalizedLiveness = normalize(featureValue: features.liveness, min: 0, max: 1)
    let normalizedLoudness = normalize(featureValue: features.loudness, min: -60, max: 0) // Example range for loudness
    let normalizedMode = normalize(featureValue: features.mode, min: 0, max: 1)
    let normalizedSpeechiness = normalize(featureValue: features.speechiness, min: 0, max: 1)
    let normalizedTempo = normalize(featureValue: features.tempo, min: 0, max: 200) // Example range for tempo
    let normalizedTimeSignature = normalize(featureValue: features.time_signature, min: 3, max: 7) // Example range for time_signature
    
    // Calculate the sum of normalized features
    let sumOfNormalizedFeatures = normalizedAcousticness + normalizedDanceability + normalizedDuration + normalizedEnergy + normalizedInstrumentalness + normalizedKey + normalizedLiveness + normalizedLoudness + normalizedMode + normalizedSpeechiness + normalizedTempo + normalizedTimeSignature
    
    // Divide by the number of normalized features to get the match value
    let matchValue = sumOfNormalizedFeatures / 12.0 // Total number of features
    
    return matchValue
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
