import Foundation

struct PokemonData: Decodable {
    let id: Int
    let name: String
    let height, weight: Int
    let sprites: Sprites
}

struct Sprites: Decodable {
    let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
