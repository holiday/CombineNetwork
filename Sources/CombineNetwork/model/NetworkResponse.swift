//
//  NetworkResponse.swift
//  
//
//  Created by Rashaad Ramdeen on 11/18/21.
//

import Foundation

/**
 Generic NetworkResponse wrapper
 */
public struct NetworkResponse<T> {
    public let value: T
    public let response: URLResponse
}
