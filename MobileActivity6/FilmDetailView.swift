//
//  FilmDetailView.swift
//  MobileActivity6
//
//  View (MVVM): Presents details for a single Film.
//

import SwiftUI

struct FilmDetailView: View {
    let film: Film  // Model inserted by navigation (MVVM: data flows from VM -> View)

    // THEME: centralize magic numbers/colors (clean code)
    private let corner: CGFloat = 18
    private let cardOpacity: Double = 0.45
    private let cardStrokeOpacity: Double = 0.55 // Kept for consistency. Stroke uses solid color below
    private let iconTint = Color.orange

    var body: some View {
        ZStack {
            // VIEW-ONLY CONCERN (MVVM): background styling stays in the View
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.65, blue: 0.58),
                    Color(red: 1.0, green: 0.80, blue: 0.70)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {

                    // POSTER
                    // USER FEEDBACK + ROBUST UX:
                    // AsyncImage shows ProgressView while loading (feedback).
                    // On failure, it shows a system placeholder image instead of crashing.
                    if let url = film.image.flatMap(URL.init(string:)) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                // Loading state for the image (feedback)
                                ProgressView()
                                    .frame(height: 180)
                                    .frame(maxWidth: .infinity)

                            case .success(let img):
                                // Success: render poster nicely!
                                img.resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 190)
                                    .clipShape(RoundedRectangle(cornerRadius: corner))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: corner)
                                            .stroke(Color.white.opacity(0.6), lineWidth: 0.8)
                                    )
                                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 6)
                                    .frame(maxWidth: .infinity)

                            case .failure:
                                // Robust error handling for image load: friendly fallback, no crash
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 180)
                                    .foregroundColor(.secondary)

                            @unknown default:
                                // Avoids crashing on new phases
                                EmptyView()
                            }
                        }
                    }

                    // TITLES
                    // Clean code: simple, focused subview chunk (single responsibility: display text)
                    VStack(alignment: .leading, spacing: 6) {
                        Text(film.title)
                            .font(.system(.largeTitle, design: .rounded).bold())
                            .foregroundColor(.primary)

                        if let jp = film.original_title, !jp.isEmpty {
                            Text(jp)
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        if let roman = film.original_title_romanised, !roman.isEmpty {
                            Text(roman)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)

                    // INFO CARD
                    // Clean code: it handles layout/styling only (no business logic).
                    VStack(alignment: .leading, spacing: 12) {
                        if let year = film.release_date, !year.isEmpty {
                            Label("Release Year: \(year)", systemImage: "calendar")
                                .symbolRenderingMode(.hierarchical)
                        }
                        if let runtime = film.running_time, !runtime.isEmpty {
                            Label("Running Time: \(runtime) min", systemImage: "clock")
                                .symbolRenderingMode(.hierarchical)
                        }
                        if let score = film.rt_score, !score.isEmpty {
                            HStack(spacing: 8) {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(iconTint)
                                Text("Rotten Tomatoes: \(score)")
                            }
                        }
                        if let director = film.director, !director.isEmpty {
                            Label("Director: \(director)", systemImage: "person")
                                .symbolRenderingMode(.hierarchical)
                        }
                        if let producer = film.producer, !producer.isEmpty {
                            Label("Producer: \(producer)", systemImage: "person.2")
                                .symbolRenderingMode(.hierarchical)
                        }
                    }
                    .font(.system(.subheadline, design: .rounded))
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        // Subtle “glass” card. Subtle enough for dark text (accessibility)
                        RoundedRectangle(cornerRadius: corner)
                            .fill(Color.white.opacity(cardOpacity))
                    )
                    .overlay(
                        // Theming: consistent stroke color around cards
                        RoundedRectangle(cornerRadius: corner)
                            .stroke(
                                Color(red: 0.95, green: 0.45, blue: 0.45)
                                    .opacity(1.0),
                                lineWidth: 4
                            )
                    )
                    .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 6)
                    .padding(.horizontal)

                    // DESCRIPTION CARD
                    // Clean code: separates section, shows text if present, no heavy logic
                    if let desc = film.description, !desc.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 8) {
                                Image(systemName: "text.book.closed")
                                    .symbolRenderingMode(.hierarchical)
                                Text("Synopsis")
                                    .font(.system(.headline, design: .rounded))
                            }
                            Text(desc)
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: corner)
                                .fill(Color.white.opacity(cardOpacity))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: corner)
                                .stroke(
                                    Color(red: 0.95, green: 0.45, blue: 0.45),
                                    lineWidth: 4
                                )
                        )
                        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 6)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 22)
            }
        }
        // Clean UI: title is provided by the model
        .navigationTitle(film.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    // Preview uses a test model (clean code: no network in previews)
    FilmDetailView(film: .init(
        id: "test",
        title: "Castle in the Sky",
        original_title: "天空の城ラピュタ",
        original_title_romanised: "Tenkū no shiro Rapyuta",
        description: "The orphan Sheeta inherited a crystal that links her to a mythical kingdom. With Pazu and sky pirates, she journeys to Laputa while evading Muska.",
        director: "Hayao Miyazaki",
        producer: "Isao Takahata",
        release_date: "1986",
        running_time: "124",
        rt_score: "95",
        image: "https://via.placeholder.com/300x450",
        movie_banner: nil
    ))
}

