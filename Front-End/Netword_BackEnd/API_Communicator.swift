//
//  API Communicator.swift
//  Front-End page
//
//  Created by Linh Yui on 5/3/25.
//

import Foundation

class APICommunicator {
    static let shared = APICommunicator()
    
    func fetchRandomTip() async throws -> String {
        guard let url = URL(string: Endpoint.EnvironmentalAPI.tips) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode([String: String].self, from: data)
        return decoded["message"] ?? "No tip available"
    }
    
    func completeAction(id: Int) async throws {
        guard let url = URL(string: Endpoint.EnvironmentalAPI.completeAction) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["action_id": id]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        _ = try await URLSession.shared.data(for: request)
    }
}
