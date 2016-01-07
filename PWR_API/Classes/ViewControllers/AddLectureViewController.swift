//
//  AddLectureViewController.swift
//  PWR_API
//
//  Created by Karol Kubicki on 02.01.2016.
//  Copyright © 2016 Karol Kubicki. All rights reserved.
//

import Foundation
import UIKit

protocol AddLectureViewControllerDelegate: class {
    func addLectureViewControllerDidAddLecture(vc: AddLectureViewController)
}

// TODO
// W storyboardzie Main do widoku AddLectureViewController dodaj: 
// 1. Pola UITextField z nazwa wykładu, nazwą prowadzącego i opisem wykładu
// 2. Przycisk UIButton z akcją dodawania wykładu
// 3. Na wszystkim AutoLayout
// 4. Podepnij widoku pod pola w tym kontrolerze

class AddLectureViewController: UITableViewController {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var lecturerNameTextField: UITextField!
    @IBOutlet private weak var lectureDescriptionTextField: UITextField!
    
    weak var delegate: AddLectureViewControllerDelegate?
    
    private let service = LecturesService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dodaj"
    }
    
    @IBAction private func addButtonPressed(sender: UIButton) {
        if areFieldsValid() {
            // TODO
            // Wywołaj odpowiednią funkcję na obiekcie `service` z odpowiednimi
            // polami z widoku
            //
            // Wywołaj odpowiednią funkcję delegata aby powiadomić o udanym stowrzeniu obiektu
            // lub obsłuż błąd
            service.createLecture(name: nameTextField.text!, lecturerName: lecturerNameTextField.text!, lectureDescription: lectureDescriptionTextField.text!, successCallback: {lecture in
                    self.delegate?.addLectureViewControllerDidAddLecture(self)
                }, errorCallback: {error in
                    
            })
        } else {
            showAddErrorWithMessage("Niepoprawne pola. Popraw i spróbuj ponownie")
        }
    }
    
    func areFieldsValid() -> Bool {
        guard let name = nameTextField.text,
                lecturerName = lecturerNameTextField.text,
                lectureDescription = lectureDescriptionTextField.text else {
            return false
        }
        return !lecturerName.isEmpty && !name.isEmpty && !lectureDescription.isEmpty
    }
    
    private func showAddErrorWithMessage(message: String) {
        showAlertView(title: "Błąd dodawania", message: message, defaultActionTitle: "Ok")
    }
}