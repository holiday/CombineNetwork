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
    let value: T
    let response: URLResponse
}
