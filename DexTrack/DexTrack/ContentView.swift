import SwiftUI

struct ContentView: View {
    @State private var pokemon: Pokemon?
    @State private var isLoading = false
    @State private var errorMessage: String?

    private let pokemonService = PokemonService()

    private let endpoint =
        "https://pokeapi.co/api/v2/pokemon/pikachu"

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    VStack(alignment: .leading, spacing: 8) {
                        Text("API Request")
                            .font(.headline)

                        Text("GET")
                            .bold()

                        Text(endpoint)
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    Button("Load Pikachu") {
                        Task {
                            await loadPokemon()
                        }
                    }
                    .buttonStyle(.borderedProminent)

                    if isLoading {
                        ProgressView("Loading...")
                    }

                    if let pokemon {
                        VStack(spacing: 12) {

                            if let imageString = pokemon.sprites.frontDefault,
                               let imageURL = URL(string: imageString) {

                                AsyncImage(url: imageURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 180, height: 180)
                            }

                            Text(pokemon.name.capitalized)
                                .font(.largeTitle)
                                .bold()

                            Text("Pokédex #\(pokemon.id)")
                            Text("Height: \(pokemon.height)")
                            Text("Weight: \(pokemon.weight)")

                            Text(
                                "Type: " +
                                pokemon.types
                                    .map { $0.type.name.capitalized }
                                    .joined(separator: ", ")
                            )

                            Text(
                                "Abilities: " +
                                pokemon.abilities
                                    .map { $0.ability.name.capitalized }
                                    .joined(separator: ", ")
                            )
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
                .padding()
            }
            .navigationTitle("DexTrack")
        }
    }

    private func loadPokemon() async {
        isLoading = true
        errorMessage = nil

        do {
            pokemon = try await pokemonService.fetchPokemon(
                named: "pikachu"
            )
        } catch {
            errorMessage =
                "Unable to load Pokémon: \(error.localizedDescription)"
        }

        isLoading = false
    }
}

#Preview {
    ContentView()
}
