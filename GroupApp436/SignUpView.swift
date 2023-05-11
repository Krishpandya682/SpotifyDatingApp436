//
//  SignUpView.swift
//  GroupApp436
//
//  Created by Krish Pandya on 5/11/23.
//

import SwiftUI

struct SignUpView: View {
    
    let spotifyId: String
    
    var body: some View {
        Text("SignUP View for:-")
        Text(spotifyId)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(spotifyId: "Preview")
    }
}
