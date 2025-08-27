//
//  FilmRowView.swift
//  MobileActivity6
//
//  Created by AGRM  on 25/08/25.
//
//  Small view: renders one film row with its banner and title.
//  Clean code: single responsibility (row only).
//

import SwiftUI

struct FilmRowView: View {
    let film: Film

    // Clean: computed property for banner URL
    private var bannerURL: URL? {
        (film.movie_banner ?? film.image).flatMap(URL.init(string:))
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // AsyncImage handles loading/error successfully (no crash)
            if let url = bannerURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView() // USER FEEDBACK: loading state
                            .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 180)
                    case .success(let img):
                        img.resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 180)
                            .clipped()
                    case .failure:
                        placeholder // ROBUST: fallback image
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }

            // Legibility gradient for text
            LinearGradient(
                colors: [.black.opacity(0.0), .black.opacity(0.55)],
                startPoint: .center,
                endPoint: .bottom
            )
            .allowsHitTesting(false)

            // Row title
            Text(film.title)
                .font(.headline)
                .foregroundColor(.white)
                .shadow(radius: 2)
                .padding(.horizontal, 14)
                .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 180)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color(red: 1.0, green: 0.45, blue: 0.45), lineWidth: 4)
        )
        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 6)
        .padding(.vertical, 2)
    }

    // Placeholder shown if no image or AsyncImage fails
    private var placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.secondary.opacity(0.15))
            Image(systemName: "photo")
                .font(.title2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 180)
    }
}

