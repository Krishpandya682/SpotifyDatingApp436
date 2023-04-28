import SwiftUI

struct LoginView: View {
    // Inject the SpotifyAuthManager instance
    let responseType = "token"
    let clientId = SpotifyConstants.CLIENT_ID
    let scope = SpotifyConstants.SCOPE
    let redirectUri = SpotifyConstants.REDIRECT_URI
    let showDialog = "true"

    var body: some View {

        let authURLFull = "https://accounts.spotify.com/authorize?response_type=\(responseType)&client_id=\(clientId)&scope=\(scope)&redirect_uri=\(redirectUri)&show_dialog=\(showDialog)"
                Link("Open URL", destination: URL(string: authURLFull)!)
                    .padding()
            }
     
}
