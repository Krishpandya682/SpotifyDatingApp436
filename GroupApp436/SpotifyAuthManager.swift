import SpotifyiOS
import SwiftUI

class SpotifyAuthManager: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published var isSessionValid: Bool = false
    
    private let appRemote: SPTAppRemote
    
    // MARK: - Init
    
    override init() {
        appRemote = SPTAppRemote(configuration: SPTConfiguration(clientID: "a1a07e45a9a64a17bb3ff606416bd76e", redirectURL: URL(string: "spotifydatingapp://")!), logLevel: .debug)
        super.init()
        appRemote.delegate = self
        
        // Check if user is already logged in
        if appRemote.authorizeAndPlayURI("") {
            print("-----------------user is already logged in")
            isSessionValid = true
        }
    }
    
    // MARK: - Public Methods
    
    func login() {
        if !appRemote.authorizeAndPlayURI("") {
            print("------------Login")
            // Handle login error, e.g., show an alert, update UI, etc.
        }
    }
    
    func handleRedirectURL(_ url: URL) {
        // Extract the query parameters from the URL
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if let queryItems = urlComponents?.queryItems {
            for item in queryItems {
                if item.name == "code" {
                    // Extract the authorization code from the query parameter
                    let authorizationCode = item.value
                    // Use the authorization code to fetch the access token from Spotify
                    // and complete the authorization process
                    // Call your custom function here to handle the authorization code
                    // e.g.:
                    // myCustomAuthManager.handleAuthorizationCode(authorizationCode)
                    return
                } else if item.name == "error" {
                    // Handle the error case
                    let error = item.value
                    // Call your custom function here to handle the error
                    // e.g.:
                    // myCustomAuthManager.handleAuthorizationError(error)
                    return
                }
            }
        }
        // If no valid query parameters found, handle the error case
        // Call your custom function here to handle the error
        // e.g.:
        // myCustomAuthManager.handleAuthorizationError("Invalid redirect URL")
    }

    
    func logout() {
        appRemote.disconnect()
        isSessionValid = false
    }
}

extension SpotifyAuthManager: SPTAppRemoteDelegate {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        // Handle successful connection
        print("Connected SUCCESSFULLYYYY")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        // Handle disconnection error, e.g., show an alert, update UI, etc.
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        // Handle connection failure, e.g., show an alert, update UI, etc.
    }
}
