import SwiftUI

struct LoginView: View {
    // Inject the SpotifyAuthManager instance
    let responseType = "token"
    let CLIENT_ID = SpotifyConstants.CLIENT_ID
    let CLIENT_SECRET = SpotifyConstants.CLIENT_SECRET
    let SCOPE = SpotifyConstants.SCOPE
    let REDIRECT_URI = SpotifyConstants.REDIRECT_URI
    let showDialog = "true"

    var body: some View {
        
        let authURLFull = "https://accounts.spotify.com/authorize?response_type=\(responseType)&client_id=\(CLIENT_ID)&scope=\(SCOPE)&redirect_uri=\(REDIRECT_URI)&show_dialog=\(showDialog)"
        
        
        Link("Open URL", destination: URL(string: authURLFull)!)
//        Button("Log in with Spotify") {
//            authorize()
//        }
        .padding()
        
    }
     
}


import Foundation
let responseType = "token"
let CLIENT_ID = SpotifyConstants.CLIENT_ID
let CLIENT_SECRET = SpotifyConstants.CLIENT_SECRET
let SCOPE = SpotifyConstants.SCOPE
let REDIRECT_URI = SpotifyConstants.REDIRECT_URI
let showDialog = "true"

//
//// Define the URL for the Spotify Accounts service
//let SPOTIFY_ACCOUNTS_URL = URL(string: "https://accounts.spotify.com")!
//func authorize() {
//    // Construct the URL for the authorization request
//    let authorizeURL = URL(string: "/authorize", relativeTo: SPOTIFY_ACCOUNTS_URL)!
//    var components = URLComponents(url: authorizeURL, resolvingAgainstBaseURL: true)!
//    components.queryItems = [
//        URLQueryItem(name: "client_id", value: CLIENT_ID),
//        URLQueryItem(name: "response_type", value: "code"),
//        URLQueryItem(name: "redirect_uri", value: REDIRECT_URI),
//        URLQueryItem(name: "scope", value: SCOPE),
//        URLQueryItem(name: "show_dialog", value: "true"),
//        URLQueryItem(name: "prompt", value: "select_account")
//    ]
//    let url = components.url!
//    
//    // Open the authorization URL in a web browser
//    UIApplication.shared.open(url)
//}
//
//// Function to exchange the authorization code for an access token
//func getToken(withCode code: String, completionHandler: @escaping (String?, Error?) -> Void) {
//    // Construct the URL for the token request
//    let tokenURL = URL(string: "/api/token", relativeTo: SPOTIFY_ACCOUNTS_URL)!
//    var request = URLRequest(url: tokenURL)
//    request.httpMethod = "POST"
//    
//    // Set the request parameters
//    let body = "grant_type=authorization_code&code=\(code)&redirect_uri=\(REDIRECT_URI)&client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)"
//    request.httpBody = body.data(using: .utf8)
//    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//    
//    // Make the token request
//    let session = URLSession.shared
//    let task = session.dataTask(with: request) { (data, response, error) in
//        guard let data = data, error == nil else {
//            completionHandler(nil, error)
//            return
//        }
//        print("Token response: \(String(data: data, encoding: .utf8) ?? "")")
//        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
//        let accessToken = json?["access_token"] as? String
//        completionHandler(accessToken, nil)
//    }
//    task.resume()
//}
//
//// Function to get the current user's profile using an access token
//func getCurrentUserProfile(withAccessToken accessToken: String, completionHandler: @escaping ([String:Any]?, Error?) -> Void) {
//    // Construct the URL for the profile request
//    let profileURL = URL(string: "https://api.spotify.com/v1/me")!
//    var request = URLRequest(url: profileURL)
//    request.httpMethod = "GET"
//    
//    // Set the access token as an authorization header
//    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//    
//    // Make the profile request
//    let session = URLSession.shared
//    let task = session.dataTask(with: request) { (data, response, error) in
//        guard let data = data, error == nil else {
//            completionHandler(nil, error)
//            return
//        }
//        print("Profile response: \(String(data: data, encoding: .utf8) ?? "")")
//        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
//        completionHandler(json, nil)
//    }
//    task.resume()
//}
