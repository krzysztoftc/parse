//
//  APIClient.swift
//  PWR_API
//
//  Created by Karol Kubicki on 31.12.2015.
//  Copyright © 2015 Karol Kubicki. All rights reserved.
//

import UIKit

enum HttpMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

enum APIError: ErrorType {
    case JSONParse
}

class APIClient {
    
    // Enum reprezentujący enpoint w api np http://www.some.api/Lecture
    private enum Endpoint: String {
        case Lecture
    }
    
    // typealias w tym przypadku skracana nam typ z którego czesto korzystamy
    typealias JSONSuccessCallback = (jsonDictionary: [String : AnyObject]) -> Void
    
    private let baseURL: NSURL
    private let headersProvider: APIHeadersProvider

    private lazy var session = NSURLSession.sharedSession()
    
    // Każde API musi mieć bazowy URL - nie będzie on zmieniany w trakcie dzialani aplikacji
    // `headersProvider` odpowiada za dodawanie naglowkow http do zapytania
    // Jest to przekazwane przez konstruktor zeby nie tworzyc silnych zaleznosci miedzy API
    // a nie standardowymi naglowkami (np Parsa wymaga pewnych naglowkow, ale byc moze w przyszlosci
    // nie bedziemy chcieli korzystac z Parsa - wtedy APIClient nie bedzie wymagal zmian
    init(baseURL: NSURL, headersProvider: APIHeadersProvider) {
        self.headersProvider = headersProvider
        self.baseURL = baseURL
    }
    
    // MARK: - Funkcje odpowiedzialne za pobieranie, tworzenie i edytowanie wykladow
    
    func createLecture(
        name: String,
        lecturerName: String,
        lectureDescription: String,
        successCallback: JSONSuccessCallback,
        errorCallback: ErrorCallback)
    {
        let request = requestToEndpoint(
            .Lecture, httpMehtod: .POST
        ).addBody(
            jsonDataFromDictionary(
                [
                    "name" : name,
                    "lecturer" : lecturerName,
                    "description" : lectureDescription
                ]
            )
        )
        sendRequest(request, successCallback: successCallback, errorCalback: errorCallback)
    }
    
    func getLectures(successCallback: JSONSuccessCallback, errorCallback: ErrorCallback) {
        let request = requestToEndpoint(.Lecture)
        sendRequest(request, successCallback: successCallback, errorCalback: errorCallback)
    }
    
    func updateLecture(lectureId: String, name: String, lecturerName: String, lectureDescription: String, successCallback: JSONSuccessCallback, errorCallback: ErrorCallback) {
        let request = requestToEndpoint(.Lecture, httpMehtod: .PUT, path: lectureId).addBody(
            jsonDataFromDictionary(
                [
                    "name" : name,
                    "lecturer" : lecturerName,
                    "description" : lectureDescription
                ]
            )
        )
        sendRequest(request, successCallback: successCallback, errorCalback: errorCallback)
    }
    // MARK: - Funkcje pomocnicze do parsowania odpowiedzi na JSON
    
    private func sendRequest(request: NSURLRequest, successCallback: JSONSuccessCallback, errorCalback: ErrorCallback) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let task = session.dataTaskWithRequest(request) { data, _, error in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.handleResponse(
                data: data,
                error: error,
                successCallback: successCallback,
                errorCalback: errorCalback
            )
        }
        task.resume()
    }
    
    private func jsonDataFromDictionary(dictionary: [String : AnyObject]) -> NSData {
        return try! NSJSONSerialization.dataWithJSONObject(dictionary, options: .PrettyPrinted)
    }
    
    // Funkcja do obslugi zapytania - sprawdzanie czy nie istnieja dane z odpowiedzia i czy nie
    // ma bledow. Kod wykonywany jest w watku glowny - gotowym do wyswietlania w UI
    private func handleResponse(
        data data: NSData?,
        error: NSError?,
        successCallback: JSONSuccessCallback,
        errorCalback: ErrorCallback)
    {
        dispatch_async(dispatch_get_main_queue()) {
            guard let resultData = data else {
                errorCalback(error: error!)
                return
            }
            guard let jsonResults = try? self.jsonDictionaryFromData(resultData) else {
                errorCalback(error: APIError.JSONParse)
                return
            }
            successCallback(jsonDictionary: jsonResults)
        }
    }
    
    // Parsowanie danych binarnych NSData do slownika z JSON
    private func jsonDictionaryFromData(data: NSData) throws -> [String : AnyObject] {
        let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        guard let jsonDictionary = jsonObject as? [String : AnyObject] else {
            throw APIError.JSONParse
        }
        return jsonDictionary
    }
    
    // Tworzenie linku do zapytania
    // endpoint (Lecture w naszym przypadku) - do ktorego miejsca zostanie wyslane zapytanie
    // httpMehtod - metoda HTTP zdefiniowana w enum HttpMethod
    // path - dodatkowa sciezka po endpoint np http://www.someapi.com/Lecture/objectId gdzie objectId to path
    private func requestToEndpoint(endpoint: Endpoint, httpMehtod: HttpMethod = .GET, path: String = "") -> NSURLRequest {
        let requestURL = baseURL.URLByAppendingPathComponent(endpoint.rawValue).URLByAppendingPathComponent(path)
        let request = headersProvider.addHeadersToRequest(
            NSURLRequest(URL: requestURL).setHttpMethod(httpMehtod)
        )
        return request
    }
    
}