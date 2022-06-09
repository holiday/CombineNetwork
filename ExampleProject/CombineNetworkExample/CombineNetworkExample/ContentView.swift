//
//  ContentView.swift
//  CombineNetworkExample
//
//  Created by Rashaad Ramdeen on 6/9/22.
//

import SwiftUI
import Combine
import CombineNetwork

struct TestRequest: RequestBuilder {
    var url: URL = URL(string: "https://apple.com")!
}

struct ErrorResponse: Codable {
    let title: String
    let message: String
}

class ContentViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    func test_example1() {
        CN.fetch(requestBuilder: TestRequest())
            .sink { completion in
                if case let .failure(networkError) = completion {
                    print("Failure: \(networkError)")
                }
            } receiveValue: { data, response in
                print("data: \(data)")
                print("data: \(response)")
            }
            .store(in: &cancellables)
    }
}

struct ContentView: View {
    @ObservedObject var vm: ContentViewModel
    var body: some View {
        Button("Example 1") {
            vm.test_example1()
        }
    }
}

