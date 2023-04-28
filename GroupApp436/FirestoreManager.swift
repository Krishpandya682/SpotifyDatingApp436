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

    func createUser(userCard: User) {
     
        let docRef = db.collection("Users").document(userCard.id.uuidString)

        do {
            try docRef.setData(from: userCard)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    func getUsers(uid:String){
        let docRef = db.collection("Users").document(uid)
        docRef.getDocument { (document, error) in
               guard error == nil else {
                   print("error", error ?? "")
                   return
               }

               if let document = document, document.exists {
                   let data = document.data()
                   if let data = data {
                       print("data", data)
                   }
               }

           }
    }
}


