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
    @State private var isRedirected = false
    @State private var currUser: User? = nil
    @State var userAlreadyExists = false
    
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
                        setUsers(user) { success in
                            userAlreadyExists = success
                            currUser = user
                        }
                    }
                }
                .sheet(isPresented: $isRedirected) {
                    if let user = currUser {
                            if userAlreadyExists {
                                UserView(spotifyId: user.spotifyId).onAppear(){
                                    print($userAlreadyExists)
                                    print("Going to User View")
                                }
                            } else {
                                SignUpView(spotifyId: user.spotifyId).onAppear(){
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
