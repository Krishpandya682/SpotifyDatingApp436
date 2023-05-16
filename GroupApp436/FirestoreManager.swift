//
//  FirestoreManager.swift
//  SpotifyDatingApp
//
//  Created by Krish Pandya on 4/24/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreManager: ObservableObject {
    let db = Firestore.firestore()
    func createUser(userCard: User, completion: @escaping (Bool) -> Void) {
        print("Storing the new user in the database")
        print(userCard)
        let docRef = db.collection("Users").document(userCard.spotifyId)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Document with the Spotify ID already exists
                print("User already exists!")
                completion(true)
            } else {
                // Document with the Spotify ID does not exist
                print("User does not exist, creating a new one")
                
                // Perform your write operation or any other required actions to create the document
                do {
                    try docRef.setData(from: userCard) { error in
                        if let error = error {
                            print("Error writing userCard to Firestore: \(error)")
                            completion(false)
                        } else {
                            completion(false)
                        }
                    }
                } catch {
                    print("Error writing userCard to Firestore: \(error)")
                    completion(false)
                }
                completion(false)
            }
        }
    }
    
    
    func getUser(spotifyId: String, completion: @escaping (User?, Error?) -> Void) {
        print("firemanager userid: \(spotifyId)")
        let docRef = db.collection("Users").document(spotifyId)
        
        docRef.getDocument { (document, error) in
            do {
                if let error = error {
                    throw error
                }
                
                guard let document = document, document.exists else {
                    throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found"])
                }
                
                let data = try JSONSerialization.data(withJSONObject: document.data()!, options: [])
                print("here after data init")
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                print("here after decoding")
                completion(user, nil)
            } catch {
                print("manager error!  \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
    
    func getUsers(completion: @escaping ([User]?, Error?) -> Void) {
        db.collection("Users").getDocuments { (snapshot, error) in
            do {
                if let error = error {
                    throw error
                }
                
                var users = [User]()
                
                for document in snapshot!.documents {
                    let data = try JSONSerialization.data(withJSONObject: document.data(), options: [])
                    print("here after data init")
                    let decoder = JSONDecoder()
                    let user = try decoder.decode(User.self, from: data)
                    print("adding user")
                    users.append(user)
                }
                
                print("returning users")
                completion(users, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    func updateUser(spotifyId: String, data: [String: Any], completion: ((Error?) -> Void)?) {
        let docRef = db.collection("Users").document(spotifyId)
        
        docRef.updateData(data) { error in
            completion?(error)
        }
    }

    
    
}


