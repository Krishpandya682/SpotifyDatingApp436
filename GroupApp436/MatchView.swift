//
//  MatchView.swift
//  GroupApp436
//
//  Created by Vrundal Shah on 5/13/23.
//

import SwiftUI

struct MatchView: View {
    var user: User
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black)
                .frame(width: 380, height: 650)
                .shadow(radius: 10)
            
            VStack(spacing: 10) {
                AsyncImage(url: URL(string: user.imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    case .failure:
                        Text("\(user.name) doesn't have a profile image").foregroundColor(.white).font(.headline)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 350, height: 380)
                .padding(.top, 1)
                
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("\(user.age) years old")
                        .foregroundColor(.white)
                        
                    Text(user.description)
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true).padding(.top, 1)
                    
                    Text("Contact Info: \(user.phoneNumber)")
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true).padding(.top, 1)
                }
                
            }.frame(width: 350, height: 600)
        }
    }
}


//struct MatchView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView(user : User(name: "Krish", age: 23, bio: "Hi, I'm Krish. I enjoy playing guitar and painting.", picture: "https://skateparkoftampa.com/spot/headshots/4322.jpg"))
//    }
//}

