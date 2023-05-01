//
//  RecommendationSystem.swift
//  GroupApp436
//
//  Created by Vrundal Shah on 4/29/23.
//

import Foundation

//Return an array of count closest users userId
func getClosestUsers(spotifyUserId:String, count: Int = 5) -> [String] {
    var closestUserIds: [String] = []
    var matchVal: Double = 0
    var disliked: [String] = []
    
    getUser(spotifyUserId) { (user, error) in
        if let error = error {
            print("Error retrieving user: \(error.localizedDescription)")
            return
        }
        
        if let user = user {
            // Use the retrieved user object
            matchVal = user.matchVal
            disliked = user.disliked
        }
    }
    
    getUsers { (users, error) in
        if let error = error {
            print("Error retrieving users: \(error.localizedDescription)")
            return
        }
        
        if let users = users {
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
                        closestUserIds.append(user.spotifyId)
                        
                        if closestUserIds.count == count {
                            break
                        }
                    }
                }
            
        }
    }
    return closestUserIds
}
