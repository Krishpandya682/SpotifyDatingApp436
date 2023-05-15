//
//  LikesYou.swift
//  GroupApp436
//
//  Created by Vrundal Shah on 5/15/23.
//

import SwiftUI

struct LikesYou: View {
    var signedUserSpotifyId: String
    var spotifyId: String
    @State var likesYou = false
    
    var body: some View {
        Text("\((likesYou ? "Likes You" : ""))").foregroundColor(.white)
            .onAppear {
                getUser(spotifyId) { (user, error) in
                    if let err = error {
                        print("\(err.localizedDescription)")
                    }
                    
                    if let u = user {
                        self.likesYou = u.liked.contains(signedUserSpotifyId)
                    }
                }
            }
    }
}

//struct LikesYou_Previews: PreviewProvider {
//    static var previews: some View {
//        LikesYou()
//    }
//}
