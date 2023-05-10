//
//  Definition.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 10/05/23.
//

import Foundation

/**
 *** API being used : https://dictionaryapi.dev/
 */

struct DictionaryResponse: Codable {
    var word: String
    var phonetic: String?
    var phonetics: [Phonetic]
    var meanings: [Meaning]
}

struct Phonetic: Codable {
    var text: String?
    var audioUrl: String?

    enum CodingKeys: String, CodingKey {
        case text
        case audioUrl = "audio"
    }
}

struct Meaning: Codable {
    var partOfSpeech: String
    var definitions: [Definition]
}

struct Definition: Codable {
    var definition: String
    var synonyms: [String]
    var antonyms: [String]
    var example: String?
}

//Task {
//    do {
//        let dictionaryResponse = try await fetchDefinition(word: "sky")
//        print("Success\n\n\n")
//        print("Word : " + dictionaryResponse.word)
//        print("Definitions :")
//        dictionaryResponse.meanings.forEach { meaning in
//            print("-> " + meaning.definitions[0].definition)
//        }
//    } catch {
//        print("Sorry pal, we couldn't find definitions for the word you were looking for.")
//        print("You can try the search again at later time or head to the web instead.")
//    }
//}



/**
 *** API being used : https://api.api-ninjas.com/v1/dictionary?word=
 * Requires API Key.
 */

struct ExtendedDefinition: Codable {
    var definition: String
    var word: String
    var valid: Bool
}

//Task {
//    do {
//        let ninjaResponse = try await fetchNinjaDefinition(word: "star")
//        guard ninjaResponse.valid else {
//            throw ResponseError.definitionNotFound
//        }
//        print("Word : " + ninjaResponse.word)
//        print("Definition\n" + ninjaResponse.definition)
//    } catch {
//        print("Sorry pal, we couldn't find definitions for the word you were looking for.")
//        print("You can try the search again at later time or head to the web instead.")
//    }
//}
