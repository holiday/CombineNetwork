//
//  ParameterEncodingType.swift
//  
//
//  Created by Rashaad Ramdeen on 11/18/21.
//

import Foundation

public enum ParameterEncodingType {
    case urlEncoding
    case jsonEncoding(options: JSONSerialization.WritingOptions = [])
}
