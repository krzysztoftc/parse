//
//  ParseApiHeadersProvider.swift
//  PWR_API
//
//  Created by Karol Kubicki on 31.12.2015.
//  Copyright © 2015 Karol Kubicki. All rights reserved.
//

import Foundation

class ParseAPIHeadersProvider: APIHeadersProvider {
    
    private let parseApplicationId = "V7AL481DPq9gF0HrYgnzSRNlafVU0nl4iPFivsjn"
    private let parseRestApiKey = "iY4djqCt7lgamaHAMq0Mh8UVQG6o2HGYxG9ale5W"
    
    func addHeadersToRequest(request: NSURLRequest) -> NSURLRequest {
        return request.addHeaders(
            [
                "X-Parse-Application-Id" : parseApplicationId,
                "X-Parse-REST-API-Key" : parseRestApiKey,
                "Content-Type" : "application/json"
            ]
        )
    }
}