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
    
    @StateObject var authManager = SpotifyAuthManager()
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
