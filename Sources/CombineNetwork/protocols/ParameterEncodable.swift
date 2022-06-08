//
//  File.swift
//  
//
//  Created by Rashaad Ramdeen on 5/20/22.
//

import Foundation

public struct AnyParameterEncodable<P>: ParameterEncodable {
    public typealias Parameter = P
    
    let encodeClosure: (P) throws -> Data
    
    init<T: ParameterEncodable>(parameterEncodable: T) where T.Parameter == P {
        self.encodeClosure = parameterEncodable.encode
    }
    
    public func encode(parameters: P) throws -> Data {
        try self.encodeClosure(parameters)
    }
}

public protocol ParameterEncodable {
    associatedtype Parameter
    func encode(parameters: Parameter) throws -> Data
}
