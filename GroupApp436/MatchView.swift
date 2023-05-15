//
//  MatchView.swift
//  GroupApp436
//
//  Created by Vrundal Shah on 5/13/23.
//

import SwiftUI
import PhoneNumberKit

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
                .frame(width: 350, height: 450)
                .padding(.vertical, 0)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(user.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.leading, 0).frame(width: 350)
                    Text("\(user.age) years old")
                        .foregroundColor(.white)
                        .padding(.leading, 0)
                        .padding(.top, 20)
                        
                    Text(user.description)
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true).padding(.top, 1)
                        .padding(.leading, 0)
                    Text("Contact Info: \(formattedPhoneNumber(phoneNumber: user.phoneNumber))")


                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true).padding(.top, 1)
                        .padding(.leading, 0)
                }.frame(width: 350).padding(.leading, 0)
                
            }.frame(width: 350, height: 600).padding(.leading, 0)
        }
    }
    
    func formattedPhoneNumber(phoneNumber: Int) -> String {
        var phoneNumberStr = String(phoneNumber)
        var formattedPhoneNumber = "("

        for (index, digit) in phoneNumberStr.enumerated() {
            if index == 3 {
                formattedPhoneNumber += ") "
            } else if index == 6 {
                formattedPhoneNumber += "-"
            }
            
            formattedPhoneNumber.append(digit)
        }
        
        return formattedPhoneNumber
    }
}


//struct MatchView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView(user : User(name: "Krish", age: 23, bio: "Hi, I'm Krish. I enjoy playing guitar and painting.", picture: "https://skateparkoftampa.com/spot/headshots/4322.jpg"))
//    }
//}

