//
//  Card.swift
//  SpotifyDatingApp
//
//  Created by Krish Pandya on 4/24/23.
//

import SwiftUI
import FirebaseCore
import FirebaseDatabase

struct Features: Codable, Hashable {
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
    
//    func toDictionary() -> [String: Any] {
//        return [
//            "acousticness": acousticness,
//            "danceability": danceability,
//            "duration_ms": duration_ms,
//            "energy": energy,
//            "instrumentalness": instrumentalness,
//            "key": key,
//            "liveness": liveness,
//            "loudness": loudness,
//            "mode": mode,
//            "speechiness": speechiness,
//            "tempo": tempo,
//            "time_signature": time_signature
//        ]
//    }
}

struct User: Identifiable, Codable, Hashable {
    let id = UUID()
    let spotifyId : String
    let name: String
    let imageURL: String
    let age: Int
    let description: String
    let gender: Int //0 for male, 1 for female, 2 for other
    var genderPref: Int //0 for male, 1 for female, 2 for all
    var ageLow: Int
    var ageHigh: Int
//    let city: String
//    let state: String
    let zipcode: Int
    let features: Features
    let matchVal: Double
    let liked: [String]
    let matches: [String]
    var disliked: [String]
    var phoneNumber: Int
    var instagramUsername: String
    
    init(spotifyId: String, name: String, imageURL: String, age: Int, description: String, gender: Int, genderPref: Int, ageLow: Int, ageHigh: Int, zipcode: Int, phoneNumber: Int, features: Features, instagramUsername: String) {
        self.spotifyId = spotifyId
        self.name = name
        self.age = age
        self.description = description
        self.gender = gender
        self.genderPref = genderPref
        self.ageLow = ageLow
        self.ageHigh = ageHigh
//        self.city = city
//        self.state = state
        self.zipcode = zipcode
        self.features = features
        self.matchVal = calculateMatchVal(features: self.features)
        self.imageURL = imageURL
        self.phoneNumber = phoneNumber
        self.instagramUsername = instagramUsername
        self.liked = []
        self.matches = []
        self.disliked = []
    }
    
}


func setUser(_ val: User, completion: @escaping (Bool) -> Void) {
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
func calculateFeatures(accessToken: String, spotifyId: String, trackIds: [String]) -> Features {
    guard !trackIds.isEmpty else {
        return Features(acousticness: 0,
                        danceability: 0,
                        duration_ms: 0,
                        energy: 0,
                        instrumentalness: 0,
                        key: 0,
                        liveness: 0,
                        loudness: 0,
                        mode: 0,
                        speechiness: 0,
                        tempo: 0,
                        time_signature: 0)
    }

    var acousticness: Double = 0.0
    var danceability: Double = 0.0
    var duration_ms: Double = 0.0
    var energy: Double = 0.0
    var instrumentalness: Double = 0.0
    var key: Double = 0.0
    var liveness: Double = 0.0
    var loudness: Double = 0.0
    var mode: Double = 0.0
    var speechiness: Double = 0.0
    var tempo: Double = 0.0
    var time_signature: Double = 0.0

    let group = DispatchGroup()

    for trackId in trackIds {
        group.enter()

        storeSongFeatures(songID: trackId, accessToken: accessToken) { features in
            print("DEFINITIELLYYYY")
            print(features)

            if let features = features {
                acousticness += features.acousticness
                danceability += features.danceability
                duration_ms += features.duration_ms
                energy += features.energy
                instrumentalness += features.instrumentalness
                key += features.key
                liveness += features.liveness
                loudness += features.loudness
                mode += features.mode
                speechiness += features.speechiness
                tempo += features.tempo
                time_signature += features.time_signature
            }

            print("Acousticness: \(acousticness)")
            print("Danceability: \(danceability)")
            print("Duration_ms: \(duration_ms)")

            group.leave()
        }
    }

    group.wait()

    let count = Double(trackIds.count)
    let averageFeatures = Features(acousticness: acousticness / count,
                                   danceability: danceability / count,
                                   duration_ms: duration_ms / count,
                                   energy: energy / count,
                                   instrumentalness: instrumentalness / count,
                                   key: key / count,
                                   liveness: liveness / count,
                                   loudness: loudness / count,
                                   mode: mode / count,
                                   speechiness: speechiness / count,
                                   tempo: tempo / count,
                                   time_signature: time_signature / count)

    print("returning------------ \(averageFeatures)")
    return averageFeatures
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
                    print("added to liked ")
                            
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
                    print("Disliked user added successfully. \(user1.disliked)")
                }
            }
        }
    }
}

func setAgeHigh(spotifyId: String, ageHigh: Int) {
    let data: [String: Any] = ["ageHigh": ageHigh]
    
    FirestoreManager().updateUser(spotifyId: spotifyId, data: data) { (error) in
        if let error = error {
            print("Error updating current user: \(error.localizedDescription)")
            return;
        } else {
            print("modified ageHigh to \(ageHigh)")
        }
    }
}

func getAgeHigh(spotifyId: String, completion: @escaping (Int) -> Void) {
    FirestoreManager().getUser(spotifyId: spotifyId) { (user, error) in
        if let error = error {
            print("Error getting current user: \(error.localizedDescription)")
            return;
        }
        if let u = user {
            completion(u.ageHigh)
        }
    }
}

func setAgeLow(spotifyId: String, ageLow: Int) {
    let data: [String: Any] = ["ageLow": ageLow]
    
    FirestoreManager().updateUser(spotifyId: spotifyId, data: data) { (error) in
        if let error = error {
            print("Error updating current user: \(error.localizedDescription)")
            return;
        } else {
            print("modified ageLow to \(ageLow)")
        }
    }
}

func getAgeLow(spotifyId: String, completion: @escaping (Int) -> Void) {
    
    FirestoreManager().getUser(spotifyId: spotifyId) { (user, error) in
        if let error = error {
            print("Error getting current user: \(error.localizedDescription)")
            return;
        }
        if let u = user {
            completion(u.ageLow)
        }
    }
}

func setGenderPref(spotifyId: String, pref: Int) {
    let data: [String: Any] = ["genderPref": pref]
    
    FirestoreManager().updateUser(spotifyId: spotifyId, data: data) { (error) in
        if let error = error {
            print("Error updating current user: \(error.localizedDescription)")
            return;
        } else {
            print("Disliked user added successfully")
        }
    }
}

func getGenderPref(spotifyId: String, completion: @escaping (Int) -> Void) {
    FirestoreManager().getUser(spotifyId: spotifyId) { (user, error) in
        if let error = error {
            print("Error getting current user: \(error.localizedDescription)")
            return;
        }
        if let u = user {
            completion(u.genderPref)
        }
    }
}

func getLiked(spotifyId: String, completion: @escaping ([String]) -> Void) {
    getUser(spotifyId) { (user, error) in
        if let err = error {
            completion([])
        }
        
        if let u = user {
            completion(u.liked)
        }
    }
}
