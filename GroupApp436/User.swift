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
    let liked: [String]
    let matches: [String]
    
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
        self.liked = []
        self.matches = []
    }
}



func setUsers(_ val: User) {
    FirestoreManager().createUser(userCard: val)
}

func getUser(_ uid:String, completion: @escaping (User?, Error?) -> Void) {
    print("getUsers called")
    FirestoreManager().getUser(uid: uid) { (user, error) in
            if let error = error {
                // Handle the error
                completion(nil, error)
                return
            }
            
            if let user = user {
                // Use the retrieved user object
                completion(user, nil)
            }
        }
}

func getUsers(completion: @escaping ([User]?, Error?) -> Void) {
    FirestoreManager().getUsers { (users, error) in
        if let error = error {
            print("Error: \(error.localizedDescription)")
            completion(nil, error)
            return
        }

        guard let users = users else {
            print("No users found")
            completion(nil, nil)
            return
        }

        completion(users, nil)
    }
}

func calculateFeatures(spotifyUserId: String) -> Features {
    return Features(acousticness: 0, danceability: 0, duration_ms: 0, energy: 0, instrumentalness: 0, key: 0, liveness: 0, loudness: 0, mode: 0, speechiness: 0, tempo: 0, time_signature: 0)
}

func addLiked(spotifyUserId: String, likedUserId: String) {
    var usr2: User? = nil
    var usr1: User? = nil// TODO: current user needs to be a class, needs to be an instance with the val self.id or smth like that. improve the structure!!
    
    getUser(spotifyUserId) { (user, error) in
        if let error = error {
            // Handle the error
            print("errror retreiving user2")
        }
        
        if let user = user {
            // Use the retrieved user object
            usr1 = user
        }
    }
    
    getUser(likedUserId) { (user, error) in
        if let error = error {
            // Handle the error
            print("errror retreiving user2")
        }
        
        if let user = user {
            // Use the retrieved user object
            usr2 = user
        }
    }
    if let user1 = usr1 {
    var newLiked = user1.liked
                newLiked.append(likedUserId)
                
        FirestoreManager().updateUser(uid: spotifyUserId, data: ["liked": newLiked]) { (error3) in
            if let error = error3 {
                // Handle the error
                print("Error updating user1: \(error.localizedDescription)")
                return
            }
            
            if let user2 = usr2 {
                if user2.liked.contains(spotifyUserId) {
                    // They have liked each other
                    var newMatches1 = user1.matches
                    newMatches1.append(likedUserId)
                    
                    var newMatches2 = user2.matches
                    newMatches2.append(spotifyUserId)
                    
                    FirestoreManager().updateUser(uid: spotifyUserId, data: ["matches": newMatches1]) { (error4) in
                        if let error = error4 {
                            // Handle the error
                            print("Error updating user1 matches: \(error.localizedDescription)")
                            return
                        }
                    }
                    
                    FirestoreManager().updateUser(uid: likedUserId, data: ["matches": newMatches2]) { (error5) in
                        if let error = error5 {
                            // Handle the error
                            print("Error updating user2 matches: \(error.localizedDescription)")
                            return
                        }
                    }
                }
            }
        }
    }
    
}
