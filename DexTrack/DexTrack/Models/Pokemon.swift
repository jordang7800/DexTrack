import Foundation

struct Pokemon: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let abilities: [PokemonAbility]
    let types: [PokemonTypeEntry]
    let sprites: PokemonSprites
}

struct PokemonAbility: Codable {
    let ability: NamedAPIResource
}

struct PokemonTypeEntry: Codable {
    let type: NamedAPIResource
}

struct NamedAPIResource: Codable {
    let name: String
}

struct PokemonSprites: Codable {
    let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
