//
//  LecturesService.swift
//  PWR_API
//
//  Created by Karol Kubicki on 02.01.2016.
//  Copyright © 2016 Karol Kubicki. All rights reserved.
//

import Foundation

// LecturesService istnieje jako warstwa pomiędzy API które zwraca JSON
// a UI który otrzymuje gotowe obiekty Lecture

class LecturesService {
    
    typealias LecturesSuccessCallback = (lectures: [Lecture]) -> Void
    typealias LectureSuccessCallback = (lecture: Lecture) -> Void
    
    private lazy var api = APIClient(
        baseURL: NSURL(string: "https://api.parse.com/1/classes/")!,
        headersProvider: ParseAPIHeadersProvider()
    )
    
    func getLectures(successCallback: LecturesSuccessCallback, errorCallback: ErrorCallback) {
        api.getLectures({ jsonDictionary in
            guard let results = jsonDictionary["results"] as? [[String : AnyObject]] else {
                return
            }
            successCallback(lectures: results.flatMap { Lecture.init(json: $0) })
        }, errorCallback: errorCallback)
    }
    
    func createLecture(
        name name: String,
        lecturerName: String,
        lectureDescription: String,
        successCallback: LectureSuccessCallback,
        errorCallback: ErrorCallback)
    {
        // TODO
        // Wywołaj funkcje na API
        // Pobierze pole "objectId" ze słownika JSON - typu String
        // Stwórz obiekt Lecture na podstawie przekazanych pól i pobranego z JSON "objectId"
        // Wywołaj successCallback lub errorCallback w zalezności od odpowiedzi
        
        api.createLecture(name, lecturerName: lecturerName, lectureDescription: lectureDescription, successCallback: { json in
            if let id = json["objectId"] as? String{
                var lecture = Lecture(objectId: id, name: name, lecturerName: lecturerName, lectureDescription: lectureDescription)
                successCallback(lecture: lecture)
            }
        }, errorCallback: errorCallback)
    }
    
    func updateLecture(lectureId: String, newName: String, newLecturer: String, newLectureDescription: String, successCallback: SuccessCallback, errorCallback: ErrorCallback) {
        api.updateLecture(
                lectureId,
                name: newName,
                lecturerName: newLecturer,
                lectureDescription: newLectureDescription,
                successCallback: { _ in
            successCallback()
        }, errorCallback: errorCallback)
    }

}