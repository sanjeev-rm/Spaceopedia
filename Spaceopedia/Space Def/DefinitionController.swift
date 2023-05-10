//
//  DefinitionController.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 10/05/23.
//

import Foundation

class DefinitionController
{
    enum DefinitionError: Error {
        case notFound
        case extendedNotFound
    }
    
    static func fetchDefinition(word: String) async throws -> DictionaryResponse {
        let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)")!

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
            throw DefinitionError.notFound
        }

        let jsonDecoder = JSONDecoder()
        let decodedDictionaryResponse = try jsonDecoder.decode([DictionaryResponse].self, from: data)
        return decodedDictionaryResponse.first!
    }
    
    static func fetchExtendedDefinition(word: String) async throws -> ExtendedDefinition {
        let url = URL(string: "https://api.api-ninjas.com/v1/dictionary?word=\(word)")!

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("TvDKORXrUAaJ6DGIvgiI6Q==b9cUEaX5qo299WPD", forHTTPHeaderField: "X-Api-Key")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
            throw DefinitionError.extendedNotFound
        }

        let jsonDecoder = JSONDecoder()
        let jsonDecodedResponse = try jsonDecoder.decode(ExtendedDefinition.self, from: data)
        return jsonDecodedResponse
    }
}
