//
//  ProductRepository.swift
//  Dog24
//
//  Created by Kalender Usta on 06.09.24.
//

import Foundation

enum ShowsFetcherError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
}

class ProductRepository {
    static var shared = ProductRepository()

    func fetchProducts() async throws -> [Product] {
        guard let url = URL(string: "http://127.0.0.1:8080/product") else {
            throw ShowsFetcherError.invalidURL
        }
        return try await fetchFromServer(url: url)
    }

    func fetchfilterRecommended() async throws -> [Product] {
        guard let url = URL(string: "http://127.0.0.1:8080/product/allRecommended") else {
            throw ShowsFetcherError.invalidURL
        }
        return try await fetchFromServer(url: url)
    }
    
    func fetchfilterNewArrivals() async throws -> [Product] {
        guard let url = URL(string: "http://127.0.0.1:8080/product/getNewArrivals") else {
            throw ShowsFetcherError.invalidURL
        }
        return try await fetchFromServer(url: url)
    }
    
    func fetchfilterBestSellers() async throws -> [Product] {
        guard let url = URL(string: "http://127.0.0.1:8080/product/getBestSellers") else {
            throw ShowsFetcherError.invalidURL
        }
        return try await fetchFromServer(url: url)
    }
    
    func fetchfilterPopularGiftss() async throws -> [Product] {
        guard let url = URL(string: "http://127.0.0.1:8080/product/getPopularGifts") else {
            throw ShowsFetcherError.invalidURL
        }
        return try await fetchFromServer(url: url)
    }
    func fetchSreachProductByTitle(title: String) async throws -> [Product] {
        guard let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "http://127.0.0.1:8080/product/search?title=\(encodedTitle)") else {
            throw ShowsFetcherError.invalidURL
        }
        
        return try await fetchFromServer(url: url)
    }
    private func fetchFromServer<T: Decodable>(url: URL) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch let urlError as URLError {
            throw ShowsFetcherError.networkError(urlError)
        } catch let decodingError as DecodingError {
            throw ShowsFetcherError.decodingError(decodingError)
        } catch {
            throw error
        }
    }
}
