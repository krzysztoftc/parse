//
//  Lecture.swift
//  PWR_API
//
//  Created by Karol Kubicki on 31.12.2015.
//  Copyright © 2015 Karol Kubicki. All rights reserved.
//

import Foundation

struct Lecture {
    let objectId: String
    let name: String
    let lecturerName: String
    let lectureDescription: String
}

extension Lecture {
    init?(json: [String : AnyObject]) {
        guard let objectId = json["objectId"] as? String,
            name = json["name"] as? String,
            lecturerName = json["lecturer"] as? String,
            lectureDescription = json["description"] as? String else {
                return nil
        }
        self.objectId = objectId
        self.name = name
        self.lecturerName = lecturerName
        self.lectureDescription = lectureDescription
    }
}
