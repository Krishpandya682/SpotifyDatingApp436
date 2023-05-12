//
//  RecommendationSystem.swift
//  GroupApp436
//
//  Created by Vrundal Shah on 4/29/23.
//

import Foundation

//Return an array of count closest users spotifyUserId
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
            
            getUsers { (users, error) in
                if let error = error {
                    print("Error retrieving users: \(error.localizedDescription)")
                    return
                }
                
                if var users = users {
                    // remove the user from users
                    if let index = users.firstIndex(where: { $0.spotifyId == spotifyUserId }) {
                        users.remove(at: index)
                    }
                    
                    // remove users that dont fall in the ageLow and ageHigh limits of the user and gender preferences of the users don't work together
                    users = users.filter { user1 in
                        let isOkayUser1 = (user.genderPref == 2 || user.genderPref == user1.gender)
                        let isOkayUser = (user1.genderPref == 2 || user1.genderPref == user.gender)
                        
                        return user1.age >= user.ageLow && user1.age <= user.ageHigh && isOkayUser1 && isOkayUser
                    }
                    
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
        }
    }
    
    return closestUserIds
}
