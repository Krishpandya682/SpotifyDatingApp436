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
    var disliked: [String]
    
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
        self.disliked = []
    }
    
    func toDictionary() -> [String: Any] {
        return[
            "spotifyId": self.spotifyId,
            "name": self.name,
            "imageName": self.imageName,
            "age": self.age,
            "description": self.description,
            "gender": self.gender,
            "genderPref": self.genderPref,
            "ageLow": self.ageLow,
            "ageHigh": self.ageHigh,
            "city": self.city,
            "state": self.state,
            "features": self.features,
            "matchVal": self.matchVal,
            "liked": self.liked,
            "matches": self.matches,
            "disliked": self.disliked
        ]
    }
}


func setUsers(_ val: User, completion: @escaping (Bool) -> Void) {
    FirestoreManager().createUser(userCard: val) { success in
        completion(success)
    }
}


func getUser(_ spotifyId:String, completion: @escaping (User?, Error?) -> Void) {
    print("getUsers called")
    FirestoreManager().getUser(spotifyId: spotifyId) { (user, error) in
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

func addLiked(spotifyUserId: String, likedSpotifyUserId: String) {
    
    getUser(spotifyUserId) { (u1, error) in
        if let error = error {
            // Handle the error
            print("errror retreiving user2")
        }
        
        if let user1 = u1 {
            
            getUser(likedSpotifyUserId) { (u2, error) in
                if let error = error {
                    // Handle the error
                    print("errror retreiving user2")
                }
                
                if let user2 = u2 {
                    var newLiked = user1.liked
                    
                    newLiked.append(likedSpotifyUserId)
                            
                    FirestoreManager().updateUser(spotifyId: spotifyUserId, data: ["liked": newLiked]) { (error3) in
                        if let error = error3 {
                            // Handle the error
                            print("Error updating user1: \(error.localizedDescription)")
                            return
                        }
                        
                            if user2.liked.contains(spotifyUserId) {
                                // They have liked each other
                                var newMatches1 = user1.matches
                                newMatches1.append(likedSpotifyUserId)
                                
                                var newMatches2 = user2.matches
                                newMatches2.append(spotifyUserId)
                                
                                FirestoreManager().updateUser(spotifyId: spotifyUserId, data: ["matches": newMatches1]) { (error4) in
                                    if let error = error4 {
                                        // Handle the error
                                        print("Error updating user1 matches: \(error.localizedDescription)")
                                        return
                                    }
                                }
                                
                                FirestoreManager().updateUser(spotifyId: likedSpotifyUserId, data: ["matches": newMatches2]) { (error5) in
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
    }
}

func addDisliked(spotifyUserId: String, dislikedSpotifyUserId: String) {
    getUser(spotifyUserId) { (u1, error) in
        if let error = error {
            // Handle the error
            print("error retrieving user1")
        }

        if var user1 = u1 {
            // Use the retrieved user object

            // Add disliked user to current user's dislike list
            user1.disliked.append(dislikedSpotifyUserId)

            // Update current user object in Firestore database
            let data: [String: Any] = ["disliked": user1.disliked]
            FirestoreManager().updateUser(spotifyId: spotifyUserId, data: data) { (error) in
                if let error = error {
                    print("Error updating current user: \(error.localizedDescription)")
                    return;
                } else {
                    print("Disliked user added successfully")
                }
            }
        }
    }
}
