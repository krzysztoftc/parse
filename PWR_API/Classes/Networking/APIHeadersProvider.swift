//
//  ApiHeadersProvider.swift
//  PWR_API
//
//  Created by Karol Kubicki on 31.12.2015.
//  Copyright © 2015 Karol Kubicki. All rights reserved.
//

import Foundation

protocol APIHeadersProvider {
    func addHeadersToRequest(request: NSURLRequest) -> NSURLRequest
}