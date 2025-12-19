//
//  ContentView.swift
//  ShaderKitDemo
//
//  Main navigation for ShaderKit demos
//

import SwiftUI

enum DemoCategory: String, CaseIterable, Identifiable {
    case hologram = "Hologram Cards"
    case specialShaders = "Special Shaders"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .hologram: return "sparkles.rectangle.stack"
        case .specialShaders: return "wand.and.stars"
        }
    }

    var description: String {
        switch self {
        case .hologram: return "6 motion-reactive holographic cards"
        case .specialShaders: return "12 Pokemon-style card effects"
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List(DemoCategory.allCases) { category in
                NavigationLink(destination: destinationView(for: category)) {
                    HStack(spacing: 16) {
                        Image(systemName: category.icon)
                            .font(.title2)
                            .foregroundStyle(.purple)
                            .frame(width: 32)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(category.rawValue)
                                .font(.headline)
                            Text(category.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("ShaderKit Demo")
        }
    }

    @ViewBuilder
    private func destinationView(for category: DemoCategory) -> some View {
        switch category {
        case .hologram:
            HologramDemoView()
        case .specialShaders:
            SpecialShadersDemoView()
        }
    }
}

#Preview {
    ContentView()
}
