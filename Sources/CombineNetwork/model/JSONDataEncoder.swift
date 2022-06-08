//
//  File.swift
//  
//
//  Created by Rashaad Ramdeen on 5/20/22.
//

import Foundation

public struct JSONDataEncoder: ParameterEncodable {
    public let options: JSONSerialization.WritingOptions
    
    public func encode(parameters: Parameters) throws -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: parameters, options: options)
        } catch {
            throw ParameterEncodableError.encodingRequestParameters(error)
        }
    }
}
