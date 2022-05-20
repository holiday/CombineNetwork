//
//  File.swift
//  
//
//  Created by Rashaad Ramdeen on 5/20/22.
//

import Foundation

enum ParameterEncodableError: Error {
    case encodingRequestParameters(_ error: Error)
}

public protocol ParameterEncodable {
    associatedtype Value
    func encode(parameters: Parameters) throws -> Value
}
