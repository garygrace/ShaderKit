//
//  SnowfallView.swift
//  ShaderKitDemo
//
//  Snowfall shader with falling snowflakes and twinkling stars
//

import SwiftUI
import ShaderKit

struct SnowfallView: View {
  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()

      HolographicCardContainer(
        width: 260,
        height: 380,
        shadowColor: .cyan
      ) {
        ZStack {
          SimpleCardContent(
            title: "Winter",
            subtitle: "Snowfall"
          ) {
            RoundedRectangle(cornerRadius: 16)
              .fill(
                LinearGradient(
                  colors: [
                    Color(red: 0.15, green: 0.25, blue: 0.4),
                    Color(red: 0.1, green: 0.2, blue: 0.35),
                    Color(red: 0.2, green: 0.3, blue: 0.45)
                  ],
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                )
              )
              .shader(.snowfall(
                primaryColor: SIMD4<Float>(0.3, 0.5, 0.7, 1.0),
                secondaryColor: SIMD4<Float>(0.2, 0.4, 0.6, 1.0)
              ))
          }

          // Holographic silver border
          RoundedRectangle(cornerRadius: 16)
            .strokeBorder(
              LinearGradient(
                colors: [
                  Color(red: 0.85, green: 0.88, blue: 0.92),
                  Color(red: 0.95, green: 0.97, blue: 1.0),
                  Color(red: 0.75, green: 0.8, blue: 0.85),
                  Color(red: 0.95, green: 0.97, blue: 1.0),
                  Color(red: 0.85, green: 0.88, blue: 0.92)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              ),
              lineWidth: 6
            )
            .shader(.foil(intensity: 0.9))
            .shader(.glitter(density: 80))
        }
      }
    }
    .navigationTitle("Snowfall")
  }
}

#Preview {
  NavigationStack {
    SnowfallView()
  }
}
