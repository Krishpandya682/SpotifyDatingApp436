//
//  Card.swift
//  SpotifyDatingApp
//
//  Created by Krish Pandya on 4/24/23.
//

import SwiftUI
import FirebaseCore
import FirebaseDatabase

struct Features: Codable{
        let acousticness: Double
        let danceability: Double
        let duration_ms: Double
        let energy: Double
        let instrumentalness: Double
        let key: Double
        let liveness: Double
        let loudness: Double
        let mode: Double
        let speechiness: Double
        let tempo: Double
        let time_signature: Double
}

struct User: Identifiable, Codable {
    let id = UUID()
    let spotifyId : String
    let name: String
    let imageName: String
    let age: Int
    let description: String
    let gender: Int //0 for male, 1 for female, 2 for other
    let genderPref: Int //0 for male, 1 for female, 2 for all
    let ageLow: Int
    let ageHigh: Int
    let city: String
    let state: String
    let features: Features
    let matchVal: Double
    
    init(spotifyId: String, name: String, imageName: String, age: Int, description: String, gender: Int, genderPref: Int, ageLow: Int, ageHigh: Int, city: String, state: String) {
        self.spotifyId = spotifyId
        self.name = name
        self.imageName = imageName
        self.age = age
        self.description = description
        self.gender = gender
        self.genderPref = genderPref
        self.ageLow = ageLow
        self.ageHigh = ageHigh
        self.city = city
        self.state = state
        self.features = calculateFeatures(spotifyUserId: spotifyId)
        self.matchVal = calculateMatchVal(features: self.features)
    }
}

func setUsers(_ val: User) {
    
    FirestoreManager().createUser(userCard: val)
}

func getUsers(_ uid:String){
    print("HIIIII")
    FirestoreManager().getUsers(uid: uid)
}
