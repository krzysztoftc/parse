//
//  AddLectureViewModel.swift
//  PWR_API
//
//  Created by Karol Kubicki on 06.01.2016.
//  Copyright © 2016 Karol Kubicki. All rights reserved.
//

import Foundation

enum AddLectureViewModelError: ErrorType {
    case InvalidFields(errorMessage: String)
}

struct AddLectureViewModel {
    
    private let service = LecturesService()
    
    var name: String?
    var lecturerName: String?
    var lectureDescription: String?
    
    func isValid() -> Bool {
        guard let name = name, lecturerName = lecturerName, lectureDescription = lectureDescription else {
            return false
        }
        return !lecturerName.isEmpty && !name.isEmpty && !lectureDescription.isEmpty
    }
    
    func addLecture(successCallback: SuccessCallback, errorCallback: ErrorCallback) {
        guard isValid() else {
            errorCallback(error: AddLectureViewModelError.InvalidFields(errorMessage: "Nieprawidłowe pola"))
            return
        }
        service.createLecture(
            name: name!,
            lecturerName: lecturerName!,
            lectureDescription: lectureDescription!,
            successCallback: { lecture in
                successCallback()
            }, errorCallback: errorCallback)
    }
    
}