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
    let tempFeatures = Features(acousticness: 0, danceability: 0, duration_ms: 0, energy: 0, instrumentalness: 0, key: 0, liveness: 0, loudness: 0, mode: 0, speechiness: 0, tempo: 0, time_signature: 0)
    let tempUser = User(spotifyId: "626E5AC0-122B-45D4-91D0-6C44396AE5E8",
                    name: "Krish", imageName: "i1", age: 20,
                    description: "This is my test description", gender: 0, genderPref: 1, ageLow: 18, ageHigh: 25, city: "College Park", state: "MD")
    
    var body: some View {
        Button(action: {setUsers(tempUser)}){
            Text("Write")
        }
        Button(action: {getUsers("626E5AC0-122B-45D4-91D0-6C44396AE5E8")}){
            Text("Read")
        }

            }
     
}


