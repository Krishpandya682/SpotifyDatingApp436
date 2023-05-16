//
//  SignUpView.swift
//  GroupApp436
//
//  Created by Krish Pandya on 5/11/23.
//
import SwiftUI

struct Track {
    let id : String
    let imageURL : String
    let songName: String
    let artistName : String
}


struct SignUpView: View {
    @Binding var isUserSignedUp: Bool
    @EnvironmentObject var firestoreManager: FirestoreManager
    @EnvironmentObject var recommendationSystem: RecommendationSystem
    @State var shouldNavigateToSignedInPages = false
    var spotifyId: String
    @State var name: String = ""
    @State var age: Int = 0
    @State var description: String = ""
    @State var ageLow: Int = 18
    @State var ageHigh: Int = 100
    @State var phoneNumber: Int = 0
    @State var instagram: String = ""
    @State var zip:Int = 20742
    let maxBioWords = 30
    @State private var showAlert = false
    let accessToken : String
    
    @State private var allTrackIds: [String] = ["0ecW7IqLKhzKTPeqLSNc0V","6ZYxNjuAU9Vy3VtF6W1dtE","2RgvvnMwtP0R2OkVZmFvnV"]
    @State private var selectedTrackIds = [String]()
    
    @State var tracks: [Track] = []
    func getTrackInfo(trackId: String, completion: @escaping (Track?) -> Void) {
        print("Fetching still............")
        
        let urlString = "https://api.spotify.com/v1/tracks/\(trackId)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization") // Replace YOUR_ACCESS_TOKEN with an actual access token
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            // Print the raw output of the API call
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw API output: \(jsonString)")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let json = json {
                    let id = json["id"] as? String ?? ""
                    
                    if let album = json["album"] as? [String: Any],
                       let images = album["images"] as? [[String: Any]],
                       let firstImage = images.first,
                       let imageURL = firstImage["url"] as? String,
                       let songName = json["name"] as? String {
                        
                        var artistName = ""
                        if let artists = json["artists"] as? [[String: Any]],
                           let firstArtist = artists.first,
                           let name = firstArtist["name"] as? String {
                            artistName = name
                        }
                        
                        let track = Track(id: id, imageURL: imageURL, songName: songName, artistName: artistName)
                        
                        print("Fetching DONE!!!!!!!!!!!!!!!!")
                        
                        completion(track)
                        return
                    }
                }
                
                print("Invalid JSON data")
                completion(nil)
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        task.resume()
    }

    

  
    var body: some View {
        
            ScrollView{
                VStack{
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            HStack(spacing: 0) {
                                Text("*").foregroundColor(.red)
                                    .baselineOffset(5)
                                Text("Name:")
                            }
                            .baselineOffset(5)
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
                            HStack(spacing: 0) {
                                Text("*").foregroundColor(.red)
                                Text("Age:")
                            }
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
                            HStack(spacing: 0) {
                                Text("*").foregroundColor(.red)
                                Text("Phone Number:")
                            }
                            .frame(width: 125, alignment: .leading)
                            .font(.headline)
                            TextField("Phone no:", value: $phoneNumber, formatter: NumberFormatter())
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
                            HStack(spacing: 0) {
                                Text("*").foregroundColor(.red)
                                Text("ZipCode:")
                                
                            }
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
                        Text("--------SELECT SONGS--------------\(self.tracks.count)")
                        SongView(tracks: $tracks, selectedTrackIds: self.$selectedTrackIds)
                            .onAppear {
                                for trackId in allTrackIds {
                                    getTrackInfo(trackId: trackId) { track in
                                        if let t = track {
                                            self.tracks.append(t)
                                        }
                                    }
                                }
                            }
                        Button(action: {
                            let selectedIds = Array(selectedTrackIds)
                            print("Selected track ids: \(selectedIds)")
                            
                            if name.count == 0 || (String(phoneNumber).count == 0 && String(phoneNumber).count == 10) || ageLow > ageHigh || ageLow < 18 || age < 18 || String(zip).count != 5 ||  Array(selectedTrackIds).count<=0{
                                showAlert = true
                            }else{
                                //                                let features = calculateFeatures(accessToken: self.accessToken, spotifyId: spotifyId, trackIds: selectedTrackIds)
                                let features = calculateFeatures(accessToken: self.accessToken, spotifyId: spotifyId, trackIds: selectedTrackIds)
                                
                                
                                firestoreManager.updateUser(spotifyId: spotifyId, data: ["name": name, "age": age, "ageLow": ageLow, "ageHigh": ageHigh, "description": description, "ZipCode" : zip, "phoneNumber": phoneNumber, "instagramUsername": instagram, "features": [
                                    "acousticness": features.acousticness,
                                    "danceability": features.danceability,
                                    "duration_ms": features.duration_ms,
                                    "energy": features.energy,
                                    "instrumentalness": features.instrumentalness,
                                    "key": features.key,
                                    "liveness": features.liveness,
                                    "loudness": features.loudness,
                                    "mode": features.mode,
                                    "speechiness": features.speechiness,
                                    "tempo": features.tempo,
                                    "time_signature": features.time_signature
                                ]]) { (error1) in
                                    if let error = error1 {
                                        // Handle the error
                                        print("Error updating user: \(error.localizedDescription)")
                                        return
                                    }
                                }
                                let matchVal = calculateMatchVal(features: features)
                                firestoreManager.updateUser(spotifyId: spotifyId, data: ["matchVal": matchVal]){
                                    (error1) in
                                        if let error = error1 {
                                            // Handle the error
                                            print("Error updating user: \(error.localizedDescription)")
                                            return
                                        }
                                }
                                isUserSignedUp = true
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
                    .padding(.vertical, 250).frame(width: 350, height: 700)
                    .navigationBarTitle("Profile", displayMode: .inline).fixedSize(horizontal: false, vertical: true)
                }.padding(.vertical, 250)
            }
            
            .navigationBarTitle("Profile", displayMode: .inline)
            .ignoresSafeArea().frame(height: 700).alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Enter Valid/Required Values"),
                    message: Text("Enter valid values to continue"),
                    dismissButton: .default(Text("OK"))
                )
            }
        
        }
    
    }
    
struct SongView: View {
    @Binding var tracks: [Track]
    @Binding var selectedTrackIds : [String]
    
    var body: some View {
        VStack {
            ForEach(tracks, id: \.id) { track in
                TrackRow(track: track, isSelected: selectedTrackIds.contains(track.id)) {
                    if selectedTrackIds.contains(track.id) {
                        selectedTrackIds.removeAll { $0 == track.id }
                    } else {
                        selectedTrackIds.append(track.id)
                    }
                }
            }
            //.disabled(selectedTrackIds.isEmpty)
        }
    }
}
    
struct TrackRow: View {
    let track: Track
    let isSelected: Bool
    let toggleSelection: () -> Void
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: track.imageURL)) { image in
                image.resizable()
                    .scaledToFit()
            } placeholder: {
                Image(systemName: "music.note")
                    .foregroundColor(.gray)
                    .frame(width: 50, height: 50)
            }
            .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(track.songName)
                    .font(.headline)
                Text(track.artistName)
                    .font(.subheadline)
            }
            
            Spacer()
            
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? .green : .gray)
                .onTapGesture {
                    toggleSelection()
                }
        }
    }
}

    
    
    
    
    
