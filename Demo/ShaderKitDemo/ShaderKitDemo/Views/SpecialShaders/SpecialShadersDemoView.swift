//
//  SpecialShadersDemoView.swift
//  ShaderKitDemo
//
//  Pokemon-style holographic card effects with Metal shaders
//

import SwiftUI
import ShaderKit

enum SpecialShaderType: String, CaseIterable, Identifiable {
    case basicGlare = "Basic Glare"
    case regularHolo = "Regular Holo"
    case reverseHolo = "Reverse Holo"
    case cosmosHolo = "Cosmos Holo"
    case rainbowRare = "Rainbow Rare"
    case shinyRare = "Shiny Rare"
    case pokemonV = "Pokemon V"
    case vMax = "VMax"
    case vStar = "VStar"
    case secretGold = "Secret Gold"
    case radiantHolo = "Radiant Holo"
    case amazingRare = "Amazing Rare"

    var id: String { rawValue }

    var description: String {
        switch self {
        case .basicGlare:
            return "Simple radial glare following tilt position"
        case .regularHolo:
            return "Rainbow vertical beams that shift with tilt"
        case .reverseHolo:
            return "Inverted foil effect with shine overlay"
        case .cosmosHolo:
            return "Galaxy background with rainbow gradient"
        case .rainbowRare:
            return "Glittery rainbow with luminosity blending"
        case .shinyRare:
            return "Metallic sun-pillar effect with crosshatch"
        case .pokemonV:
            return "Diagonal holographic lines creating depth"
        case .vMax:
            return "Large-scale subtle gradient with texture"
        case .vStar:
            return "V effect with radial mask fade"
        case .secretGold:
            return "Shimmering gold glitter overlay"
        case .radiantHolo:
            return "Criss-cross diamond pattern"
        case .amazingRare:
            return "Glittery metallic shimmer effect"
        }
    }

    var icon: String {
        switch self {
        case .basicGlare: return "sun.max.fill"
        case .regularHolo: return "rainbow"
        case .reverseHolo: return "rectangle.on.rectangle.angled"
        case .cosmosHolo: return "sparkles"
        case .rainbowRare: return "star.fill"
        case .shinyRare: return "diamond.fill"
        case .pokemonV: return "v.circle.fill"
        case .vMax: return "crown.fill"
        case .vStar: return "star.circle.fill"
        case .secretGold: return "dollarsign.circle.fill"
        case .radiantHolo: return "rays"
        case .amazingRare: return "wand.and.stars"
        }
    }
}

struct SpecialShadersDemoView: View {
    var body: some View {
        List(SpecialShaderType.allCases) { shaderType in
            NavigationLink(destination: SpecialShaderDetailView(shaderType: shaderType)) {
                HStack(spacing: 16) {
                    Image(systemName: shaderType.icon)
                        .font(.title2)
                        .foregroundStyle(.purple)
                        .frame(width: 32)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(shaderType.rawValue)
                            .font(.headline)
                        Text(shaderType.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Special Shaders")
    }
}

struct SpecialShaderDetailView: View {
    let shaderType: SpecialShaderType

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            HolographicCardContainer(
                width: 260,
                height: 380,
                shadowColor: shadowColor
            ) { tilt, elapsedTime in
                SimpleCardContent(
                    title: shaderType.rawValue.uppercased(),
                    subtitle: "Special Edition",
                    gradientColors: gradientColors
                )
                .drawingGroup()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        shaderEffect(size: proxy.size, tilt: tilt, time: elapsedTime),
                        maxSampleOffset: .zero
                    )
                }
            }
        }
        .navigationTitle(shaderType.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var shadowColor: Color {
        switch shaderType {
        case .basicGlare: return .white
        case .regularHolo: return .cyan
        case .reverseHolo: return .purple
        case .cosmosHolo: return .blue
        case .rainbowRare: return .pink
        case .shinyRare: return .yellow
        case .pokemonV: return .red
        case .vMax: return .orange
        case .vStar: return .yellow
        case .secretGold: return .yellow
        case .radiantHolo: return .cyan
        case .amazingRare: return .purple
        }
    }

    private var gradientColors: [Color] {
        switch shaderType {
        case .basicGlare:
            return [
                Color(red: 0.95, green: 0.9, blue: 0.8),
                Color(red: 0.9, green: 0.85, blue: 0.75),
                Color(red: 0.85, green: 0.8, blue: 0.7)
            ]
        case .regularHolo:
            return [
                Color(red: 0.15, green: 0.2, blue: 0.35),
                Color(red: 0.1, green: 0.15, blue: 0.3),
                Color(red: 0.12, green: 0.18, blue: 0.32)
            ]
        case .reverseHolo:
            return [
                Color(red: 0.25, green: 0.2, blue: 0.35),
                Color(red: 0.2, green: 0.15, blue: 0.3),
                Color(red: 0.22, green: 0.18, blue: 0.32)
            ]
        case .cosmosHolo:
            return [
                Color(red: 0.05, green: 0.05, blue: 0.15),
                Color(red: 0.08, green: 0.08, blue: 0.2),
                Color(red: 0.03, green: 0.03, blue: 0.12)
            ]
        case .rainbowRare:
            return [
                Color(red: 0.3, green: 0.2, blue: 0.4),
                Color(red: 0.25, green: 0.15, blue: 0.35),
                Color(red: 0.35, green: 0.2, blue: 0.4)
            ]
        case .shinyRare:
            return [
                Color(red: 0.2, green: 0.2, blue: 0.25),
                Color(red: 0.15, green: 0.15, blue: 0.2),
                Color(red: 0.18, green: 0.18, blue: 0.22)
            ]
        case .pokemonV:
            return [
                Color(red: 0.3, green: 0.1, blue: 0.15),
                Color(red: 0.25, green: 0.08, blue: 0.12),
                Color(red: 0.35, green: 0.12, blue: 0.18)
            ]
        case .vMax:
            return [
                Color(red: 0.35, green: 0.25, blue: 0.15),
                Color(red: 0.3, green: 0.2, blue: 0.1),
                Color(red: 0.4, green: 0.28, blue: 0.18)
            ]
        case .vStar:
            return [
                Color(red: 0.4, green: 0.35, blue: 0.2),
                Color(red: 0.35, green: 0.3, blue: 0.15),
                Color(red: 0.45, green: 0.38, blue: 0.22)
            ]
        case .secretGold:
            return [
                Color(red: 0.5, green: 0.4, blue: 0.2),
                Color(red: 0.45, green: 0.35, blue: 0.15),
                Color(red: 0.55, green: 0.42, blue: 0.22)
            ]
        case .radiantHolo:
            return [
                Color(red: 0.15, green: 0.25, blue: 0.35),
                Color(red: 0.1, green: 0.2, blue: 0.3),
                Color(red: 0.12, green: 0.22, blue: 0.32)
            ]
        case .amazingRare:
            return [
                Color(red: 0.2, green: 0.1, blue: 0.3),
                Color(red: 0.1, green: 0.1, blue: 0.2),
                Color(red: 0.15, green: 0.05, blue: 0.25)
            ]
        }
    }

    private func shaderEffect(size: CGSize, tilt: CGPoint, time: TimeInterval) -> Shader {
        switch shaderType {
        case .basicGlare:
            return ShaderLibrary.basicGlareEffect(
                .float2(size),
                .float2(tilt),
                .float(Float(time)),
                .float(0.8)
            )
        case .regularHolo:
            return ShaderLibrary.regularHoloEffect(
                .float2(size),
                .float2(tilt),
                .float(Float(time)),
                .float(0.7)
            )
        case .reverseHolo:
            return ShaderLibrary.reverseHoloEffect(
                .float2(size),
                .float2(tilt),
                .float(Float(time)),
                .float(0.65)
            )
        case .cosmosHolo:
            return ShaderLibrary.cosmosHoloEffect(
                .float2(size),
                .float2(tilt),
                .float(Float(time)),
                .float(0.7)
            )
        case .rainbowRare:
            return ShaderLibrary.rainbowRareEffect(
                .float2(size),
                .float2(tilt),
                .float(Float(time)),
                .float(0.75)
            )
        case .shinyRare:
            return ShaderLibrary.shinyRareEffect(
                .float2(size),
                .float2(tilt),
                .float(Float(time)),
                .float(0.8)
            )
        case .pokemonV:
            return ShaderLibrary.pokemonVEffect(
                .float2(size),
                .float2(tilt),
                .float(Float(time)),
                .float(0.7)
            )
        case .vMax:
            return ShaderLibrary.vMaxEffect(
                .float2(size),
                .float2(tilt),
                .float(Float(time)),
                .float(0.65)
            )
        case .vStar:
            return ShaderLibrary.vStarEffect(
                .float2(size),
                .float2(tilt),
                .float(Float(time)),
                .float(0.7)
            )
        case .secretGold:
            return ShaderLibrary.secretGoldEffect(
                .float2(size),
                .float2(tilt),
                .float(Float(time)),
                .float(0.85)
            )
        case .radiantHolo:
            return ShaderLibrary.radiantHoloEffect(
                .float2(size),
                .float2(tilt),
                .float(Float(time)),
                .float(0.75)
            )
        case .amazingRare:
            return ShaderLibrary.amazingRareEffect(
                .float2(size),
                .float2(tilt),
                .float(Float(time)),
                .float(0.8)
            )
        }
    }
}

#Preview {
    NavigationStack {
        SpecialShadersDemoView()
    }
}
