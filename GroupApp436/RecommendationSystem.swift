//
//  RecommendationSystem.swift
//  GroupApp436
//
//  Created by Vrundal Shah on 4/29/23.
//

import Foundation

//Return an array of 5/10 closest users userId
func getClosestUsers(spotifyUserId:String, count: Int = 5) -> [UUID] {
    var closestUserIds: [UUID] = []
    var matchVal: Double = 0
    
    getUser(spotifyUserId) { (user, error) in
        if let error = error {
            print("Error retrieving user: \(error.localizedDescription)")
            return
        }
        
        if let user = user {
            // Use the retrieved user object
            matchVal = user.matchVal
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
            closestUserIds = sortedUsers.prefix(count).map {$0.id}
            
        }
    }
    return closestUserIds
}
