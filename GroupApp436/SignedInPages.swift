//
//  SignedInPages.swift
//  GroupApp436
//
//  Created by Vrundal Shah on 5/14/23.
//

import SwiftUI

struct SignedInPages: View {
    @State private var selectedTab = 0
    @Binding var currUser: User?
    @EnvironmentObject var recommendationSystem: RecommendationSystem
    @State var closestUsers: [User] = []
    @State var noClosestUsers = false
    @State var matchedUsers: [User] = []
    @State var noMatches = false
    
    var body: some View {
        if let user = currUser {
            TabView(selection: $selectedTab) {
                UserPreferencesView(userOpt: $currUser, selectedTab: self.$selectedTab)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Preferences")
                    }
                    .tag(0)
                
                VStack {
                    if closestUsers.isEmpty {
                        if noClosestUsers {
                            Text("No closest Users :(, We will be on the look out for more matches. Try again tomorrow!")
                        } else {
                            // show a loading indicator while fetching closest users
                            ProgressView()
                        }
                    } else {
                        ZStack {
                            Text("You have run out of swipes")
                            ForEach(closestUsers.reversed(), id: \.self) { u in
                                CardView(signedUserSpotifyId: user.spotifyId, user: u)
                            }
                            
                        }
                    }
                }
                .onChange(of: selectedTab) { newValue in
                    // fetch closest users when the Swipe tab is selected
                    if newValue == 1 {
                        recommendationSystem.getClosestUsers(spotifyUserId: user.spotifyId)
                    }
                }
//                .onAppear {
//                    // fetch closest users when the view appears
//                    recommendationSystem.getClosestUsers(spotifyUserId: user.spotifyId)
//                }
                .onChange(of: recommendationSystem.finalClosestUsers) { newValue in
                    self.closestUsers = newValue
                }
                .onChange(of: recommendationSystem.noClosestUsers) { newValue in
                    if newValue {
                        self.noClosestUsers = true
                    }
                }
                .tabItem {
                    Image(systemName: "person")
                    Text("Swipe")
                }
                .tag(1)
                
                VStack {
                    if matchedUsers.isEmpty {
                        if noMatches {
                            Text("No matches yet. Keep looking. Try again tomorrow!")
                        } else {
                            // show a loading indicator while fetching closest users
                            ProgressView()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 10) {
                                ForEach(matchedUsers, id: \.spotifyId){ user in
                                    MatchView(user: user)
                                }
                            }
                        }.frame(height: 650)
                    }
                }
                .onAppear {
                    // fetch closest users when the view appears
                    print("in view going to call getMatches")
                    recommendationSystem.getMatches(spotifyId: user.spotifyId)
                }
                .onChange(of: recommendationSystem.finalMatches) { newValue in
                    self.matchedUsers = newValue
                }
                .onChange(of: recommendationSystem.noMatches) { newValue in
                    if newValue {
                        self.noMatches = true
                    }
                }
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Matches")
                }.tag(2)
                
            }
        }
    }
}

//struct SignedInPages_Previews: PreviewProvider {
//    static var previews: some View {
//        SignedInPages()
//    }
//}
