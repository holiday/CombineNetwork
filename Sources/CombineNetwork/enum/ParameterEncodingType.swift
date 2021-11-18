//
//  File.swift
//  
//
//  Created by Rashaad Ramdeen on 11/18/21.
//

import Foundation

enum ParameterEncodingType {
    case urlEncoding
    case jsonEncoding(options: JSONSerialization.WritingOptions = [])
}
