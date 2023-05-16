//
//  CreateUser.swift
//  SpotifyDatingApp
//
//  Created by Krish Pandya on 4/25/23.
//

import Foundation


func extractParameters(from url: URL) -> [String: String]? {
    guard let fragment = url.fragment else {
        print("No hash fragment found in URL: \(url.absoluteString)")
        return nil
    }
    
    var parameters = [String: String]()
    let keyValuePairs = fragment.components(separatedBy: "&")
    
    for keyValuePair in keyValuePairs {
        let components = keyValuePair.components(separatedBy: "=")
        if components.count == 2 {
            let key = components[0]
            let value = components[1]
            parameters[key] = value
        }
    }
    
    if parameters.isEmpty {
        print("No parameters found in hash fragment: \(fragment)")
        return nil
    } else {
        return parameters
    }
}


func getUserInfo(with accessToken: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
    let urlString = "https://api.spotify.com/v1/me"
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "No data returned", code: -1, userInfo: nil)))
            return
        }
        print("Raw data: \(String(data: data, encoding: .utf8) ?? "Failed to decode data")")
        
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("JSON response: \(json)")
                completion(.success(json))
            } else {
                completion(.failure(NSError(domain: "Failed to parse JSON", code: -1, userInfo: nil)))
            }
        } catch {
            completion(.failure(error))
        }
    }
    task.resume()
}


func createUserProfile(url : URL, completion: @escaping (User, Bool) -> Void){
    print("createUserProfile")
    let params = extractParameters(from: url)
    let token_type = params?["token_type"]
    let expires_in = params?["expires_in"]
    
    var userSpotifyId = "TEMPID"
    var userDisplayName = "TEMPDISPLAYNAME"
    var userImageLink = "Noimagefound"
    
    if let accessToken = params?["access_token"] {
        getUserInfo(with: accessToken) { result in
            print("Result returned from getUserInfo:- ", type(of: result))
            switch result {
            case .success(let json):
                if let spotifyId = json["id"] as? String{
                    print("Sptify Id: \(spotifyId)")
                    userSpotifyId = spotifyId
                }
                if let userName = json["display_name"] as? String {
                    print("User Name: \(userName)")
                    userDisplayName = userName
                }
                if let profileImageArray = json["images"] as? [[String: Any]], profileImageArray.count > 0 {
                    if let profileImageLink = profileImageArray[0]["url"] as? String {
                        print("Profile Image Link: \(profileImageLink)")
                        userImageLink = profileImageLink
                    }
                } else {
                    print("Profile Image not found")
                }
                
                print(userSpotifyId)
                
                getUser(userSpotifyId) { (u1, error) in
                    if let error = error {
                        // create new user
                        print(error.localizedDescription)
                        let tempUser = User(spotifyId: userSpotifyId,
                                            name: userDisplayName,
                                            imageURL: userImageLink,
                                            age: 20,
                                            description: "Testing after getting from spotify",
                                            gender: 0,
                                            genderPref: 1,
                                            ageLow: 18,
                                            ageHigh: 25,
                                            zipcode: 20742, phoneNumber: 99999999, features: calculateFeatures(accessToken: accessToken), instagramUsername: "unplugged_verses")
                        print("tempuser")
                        completion(tempUser, false)
                    }
                    
                    if let user1 = u1 {
                        print("user1 \(user1.ageHigh)")
                        completion(user1, true)
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    } else {
        print("Access Token not found")
    }
    print("spotify Id")
}
