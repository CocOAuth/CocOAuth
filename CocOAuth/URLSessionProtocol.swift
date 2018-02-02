//
//  HttpClient.swift
//  CocOAuth
//
//  Created by Marko Seifert on 02.02.18.
//  Copyright © 2018 CocOAuth. All rights reserved.
//

import Foundation

public protocol URLSessionProtocol {
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

public final class URLSessionMock : URLSessionProtocol {
    
    var url: URL?
    var request: URLRequest?
    private let dataTaskMock: URLSessionDataTaskMock
    
    public init(data: Data?, response: URLResponse?, error: Error?) {
        dataTaskMock = URLSessionDataTaskMock()
        dataTaskMock.taskResponse = (data, response, error)
    }
    
    public func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask{
        self.url = url
        self.dataTaskMock.completionHandler = completionHandler
        return self.dataTaskMock
    }
    public func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask{
        self.request = request
        self.dataTaskMock.completionHandler = completionHandler
        return self.dataTaskMock
    }
    
    final private class URLSessionDataTaskMock : URLSessionDataTask {
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        var taskResponse: (Data?, URLResponse?, Error?)?
        
        override func resume() {
            completionHandler?(taskResponse?.0, taskResponse?.1, taskResponse?.2)
        }
    }
    
}
