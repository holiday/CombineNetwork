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
    
    public init(readingOptions: JSONSerialization.ReadingOptions = [],
                writingOptions: JSONSerialization.WritingOptions = []) {
        self.readingOptions = readingOptions
        self.writingOptions = writingOptions
    }
    
    public func encode(parameters: T) throws -> Data {
        let jsonData = try JSONEncoder().encode(parameters)
        let dict = try JSONSerialization.jsonObject(with: jsonData, options: readingOptions)
        return try JSONSerialization.data(withJSONObject: dict, options: writingOptions)
    }
}
