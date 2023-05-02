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
    @State private var currUser : User? = nil
    @State var userAlreadyExists = false
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                                   // Handle the redirect URL here
                                    print("Redirected to app with URL: \(url)")
                                    self.isRedirected = true
//                                    handleAuthorizationRedirect(url: url)


                    createUserProfile(url: url){
                        user in userAlreadyExists = setUsers(user)
                    }

                               }
                .sheet(isPresented: $isRedirected) {
                                   // Show a sheet or perform any other action upon redirect
                                    UserView()
                               }
        }
    }
}
//
//func handleAuthorizationRedirect(url: URL) {
//    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
//          let queryItems = components.queryItems,
//          let authorizationCode = queryItems.first(where: { $0.name == "code" })?.value else {
//        print("Failed to extract authorization code from URL")
//        return
//    }
//
//    getToken(withCode: authorizationCode) { (accessToken, error) in
//        if let accessToken = accessToken {
//            print("Access token: \(accessToken)")
//            
//            // Call getCurrentUserProfile function to get the current user's profile
//            getCurrentUserProfile(withAccessToken: accessToken) { (profile, error) in
//                if let profile = profile {
//                    print("User profile: \(profile)")
//                } else if let error = error {
//                    print("Error getting user profile: \(error.localizedDescription)")
//                }
//            }
//        } else if let error = error {
//            print("Error getting access token: \(error.localizedDescription)")
//        }
//    }
//}
