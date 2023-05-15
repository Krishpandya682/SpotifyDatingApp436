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
        
        
        Text("Spotify Dating App")
            .font(.system(size: 40, weight: .semibold))
            .foregroundColor(.black)
        
            Link("Login With Spotify", destination: URL(string: authURLFull)!)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
        
    }
}

