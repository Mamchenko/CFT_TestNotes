//
//  Database.swift
//  CFT_test_zametki
//
//  Created by Anatoliy Mamchenko on 18.03.2021.
//

import Foundation
import RealmSwift


class Database {
    
    private lazy var realm = try! Realm()
    var arrayOfNotes = [NotesModel]()
    var complition: (() -> ())?
    
    func checkquantityInArray () {
        if realm.objects(NotesModel.self).map({$0}).first == nil {
            createObject(imageData: nil, tittle: "test", note: "test")
        }
    }
    
    func createObject ( imageData: Data?, tittle: String, note: String) {
        realm.beginWrite()
            let modelObject = NotesModel()
            modelObject.title = tittle
            modelObject.note = note
            if let data = imageData {
                modelObject.imageData = data
                modelObject.thing = .have
            } else {
                modelObject.imageData = nil
                modelObject.thing = .notHave
            }
        realm.add(modelObject)
        try! realm.commitWrite()
            
    
    }
    
    func getArrayOfObject ()    {
        arrayOfNotes = realm.objects(NotesModel.self).map({$0})

    }
    
    private func getCurrentObject(id: String ) -> NotesModel? {
        return realm.objects(NotesModel.self).map({$0}).filter({$0.id == id}).first
    }
    
    
    func deleteObject (id: String?) {
        guard let currentNote = getCurrentObject(id: id ?? " ") else {return}
        realm.beginWrite()
        realm.delete(currentNote)
        try! realm.commitWrite()
    }
}
