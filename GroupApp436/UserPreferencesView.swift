//
//  UserPreferencesView.swift
//  GroupApp436
//
//  Created by Vrundal Shah on 5/13/23.
//

import SwiftUI

struct UserPreferencesView: View {
    @Binding var userOpt: User?
    @State var ageHigh: Int = 18
    @State var ageLow: Int = 18
    @State var selectedGenderPref = 1
    @Binding var selectedTab: Int

    let genderOptions = ["Male", "Female", "All"]

    
//    init(userOpt: Binding<User?>) {
//            _userOpt = userOpt
//            if let user = userOpt.wrappedValue {
//                _ageHigh = State(initialValue: Double(user.ageHigh))
//                _ageLow = State(initialValue: Double(user.ageLow))
//                _selectedGenderPref = State(initialValue: user.genderPref)
//            } else {
//                _ageHigh = State(initialValue: 18)
//                _ageLow = State(initialValue: 18)
//                _selectedGenderPref = State(initialValue: 1)
//            }
//        }

    var body: some View {
        VStack {
            if var user = userOpt {
                HStack {
                    Text("Age High:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    TextField("Enter age", value: $ageHigh, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)

                HStack {
                    Text("Age Low:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    TextField("Enter age", value: $ageLow, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                .onAppear {
                    getAgeHigh(spotifyId: user.spotifyId) { age in
                        self.ageHigh = age
                    }
                    
                    getAgeLow(spotifyId: user.spotifyId) { age in
                        self.ageLow = age
                    }
                }
                .onChange(of: selectedTab) { newValue in
                    // fetch closest users when the Swipe tab is selected
                    if newValue == 0 {
                        getAgeHigh(spotifyId: user.spotifyId) { age in
                            self.ageHigh = age
                        }
                        
                        getAgeLow(spotifyId: user.spotifyId) { age in
                            self.ageLow = age
                        }
                    }
                }

                
                HStack {
                    Text("Gender Preference")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(.top, 40)
                
                Picker(selection: $selectedGenderPref, label: Text("Gender Preference")) {
                    ForEach(0..<genderOptions.count) { index in
                        Text(genderOptions[index])
                    }
                }
                .onAppear {
                    getGenderPref(spotifyId: user.spotifyId) { pref in
                        self.selectedGenderPref = pref
                    }
                }
                .onChange(of: selectedTab) { newValue in
                    // fetch closest users when the Swipe tab is selected
                    if newValue == 0 {
                        getGenderPref(spotifyId: user.spotifyId) { pref in
                            self.selectedGenderPref = pref
                        }
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    if let user = userOpt {
                        setAgeLow(spotifyId: user.spotifyId, ageLow: ageLow)
                        setAgeHigh(spotifyId: user.spotifyId, ageHigh: ageHigh)
                        setGenderPref(spotifyId: user.spotifyId, pref: selectedGenderPref)
//                        if var u = userOpt {
//                            u.ageHigh = Int(ageHigh)
//                            u.ageLow = Int(ageLow)
//                            u.genderPref = selectedGenderPref
//                        }
                    }
                }) {
                    Text("Submit")
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
            }
        }
        .padding()
        .navigationBarTitle("User Preferences")
        .background(
            LinearGradient(gradient: Gradient(colors: [.green, .gray]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
    }
}
