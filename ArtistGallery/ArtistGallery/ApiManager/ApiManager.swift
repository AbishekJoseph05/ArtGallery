//
//  ApiManager.swift
//  ArtistGallery
//
//  Created by KaHa on 09/07/25.
//

import Foundation

enum ErrorResponse: Error {
    case badURL
    case invalidResponse
    case decodingFailed
    case NodataFound
}

protocol ServiceCallDelegate {
    func fetchData<T: Codable>() async throws -> T
}

public class ApiCaller: ServiceCallDelegate{
    func fetchData<T: Codable>() async throws -> T{
        guard let url = URL(string: "https://api.artic.edu/api/v1/artworks") else {
            throw ErrorResponse.badURL
        }
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ErrorResponse.invalidResponse
        }
        
        let decodeData = try JSONDecoder().decode(T.self, from: data)
        
        return decodeData
    }
}
