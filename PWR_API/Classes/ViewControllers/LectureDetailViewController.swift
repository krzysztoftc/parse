//
//  LectureDetailViewController.swift
//  PWR_API
//
//  Created by Karol Kubicki on 06.01.2016.
//  Copyright © 2016 Karol Kubicki. All rights reserved.
//

import UIKit

protocol LectureDetailViewControllerDelegate: class {
    func lectureDetailVCDidUpdateLecture(lectureDetailVC: LectureDetailViewController)
}

class LectureDetailViewController: UITableViewController {
    
    enum ViewState {
        case ReadOnly
        case Edit
    }
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var lecturerTextField: UITextField!
    @IBOutlet private weak var lectureDescriptionTextField: UITextField!
    
    private var editButton: UIBarButtonItem!
    private var saveButton: UIBarButtonItem!
    
    private var state: ViewState = .ReadOnly {
        didSet {
            setUIBasedOnState()
        }
    }
    
    weak var delegate: LectureDetailViewControllerDelegate?
    
    var lecture: Lecture!
    let lecturesService = LecturesService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWithLecture()
        createBarButtons()
        setUIBasedOnState()
    }
    
    private func createBarButtons() {
        editButton = UIBarButtonItem(
            title: "Edytuj",
            style: .Plain,
            target: self,
            action: "editButtonPressed"
        )
        saveButton = UIBarButtonItem(
            title: "Zapisz",
            style: .Plain,
            target: self,
            action: "saveButtonPressed"
        )
    }
    
    private func setUIBasedOnState() {
        let allowSelection = (state == .Edit)
        let enableFields = (state == .Edit)
        let buttonToSet = (state == .Edit) ? saveButton : editButton
        tableView.allowsSelection = allowSelection
        enableAllFields(enableFields)
        navigationItem.setRightBarButtonItem(buttonToSet, animated: true)
        if state == .Edit {
            nameTextField.becomeFirstResponder()
        }
        
    }
    
    private func setupWithLecture() {
        title = lecture.name
        nameTextField.text = lecture.name
        lecturerTextField.text = lecture.lecturerName
        lectureDescriptionTextField.text = lecture.lectureDescription
    }
    
    @objc private func editButtonPressed() {
        state = .Edit
    }
    
    @objc private func saveButtonPressed() {
        guard fieldsAreValid() else {
            showEditLectureErrorMessage("Niepoprawne pola. Popraw wartości i spróbuj ponownie")
            return
        }
        lecturesService.updateLecture(lecture.objectId, newName: nameTextField.text!, newLecturer: lecturerTextField.text!, newLectureDescription: lectureDescriptionTextField.text!, successCallback: {
            self.delegate?.lectureDetailVCDidUpdateLecture(self)
        }) { error in
            self.showEditLectureErrorMessage("\(error)")
        }
    }
    
    private func showEditLectureErrorMessage(message: String) {
        showAlertView(
            title: "Błąd edycji",
            message: message,
            defaultActionTitle: "Ok"
        )
    }
    
    private func enableAllFields(enable: Bool) {
        nameTextField.enabled = enable
        lecturerTextField.enabled = enable
        lectureDescriptionTextField.enabled = enable
    }
    
    private func fieldsAreValid() -> Bool {
        guard let name = nameTextField.text,
                lecturer = lecturerTextField.text,
                lectureDescription = lectureDescriptionTextField.text else {
            return false
        }
        return !name.isEmpty && !lecturer.isEmpty && !lectureDescription.isEmpty
    }
}