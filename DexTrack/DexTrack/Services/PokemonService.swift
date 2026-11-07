import Foundation

class PokemonService {
    func fetchPokemon(named name: String) async throws -> Pokemon {
        let urlString =
            "https://pokeapi.co/api/v2/pokemon/\(name.lowercased())"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(Pokemon.self, from: data)
    }
}
