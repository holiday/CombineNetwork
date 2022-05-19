//
//  SessionBuilder.swift
//
//  Created by Rashaad Ramdeen on 6/18/21.
//

import Foundation

public protocol SessionBuilder {
    var session: URLSession { get }
    var config: URLSessionConfiguration { get }
}
