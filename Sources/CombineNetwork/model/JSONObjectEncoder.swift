//
//  File.swift
//  
//
//  Created by Rashaad Ramdeen on 6/8/22.
//

import Foundation

public struct JSONObjectEncoder<T>: ParameterEncodable where T: Encodable {

    public typealias Parameter = T
    
    public let readingOptions: JSONSerialization.ReadingOptions
    public let writingOptions: JSONSerialization.WritingOptions
    
    public func encode(parameters: T) throws -> Data {
        let jsonData = try JSONEncoder().encode(parameters)
        let dict = try JSONSerialization.jsonObject(with: jsonData, options: readingOptions)
        return try JSONSerialization.data(withJSONObject: dict, options: writingOptions)
    }
}
