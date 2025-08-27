//
//  FilmViewModel.swift
//  MobileActivity6
//
//  Created by AGRM on 25/08/25.
//
//  ViewModel: handles fetching data, managing load state, and error messages.
//  MVVM: keeps networking logic out of the view.
//

import Foundation

// MVVM: Enum for ViewModel-to-View communication of state
enum LoadState {
    case idle
    case loading // USER FEEDBACK: shows spinner
    case loaded // UI shows films
    case failed(String) // ROBUST ERROR HANDLING: readable error message for UI
}

@MainActor
final class FilmViewModel: ObservableObject {
    // Published properties: the View observes these
    @Published var films: [Film] = []
    @Published var state: LoadState = .idle

    // Clean code: endpoint centralized, no magic strings
    private let filmsEndpoint = "https://ghibliapi.vercel.app/films"

    func fetchFilms() async {
        state = .loading

        // API endpoint used: Studio Ghibli API (films)
        // Docs: https://ghibliapi.vercel.app/#tag/Films
        guard let url = URL(string: filmsEndpoint) else {
            // ROBUST ERROR HANDLING: invalid URL (safe fallback)
            state = .failed("Invalid URL.")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))

            // ROBUST ERROR HANDLING: surface API status codes as readable text
            guard let http = response as? HTTPURLResponse else {
                state = .failed("No HTTP response from server.")
                return
            }
            guard (200...299).contains(http.statusCode) else {
                state = .failed("Request failed with status: \(http.statusCode). Please try again.")
                return
            }

            // Decode JSON into models (no crash if fails)
            films = try JSONDecoder().decode([Film].self, from: data)
            state = .loaded

        } catch let urlErr as URLError {
            // ROBUST ERROR HANDLING: special case for offline
            if urlErr.code == .notConnectedToInternet {
                state = .failed("No connection. Please try again.")
            } else {
                state = .failed("Network error: \(urlErr.localizedDescription)")
            }
        } catch {
            // Catch-all: prevents crash, shows readable message
            state = .failed("Unexpected error: \(error.localizedDescription)")
        }
    }
}

