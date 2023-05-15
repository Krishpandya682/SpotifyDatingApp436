//
//  SpotifyDatingAppApp.swift
//  SpotifyDatingApp
//
//  Created by Krish Pandya on 4/24/23.
//

import SwiftUI
import Firebase
//
//@main
//struct GroupApp436App: App {
//    @StateObject var firestoreManager: FirestoreManager = FirestoreManager()
//    @StateObject var recommendationSystem = RecommendationSystem()
//    @State private var isRedirected = false
//    @State private var currUser: User? = nil
//    @State var userAlreadyExists = false
//    @State var userSignedUp = false
////    @State private var closestUsers: [User] = []
//
//    init() {
//        FirebaseApp.configure()
//    }

//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .onOpenURL { url in
//                    // Handle the redirect URL here
//                    print("Redirected to app with URL: \(url)")
//                    self.isRedirected = true
//                    createUserProfile(url: url) { user in
//                        setUser(user) { success in
//                            print("ustrdtrfhg")
//                            userAlreadyExists = success
//                            currUser = user
//                        }
//                    }
//                }
//                .sheet(isPresented: $isRedirected) {
//                    if let user = currUser {
//                            if userAlreadyExists {
//                                SignedInPages(currUser: $currUser).environmentObject(recommendationSystem)
//                            } else {
//                                SignUpView(spotifyId: user.spotifyId).environmentObject(firestoreManager).environmentObject(recommendationSystem).onAppear(){
//                                    print($userAlreadyExists)
//                                    print("Going to Signup View")
//                                }
//                            }
//                    } else {
////                        Text("Error: User not found")
////                            .foregroundColor(.red)
//                    }
//                }.padding(40)
//        }
//    }
//}

@main
struct GroupApp436App: App {
    @StateObject var firestoreManager: FirestoreManager = FirestoreManager()
    @StateObject var recommendationSystem = RecommendationSystem()
    @State private var isRedirected = false
    @State private var currUser: User? = nil
    @State var userAlreadyExists = false
    @State var isUserSignedUp = false

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if let user = currUser {
                if isUserSignedUp {
                    SignedInPages(currUser: $currUser).environmentObject(recommendationSystem)
                } else {
                    SignUpView(isUserSignedUp: self.$isUserSignedUp, spotifyId: user.spotifyId)
                        .environmentObject(firestoreManager)
                        .environmentObject(recommendationSystem)
                        .onAppear() {
                            print(userAlreadyExists)
                            print("Going to Signup View")
                        }
                }
            } else {
                ContentView()
                    .onOpenURL { url in
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
                    .padding(40)
            }
        }
    }
}
