//
//  SessionBuilder.swift
//  aarons
//
//  Created by Rashaad Ramdeen on 6/18/21.
//  Copyright © 2021 Aaron's, LLC. All rights reserved.
//

import Foundation

protocol SessionBuilder {
    var session: URLSession { get }
    var config: URLSessionConfiguration { get }
}
