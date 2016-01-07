//
//  UIViewController+ErrorAlert.swift
//  PWR_API
//
//  Created by Karol Kubicki on 06.01.2016.
//  Copyright © 2016 Karol Kubicki. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlertView(title title: String, message: String, defaultActionTitle: String, defaultActionHandler: ((alert: UIAlertAction) -> Void)? = nil) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: defaultActionTitle, style: .Default, handler: defaultActionHandler)
        
        alertViewController.addAction(okAction)
        
        presentViewController(alertViewController, animated: true, completion: nil)
    }
}