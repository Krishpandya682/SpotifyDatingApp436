////
////  UserInputView.swift
////  GroupApp436
////
////  Created by Vrundal Shah on 5/11/23.
////
//
//import SwiftUI
//
//struct UserInputView: View {
//    @Binding var user: User
//    let maxBioWords = 30
//
//    var body: some View {
//        VStack{
//            VStack(alignment: .leading, spacing: 20) {
//                HStack {
//                    Text("Name:")
//                        .frame(width: 80, alignment: .leading)
//                        .font(.headline)
//                    TextField("Enter your name", text: $user.name)
//                        .padding(.vertical, 12)
//                        .padding(.horizontal, 16)
//                        .font(.title3)
//                        .background(Color(.systemGray6))
//                        .foregroundColor(.black)
//                        .cornerRadius(8)
//                }
//
//                HStack {
//                    Text("Age:")
//                        .frame(width: 80, alignment: .leading)
//                        .font(.headline)
//                    TextField("Enter your age", value: $user.age, formatter: NumberFormatter())
//                        .padding(.vertical, 12)
//                        .padding(.horizontal, 16)
//                        .font(.title3)
//                        .background(Color(.systemGray6))
//                        .foregroundColor(.black)
//                        .cornerRadius(8)
//                        .keyboardType(.numberPad)
//                }
//
//                VStack(alignment: .leading) {
//                    Text("Bio:")
//                        .font(.headline)
//                    ZStack(alignment: .topLeading) {
//                        TextEditor(text: $user.bio)
//                            .frame( height: 150)
//                            .padding(.vertical, 12)
//                            .padding(.horizontal, 16)
//                            //.background(Color(.systemGray6))
//                            .foregroundColor(.black)
//                            .cornerRadius(8).overlay(
//                                RoundedRectangle(cornerRadius: 16)
//                                    .stroke(Color(.systemGray6), lineWidth: 4).onChange(of: user.bio) { newValue in
//                                        if newValue.split(separator: " ").count > maxBioWords {
//                                            let words = newValue.split(separator: " ")
//                                            user.bio = words.prefix(maxBioWords).joined(separator: " ")
//                                        }
//                                    }
//                            )
//                        if user.bio.isEmpty {
//                            Text("Enter your bio")
//                                .foregroundColor(Color(.placeholderText))
//                                .padding(.horizontal, 20)
//                                .padding(.top, 14)
//                        }
//                    }
//                }
//
//                Spacer()
//            }
//            .padding(.vertical, 10).frame(width: 350, height: 600)
//            .navigationBarTitle("Profile", displayMode: .inline)
//        }
//    }
//}
//
//
//
//
//
//
//
//
//
//
//struct UserInputView_Previews: PreviewProvider {
//    static var previews: some View {
//        let user = User(name: "", age: 0, bio: "")
//        return UserInputView(user: .constant(user))
//    }
//}
