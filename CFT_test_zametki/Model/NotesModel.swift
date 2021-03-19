//
//  NotesModel.swift
//  CFT_test_zametki
//
//  Created by Anatoliy Mamchenko on 17.03.2021.
//

import Foundation
import RealmSwift

class NotesModel: Object {
    @objc dynamic var imageData: Data? = nil
    @objc dynamic var title: String = ""
    @objc dynamic var note: String = ""
    @objc dynamic var id: String = UUID().uuidString
    @objc private dynamic var privateThing: String = ImageState.notHave.rawValue
    var thing: ImageState {
        get { return ImageState(rawValue: privateThing)! }
        set { privateThing = newValue.rawValue }
    }
}

enum ImageState: String {
    case have = "have"
    case notHave = "not have"
}
