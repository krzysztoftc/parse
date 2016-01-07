//
//  NSURLRequest+Immutability.swift
//  PWR_API
//
//  Created by Karol Kubicki on 31.12.2015.
//  Copyright © 2015 Karol Kubicki. All rights reserved.
//

import Foundation


// Funkcje pozwalające na korzystanie z NSURLRequest jako immutable 

extension NSURLRequest {
    
    func addHeaders(headers: [String : String]) -> NSURLRequest {
        let mutableRequest = mutableCopy() as! NSMutableURLRequest
        for (key, value) in headers {
            mutableRequest.addValue(value, forHTTPHeaderField: key)
        }
        return mutableRequest.copy() as! NSURLRequest
    }
    
    func addBody(body: NSData) -> NSURLRequest {
        let mutableRequest = mutableCopy() as! NSMutableURLRequest
        mutableRequest.HTTPBody = body
        return mutableRequest.copy() as! NSURLRequest
    }
    
    func setHttpMethod(httpMehtod: HttpMethod) -> NSURLRequest {
        let mutableRequest = mutableCopy() as! NSMutableURLRequest
        mutableRequest.HTTPMethod = httpMehtod.rawValue
        return mutableRequest.copy() as! NSURLRequest
    }
}