import Foundation

func storeSongFeatures(songID: String, accessToken: String, completion: @escaping (Features?) -> Void) {
    let endpoint = URL(string: "https://api.spotify.com/v1/audio-features/\(songID)")!
    
    var request = URLRequest(url: endpoint)
    request.httpMethod = "GET"
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
            completion(nil)
            return
        }
        
        guard let data = data else {
            print("No data received")
            completion(nil)
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            if let features = json {
                let acousticness = features["acousticness"] as? Double ?? 0.0
                let danceability = features["danceability"] as? Double ?? 0.0
                let duration_ms = features["duration_ms"] as? Double ?? 0.0
                let energy = features["energy"] as? Double ?? 0.0
                let instrumentalness = features["instrumentalness"] as? Double ?? 0.0
                let key = features["key"] as? Double ?? 0.0
                let liveness = features["liveness"] as? Double ?? 0.0
                let loudness = features["loudness"] as? Double ?? 0.0
                let mode = features["mode"] as? Double ?? 0.0
                let speechiness = features["speechiness"] as? Double ?? 0.0
                let tempo = features["tempo"] as? Double ?? 0.0
                let time_signature = features["time_signature"] as? Double ?? 0.0
                
                let songFeatures = Features(acousticness: acousticness,
                                             danceability: danceability,
                                             duration_ms: duration_ms,
                                             energy: energy,
                                             instrumentalness: instrumentalness,
                                             key: key,
                                             liveness: liveness,
                                             loudness: loudness,
                                             mode: mode,
                                             speechiness: speechiness,
                                             tempo: tempo,
                                             time_signature: time_signature)
                completion(songFeatures)
            }
        } catch {
            print("Error deserializing JSON: \(error)")
            completion(nil)
        }
    }
    
    task.resume()
}
