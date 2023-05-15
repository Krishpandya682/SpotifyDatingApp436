//
//  SpotifyDatingAppApp.swift
//  SpotifyDatingApp
//
//  Created by Krish Pandya on 4/24/23.
//

import SwiftUI
import Firebase

@main
struct GroupApp436App: App {
    @StateObject var firestoreManager: FirestoreManager = FirestoreManager()
    @StateObject var recommendationSystem = RecommendationSystem()
    @State private var isRedirected = false
    @State private var currUser: User? = nil
    @State var userAlreadyExists = false
    private var userList: [User] = [
        User(spotifyId: "1234567890", name: "Alice",imageURL: "https://skateparkoftampa.com/spot/headshots/4322.jpg", age: 23, description: "I'm a musician and love to play guitar", gender: 1, genderPref: 0, ageLow: 20, ageHigh: 28, city: "New York", state: "NY", phoneNumber: 9999999999, instagramUsername: "unplugged_verses"),
        User(spotifyId: "0987654321", name: "Bob", imageURL: "https://skateparkoftampa.com/spot/headshots/4322.jpg", age: 30, description: "I'm a software engineer and love to code", gender: 0, genderPref: 1, ageLow: 25, ageHigh: 35, city: "San Francisco", state: "CA", phoneNumber: 9999999999, instagramUsername: "unplugged_verses"),
        User(spotifyId: "2468101214", name: "Charlie", imageURL: "https://skateparkoftampa.com/spot/headshots/4322.jpg", age: 28, description: "I'm a photographer and love to take pictures", gender: 2, genderPref: 2, ageLow: 25, ageHigh: 30, city: "Los Angeles", state: "CA", phoneNumber: 9999999999, instagramUsername: "unplugged_verses"),
        User(spotifyId: "2468101216", name: "Puth", imageURL: "https://skateparkoftampa.com/spot/headshots/4322.jpg", age: 28, description: "I'm a photographer and love to take pictures", gender: 2, genderPref: 2, ageLow: 25, ageHigh: 30, city: "Los Angeles", state: "CA", phoneNumber: 9999999999, instagramUsername: "unplugged_verses"),
        User(spotifyId: "2468101216", name: "Pat", imageURL: "https://skateparkoftampa.com/spot/headshots/4322.jpg", age: 28, description: "I'm a photographer and love to take pictures", gender: 2, genderPref: 2, ageLow: 25, ageHigh: 30, city: "Los Angeles", state: "NY", phoneNumber: 9999999999, instagramUsername: "unplugged_verses")
    ]
    @State private var closestUsers: [User] = []
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    // Handle the redirect URL here
                    print("Redirected to app with URL: \(url)")
                    self.isRedirected = true
                    createUserProfile(url: url) { user in
                        setUser(user) { success in
                            print("ustrdtrfhg")
                            userAlreadyExists = success
                            currUser = user
                        }
                    }
                }
                .sheet(isPresented: $isRedirected) {
                    if let user = currUser {
                            if userAlreadyExists {
//                                UserView(spotifyId: user.spotifyId).onAppear(){
//                                    print($userAlreadyExists)
//                                    print("Going to User View")
//                                }
                                SignedInPages(currUser: $currUser).environmentObject(recommendationSystem)
                            } else {
                                SignUpView(spotifyId: user.spotifyId).environmentObject(firestoreManager).environmentObject(recommendationSystem).onAppear(){
                                    print($userAlreadyExists)
                                    print("Going to Signup View")
                                }
                            }
                    } else {
                        Text("Error: User not found")
                            .foregroundColor(.red)
                    }
                }
        }
    }
}
