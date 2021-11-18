//
//  Publishers+TryMapGeneric.swift
//  aarons
//
//  Created by Rashaad Ramdeen on 5/6/21.
//  Copyright © 2021 Aaron's, LLC. All rights reserved.
//

import Foundation
import Combine

extension Publisher {
    func tryMap<T>(to type: T.Type, readingOptions: JSONSerialization.ReadingOptions = []) -> Publishers.TryMapGeneric<T, Self> {
        return .init(type: type, upstream: self, readingOptions: [])
    }
}

extension Publishers {
    struct TryMapGeneric<T, Upstream: Publisher>: Publisher where Upstream.Output == URLSession.DataTaskPublisher.Output {
        typealias Output = T
        typealias Failure = NetworkError
        
        private var type: T.Type
        private var upstream: Upstream
        private var readingOptions: JSONSerialization.ReadingOptions
        
        init(type: T.Type, upstream: Upstream, readingOptions: JSONSerialization.ReadingOptions) {
            self.type = type
            self.upstream = upstream
            self.readingOptions = readingOptions
        }
        
        func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            upstream
            .map(\.data)
            .tryMap { (data) -> T in
                guard let object = try JSONSerialization.jsonObject(with: data, options: readingOptions) as? T else {
                    throw NetworkError.serializingJSONObject
                }
                
                return object
            }
            .mapError { e in return NetworkError.handleError(error: e) }
            .subscribe(subscriber)
        }
    }
}
