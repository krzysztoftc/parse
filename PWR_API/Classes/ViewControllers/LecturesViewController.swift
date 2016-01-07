//
//  ViewController.swift
//  PWR_API
//
//  Created by Karol Kubicki on 29.12.2015.
//  Copyright © 2015 Karol Kubicki. All rights reserved.
//

import UIKit

class LecturesViewController: UITableViewController, AddLectureViewControllerDelegate, LectureDetailViewControllerDelegate {

    enum Segues: String {
        case AddLectureSegue
        case LectureDetailsSegue
    }
    
    let service = LecturesService()
    
    var lectures = [Lecture]()
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        title = "Lectures"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadLectures()
    }
    
    private func downloadLectures() {
        service.getLectures({ lectures in
            self.lectures = lectures
            self.tableView.reloadData()
        }) { error in
            print(error)
        }
    }
    
    // MARK: - Table view functions
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lectures.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("CellIdentifier")!
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lecture = lectures[indexPath.row]
        cell.textLabel?.text = lecture.name
        cell.detailTextLabel?.text = lecture.lecturerName
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(Segues.LectureDetailsSegue.rawValue, sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueValues = Segues(rawValue: segue.identifier!) else {
            return
        }
        switch segueValues {
            case .AddLectureSegue:
                handleAddLectureSegue(segue)
            case .LectureDetailsSegue:
                handleLectureDetailsSegue(segue, sender: sender!)
        }
    }
    
    private func handleAddLectureSegue(segue: UIStoryboardSegue) {
        let addLectureVC = segue.destinationViewController as! AddLectureViewController
        addLectureVC.delegate = self
    }
    
    private func handleLectureDetailsSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        let lectureDetailsVC = segue.destinationViewController as! LectureDetailViewController
        let indexPath = sender as! NSIndexPath
        lectureDetailsVC.lecture = lectures[indexPath.row]
        lectureDetailsVC.delegate = self
    }
    
    // MARK: - AddLectureViewControllerDelegate
    
    func addLectureViewControllerDidAddLecture(vc: AddLectureViewController) {
        dismissViewControllerAndDownloadLectures()
    }
    
    // MARK: - LectureDetailViewControllerDelegate
    
    func lectureDetailVCDidUpdateLecture(lectureDetailVC: LectureDetailViewController) {
        dismissViewControllerAndDownloadLectures()
    }
    
    private func dismissViewControllerAndDownloadLectures() {
        navigationController?.popViewControllerAnimated(true)
        downloadLectures()
    }

}

