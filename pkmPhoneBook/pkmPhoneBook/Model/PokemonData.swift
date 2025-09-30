import Foundation

struct PokemonData: Codable {
    let id: Int
    let name: String
    let height, weight: Int
    let sprites: Sprites
}

struct Sprites: Codable {
    let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
