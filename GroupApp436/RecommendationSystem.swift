//
//  RecommendationSystem.swift
//  GroupApp436
//
//  Created by Vrundal Shah on 4/29/23.
//

import Foundation

class RecommendationSystem: ObservableObject {
    @Published var finalClosestUsers: [User] = []
    @Published var noClosestUsers: Bool = false
    @Published var finalMatches: [User] = []
    @Published var noMatches: Bool = false
    
    //Return an array of count closest users spotifyUserId
    func getClosestUsers(spotifyUserId:String, count: Int = 5) {
        var closestUsers: [User] = []
        var matchVal: Double = 0
        var disliked: [String] = []
        
        getUser(spotifyUserId) { (user, error) in
            if let error = error {
                print("Error retrieving user: \(error.localizedDescription)")
                self.noClosestUsers = true
            }
            
            if let user = user {
                // Use the retrieved user object
                matchVal = user.matchVal
                disliked = user.disliked
                
                getUsers { (users, error) in
                    if let error = error {
                        print("Error retrieving users: \(error.localizedDescription)")
                        self.noClosestUsers = true
                    }
                    
                    if var users = users {
                        print("got userrs")
                        // remove the user from users
                        if let index = users.firstIndex(where: { $0.spotifyId == spotifyUserId }) {
                            users.remove(at: index)
                        }
                        
                        print("before filtering \(users.count)")
                        // remove users that dont fall in the ageLow and ageHigh limits of the user and gender preferences of the users don't work together
                        users = users.filter { user1 in
                            let isOkayUser1 = (user.genderPref == 2 || user.genderPref == user1.gender)
                            let isOkayUser = (user1.genderPref == 2 || user1.genderPref == user.gender)
                            
                            return !user.liked.contains(user1.spotifyId) && user1.age >= user.ageLow && user1.age <= user.ageHigh && isOkayUser1 && isOkayUser
                        }
                        
                        print("filtered \(users.count)")
                        // Sort the users by distance to the specified user
                        let sortedUsers = users.sorted { (user1, user2) -> Bool in
                            // Calculate the distance between user1 and spotifyUserId
                            let distance1 = matchVal - user1.matchVal
                            // Calculate the distance between user2 and spotifyUserId
                            let distance2 = matchVal - user2.matchVal
                            
                            return distance1 < distance2
                        }
                        
                        // Get the closest 'count' number of users
                        for user in sortedUsers {
                            if !disliked.contains(user.spotifyId) {
                                closestUsers.append(user)
                                
                                if closestUsers.count == count {
                                    break
                                }
                            }
                        }
                        
                        if closestUsers.isEmpty {
                            self.noClosestUsers = true
                        } else {
                            self.finalClosestUsers = closestUsers
                        }
                    }
                }
            }
        }
    }
    
    func getMatches(spotifyId: String) {
        print("inside getMatches")
        var matchedUsers: [User] = []
        
        getUser(spotifyId) { (user, error) in
            if let err = error {
                print("inside getMatches, failed to fetch user: \(err.localizedDescription)")
//                completion([])
            }
            
            if let u = user {
                print("matches count: \(u.matches.count)")
                
                for i in 0..<u.matches.count {
                    let currSpotifyId = u.matches[i]
                    print("currentSpotifyId: \(currSpotifyId)")
                    
                    getUser(currSpotifyId) { (user, error) in
                        if let err = error {
                            print("inside getMatches, failed to fetch user: \(err.localizedDescription)")
//                            completion([])
                        }
                        
                        if let u1 = user {
                            print("matched user is appended")
                            matchedUsers.append(u1)
                            print("matched users count: \(matchedUsers.count)")
                            
                            if matchedUsers.count == (u.matches.count) && matchedUsers.count == 0 {
                                print("noMastches set true")
                                self.noMatches = true
                            } else if matchedUsers.count == (u.matches.count) {
                                self.finalMatches = matchedUsers
                                print("matchedUser.count: \(matchedUsers.count), u1.name: \(u1.name), u.matches.count: \(u.matches.count-1)")
                                print("final matches updated with \(self.finalMatches.count) values and matchedUser.count = \(matchedUsers.count)")
                            }
                        }
                    }
                }
                if u.matches.count == 0 {
                    self.noMatches = true
                }
            }
        }
    }

}
