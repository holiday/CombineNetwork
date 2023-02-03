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

struct TestRequest2: RequestBuilder {
    var url: URL = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
}

struct Todo: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}

struct ErrorResponse: Codable {
    let title: String
    let message: String
}

@MainActor
class ContentViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private var passThroughSubject = PassthroughSubject<NetworkError, Never>()
    
    init() {
        CN.enableUnauthorizedPassThroughSubject = true
        CN.unauthorizedPassThroughSubject = passThroughSubject
        
        passThroughSubject.sink { networkError in
            print("Received 401: \(networkError)")
        }.store(in: &cancellables)
    }
    
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
    
    func test_example2() async {
        print("Testing request test_example2")
        do {
            let response = try await CN.fetch(requestBuilder: TestRequest())
            print("Finished request test_example2: \(response)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func test_example3() async {
        print("Testing request test_example3")
        do {
            let response = try await CN.fetch(requestBuilder: TestRequest2(), decodableType: Todo.self)
            print("Finished request test_example3: \(response.value)")
        } catch NetworkError.notFound {
            print("404 not found")
        } catch {
            print("Error occurred \(error.localizedDescription)")
        }
    }
}

struct ContentView: View {
    @ObservedObject var vm: ContentViewModel
    var body: some View {
        // Combine method
        Button("Example 1") {
            vm.test_example1()
        }
        
        // Async await example URLResponse
        Button("Example 2") {
            Task {
                await vm.test_example2()
            }
        }
        
        // Async await example Decodable
        Button("Example 3") {
            Task {
                await vm.test_example3()
            }
        }
    }
}

