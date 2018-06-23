//
//  URLSession+Extension.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-06-21.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation

//MARK: - synchronous data request
extension URLSession {
    func synchronousDataTask(with url: URL) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = self.dataTask(with: url) {
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return (data, response, error)
    }
}
