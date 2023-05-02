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

    func createUser(userCard: User) -> Bool {
     
        let docRef = db.collection("Users").document(userCard.spotifyId)
        
        if ((docRef != nil)) {
            return false;
        }else{
            do {
                try docRef.setData(from: userCard)
            } catch let error {
                print("Error writing city to Firestore: \(error)")
            }
            
            return true
            
        }
    }
    
    func getUser(spotifyId: String, completion: @escaping (User?, Error?) -> Void) {
        let docRef = db.collection("Users").document(spotifyId)

        docRef.getDocument { (document, error) in
            do {
                if let error = error {
                    throw error
                }

                guard let document = document, document.exists else {
                    throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found"])
                }

                let data = document.data()!

                let user = try User(from: data as! Decoder)

                completion(user, nil)
            } catch {
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
                    let data = document.data()

                    let user = try User(from: data as! Decoder )
                    users.append(user)
                }

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


