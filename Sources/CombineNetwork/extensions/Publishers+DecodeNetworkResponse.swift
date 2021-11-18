//
//  Publishers+DecodeNetworkResponse.swift
//  aarons
//
//  Created by Rashaad Ramdeen on 4/28/21.
//  Copyright © 2021 Aaron's, LLC. All rights reserved.
//

import Foundation
import Combine

extension Publisher where Self.Output == URLSession.DataTaskPublisher.Output, Self.Failure == NetworkError {
    func decodeNetworkResponse<T: Decodable>(decodable: T.Type, decoder: JSONDecoder = JSONDecoder()) -> Publishers.DecodeNetworkResponse<T, Self> {
        return Publishers.DecodeNetworkResponse.init(decodable: decodable, upstream: self, decoder: decoder)
    }
}

extension Publishers {
    struct DecodeNetworkResponse<T: Decodable, Upstream: Publisher>: Publisher where Upstream.Output == URLSession.DataTaskPublisher.Output {
        typealias Output = NetworkResponse<T>
        typealias Failure = NetworkError
        
        private let decodable: T.Type
        private let upstream: Upstream
        private let decoder: JSONDecoder
        
        init(decodable: T.Type, upstream: Upstream, decoder: JSONDecoder) {
            self.decodable = decodable
            self.upstream = upstream
            self.decoder = decoder
        }
        
        func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            upstream.tryMap { (output) -> NetworkResponse<T> in
                do {
                    let decoded = try decoder.decode(self.decodable, from: output.data)
                    return NetworkResponse(value: decoded, response: output.response)
                } catch {
                    throw NetworkError.decodingCodable
                }
            }
            .mapError { .handleError(error: $0) }
            .subscribe(subscriber)
        }
        
    }
}
