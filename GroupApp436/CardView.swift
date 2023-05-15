//
//  CardView.swift
//  GroupApp436
//
//  Created by Vrundal Shah on 5/13/23.
//

import SwiftUI


struct CardView: View {

    var signedUserSpotifyId: String
    var user: User
    @State private var offset = CGSize.zero
    @State private var col: Color = .black
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(col)
                .frame(width: 380, height: 650)
                .shadow(radius: 10)
            
            VStack(spacing: 10) {
                Text("user.imageURL \(user.imageURL)")
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
//                        Image(systemName: "xmark.octagon.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                            .foregroundColor(.red)Image(systemName: "xmark.octagon.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                            .foregroundColor(.red)
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
                }
                
            }.frame(width: 350, height: 600)
        }
        .offset(x: offset.width, y: offset.height * 0.4)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .gesture(DragGesture().onChanged{ gesture in offset = gesture.translation
            withAnimation{
                colorChange(width: offset.width)
                
            }
        }.onEnded{ _ in
            moveCard(width: offset.width)
            colorChange(width: offset.width)
        })
    }
    
    func moveCard(width: CGFloat){
        switch width {
        case -500...(-150):
            // left swipe
            offset = CGSize(width: -500, height: 0)
            addDisliked(spotifyUserId: signedUserSpotifyId, dislikedSpotifyUserId: user.spotifyId)
        case 150...500:
            offset = CGSize(width: 500, height: 0)
            addLiked(spotifyUserId: signedUserSpotifyId, likedSpotifyUserId: user.spotifyId)
        default:
            offset = .zero
        }
    }
    
    func colorChange(width: CGFloat){
        switch width{
        case -500...(-130):
            col = .red
        case 130...500:
            col = .green
        default:
            col = .black
        }
    }
}


//
//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView(user : User(name: "Krish", age: 23, bio: "Hi, I'm Krish. I enjoy playing guitar and painting.", picture: "https://skateparkoftampa.com/spot/headshots/4322.jpg"))
//    }
//}
