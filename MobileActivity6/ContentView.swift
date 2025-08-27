//
//  ContentView.swift
//  MobileActivity6
//
//  Created by AGRM on 25/08/25.
//
//  This view displays the films list, loading state, or error UI.
//  Uses FilmViewModel for data (MVVM pattern).
//

import SwiftUI

struct ContentView: View {
    // MVVM: the view depends on its ViewModel for state + data
    @StateObject private var vm = FilmViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                // THEME: background gradient belongs to the view only
                LinearGradient(
                    colors: [
                        Color(red: 1.0, green: 0.65, blue: 0.58),
                        Color(red: 1.0, green: 0.80, blue: 0.70)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Clean Code: small header view (single responsibility)
                    HStack(spacing: 8) {
                        Image(systemName: "film.fill")
                            .foregroundStyle(.white)
                        Text("Studio Ghibli Films")
                            .font(.system(.largeTitle, design: .rounded).bold())
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        Color(red: 0.95, green: 0.45, blue: 0.45)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)

                    // Render content based on ViewModel state
                    content
                        .background(Color.clear)
                }
            }
            .navigationBarHidden(true) // Clean UI: hides default nav bar
            .navigationDestination(for: Film.self) { film in
                FilmDetailView(film: film)
            }
        }
        // USER FEEDBACK: automatically fetch on appear (shows loading spinner)
        .task { await vm.fetchFilms() }
    }

    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .idle, .loading:
            // USER FEEDBACK: shows spinner + message while fetching
            VStack(spacing: 10) {
                ProgressView()
                Text("Loading…").foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .failed(let message):
            // ROBUST ERROR HANDLING: readable error message in UI + retry button
            VStack(spacing: 14) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.orange)
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                Button("Retry") { Task { await vm.fetchFilms() } } // No crash, safe retry
                    .buttonStyle(.borderedProminent)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded:
            // CLEAN CODE: delegates row layout to FilmRowView
            List(vm.films) { film in
                NavigationLink(value: film) {
                    FilmRowView(film: film)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden) // Clean background
        }
    }
}

#Preview { ContentView() }

