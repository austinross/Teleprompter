//
//  Prompt.swift
//  Project_P3_Team_E
//
//  Created by Austin Ross on 11/12/19.
//  Copyright © 2019 Mack Ross. All rights reserved.
//

import RealmSwift

class Prompt: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var date = ""
    @objc dynamic var text = ""
    
    init(name: String, date: String, text: String) {
        self.name = name
        self.date = date
        self.text = text
    }

    required init() {}
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
