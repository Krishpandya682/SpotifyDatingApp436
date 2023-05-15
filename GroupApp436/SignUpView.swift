//
//  SignUpView.swift
//  GroupApp436
//
//  Created by Krish Pandya on 5/11/23.
//
import SwiftUI

//struct SignUpView: View {
//    @Binding var currUser: User?
//    @EnvironmentObject var firestoreManager: FirestoreManager
//    @EnvironmentObject var recommendationSystem: RecommendationSystem
//    var spotifyId: String
//    @State var shouldNavigateToSignedInPages = false
//    @State var name: String = ""
//    @State var age: Int = 0
//    @State var description: String = ""
//
//    let maxBioWords = 30
//
//    var body: some View {
//        VStack{
//            VStack(alignment: .leading, spacing: 20) {
//                HStack {
//                    Text("Name:")
//                        .frame(width: 80, alignment: .leading)
//                        .font(.headline)
//                    TextField("Enter your name", text: $name)
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
//                    TextField("Enter your age", value: $age, formatter: NumberFormatter())
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
//                        TextEditor(text: $description)
//                            .frame( height: 150)
//                            .padding(.vertical, 12)
//                            .padding(.horizontal, 16)
//                            //.background(Color(.systemGray6))
//                            .foregroundColor(.black)
//                            .cornerRadius(8).overlay(
//                                RoundedRectangle(cornerRadius: 16)
//                                    .stroke(Color(.systemGray6), lineWidth: 4)
//                                    .onChange(of: description) { newValue in
//                                        if newValue.split(separator: " ").count > maxBioWords {
//                                            let words = newValue.split(separator: " ")
//                                            description = words.prefix(maxBioWords).joined(separator: " ")
//                                        }
//                                    }
//                            )
//                        if description.isEmpty {
//                            Text("Enter your bio")
//                                .foregroundColor(Color(.placeholderText))
//                                .padding(.horizontal, 20)
//                                .padding(.top, 14)
//                        }
//                    }
//                }
//
//                Spacer()
//
//                Button(action: {
//                    firestoreManager.updateUser(spotifyId: spotifyId, data: ["name": name, "description": description, "age": age]) { (error1) in
//                        if let error = error1 {
//                            // Handle the error
//                            print("Error updating user: \(error.localizedDescription)")
//                            return
//                        } else {
//                            shouldNavigateToSignedInPages = true
//                        }
//                    }
//
//                }) {
//                    Text("Submit")
//                        .fontWeight(.semibold)
//                        .foregroundColor(.white)
//                        .padding(.vertical, 10)
//                        .padding(.horizontal, 20)
//                        .background(Color.blue)
//                        .cornerRadius(8)
//                }
//
//            }
//            .padding(.vertical, 10).frame(width: 350, height: 600)
//            .navigationBarTitle("Profile", displayMode: .inline)
////            .background(NavigationLink(
////                        destination: SignedInPages(currUser: $currUser),
////                        isActive: $shouldNavigateToSignedInPages,
////                        label: EmptyView.init
////                    ))
//            .sheet(isPresented: $shouldNavigateToSignedInPages) {
//                SignedInPages(currUser: $currUser).environmentObject(recommendationSystem)
//            }
//        }
//
//    }
//}






//
//  SignUpView.swift
//  GroupApp436
//
//  Created by Krish Pandya on 5/11/23.
//
import SwiftUI

struct SignUpView: View {
//    @Binding var user: User?
    @EnvironmentObject var firestoreManager: FirestoreManager
    @EnvironmentObject var recommendationSystem: RecommendationSystem
    @State var shouldNavigateToSignedInPages = false
    var spotifyId: String
    @State var name: String = ""
    @State var age: Int = 0
    @State var description: String = ""
    @State var ageLow: Int = 18
    @State var ageHigh: Int = 100
    @State var phoneNumber: String = ""
    @State var instagram: String = ""
    @State var zip:Int = 00000
    let maxBioWords = 30
    @State private var showAlert = false

    var body: some View {
        ScrollView{
            VStack{
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Name:")
                            .frame(width: 80, alignment: .leading)
                            .font(.headline)
                        TextField("Enter your name", text: $name)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .font(.title3)
                            .background(Color(.systemGray6))
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }

                    HStack {
                        Text("Age:")
                            .frame(width: 80, alignment: .leading)
                            .font(.headline)
                        TextField("Enter your age", value: $age, formatter: NumberFormatter())
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .font(.title3)
                            .background(Color(.systemGray6))
                            .foregroundColor(.black)
                            .cornerRadius(8)
                            .keyboardType(.numberPad)
                    }

                    VStack(alignment: .leading) {
                        Text("Bio:")
                            .font(.headline)
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $description)
                                .frame( height: 150)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                //.background(Color(.systemGray6))
                                .foregroundColor(.black)
                                .cornerRadius(8).overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(.systemGray6), lineWidth: 4)
                                        .onChange(of: description) { newValue in
                                            if newValue.split(separator: " ").count > maxBioWords {
                                                let words = newValue.split(separator: " ")
                                                description = words.prefix(maxBioWords).joined(separator: " ")
                                            }
                                        }
                                )
                            if description.isEmpty {
                                Text("Enter your bio")
                                    .foregroundColor(Color(.placeholderText))
                                    .padding(.horizontal, 20)
                                    .padding(.top, 14)
                            }
                        }
                    }
                    
                    VStack(spacing: 30) {
                        Text("Age Range:")
                            .frame(width: 100, alignment: .leading)
                            .font(.headline)
                        HStack {
                            TextField("Min", value: $ageLow, formatter: NumberFormatter())
                                .padding(.vertical, 12)
                                .padding(.horizontal, 8)
                                .font(.title3)
                                .background(Color(.systemGray6))
                                .foregroundColor(.black)
                                .cornerRadius(8)
                                .keyboardType(.numberPad)
                            Text("-")
                            TextField("Max", value: $ageHigh, formatter: NumberFormatter())
                                .padding(.vertical, 12)
                                .padding(.horizontal, 8)
                                .font(.title3)
                                .background(Color(.systemGray6))
                                .foregroundColor(.black)
                                .cornerRadius(8)
                                .keyboardType(.numberPad)
                        }
                    }
                    
                    VStack {
                        Text("Phone Number:")
                            .frame(width: 125, alignment: .leading)
                            .font(.headline)
                        TextField("Phone no:", text: $phoneNumber)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .font(.title3)
                            .background(Color(.systemGray6))
                            .foregroundColor(.black)
                            .cornerRadius(8)
                            .keyboardType(.phonePad)
                    }
                    
                    VStack {
                        Text("Instagram:")
                            .frame(width: 100, alignment: .leading)
                            .font(.headline)
                        TextField("Instagram:", text: $instagram)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .font(.title3)
                            .background(Color(.systemGray6))
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                    
                    VStack {
                        Text("ZipCode:")
                            .frame(width: 100, alignment: .leading)
                            .font(.headline)
                        TextField("ZipCode:", value: $zip, formatter: NumberFormatter())
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .font(.title3)
                            .background(Color(.systemGray6))
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }



                    Spacer()
                    
                    Button(action: {
                        if name.count == 0 || phoneNumber.count == 0 || ageLow > ageHigh || ageLow < 18 || age < 18 || String(zip).count != 6{
                            showAlert = true
                        }else{
                            firestoreManager.updateUser(spotifyId: spotifyId, data: ["name": name, "description": description, "age": age, "ZipCode" : zip]) { (error1) in
                                if let error = error1 {
                                    // Handle the error
                                    print("Error updating user: \(error.localizedDescription)")
                                    return
                                }
                            }
                        }
                    }) {
                        Text("Save")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }

                }
                .padding(.vertical, 10).frame(width: 350, height: 600)
                .navigationBarTitle("Profile", displayMode: .inline).fixedSize(horizontal: false, vertical: true)
            }.padding(.vertical, 80)
        }.ignoresSafeArea().frame(height: 670).alert(isPresented: $showAlert) {
            Alert(
                title: Text("Enter Valid/Required Values"),
                message: Text("Enter valid values to continue"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}










//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
////        return UserInputView(user: )
//    }
//}


//struct SignUpView: View {
//
//    let spotifyId: String
//
//    var body: some View {
//        Text("SignUP View for:-")
//        Text(spotifyId)
//    }
//}
//
//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView(spotifyId: "Preview")
//    }
//}








