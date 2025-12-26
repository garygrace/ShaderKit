//
//  FrozenView.swift
//  ShaderKitDemo
//
//  Frozen-inspired shader with icy silver shimmer and floating blue stars
//

import SwiftUI
import ShaderKit

struct FrozenView: View {
  var body: some View {
    ZStack {
      // Dark blue gradient background
      LinearGradient(
        colors: [
          Color(red: 0.05, green: 0.08, blue: 0.15),
          Color(red: 0.02, green: 0.05, blue: 0.12)
        ],
        startPoint: .top,
        endPoint: .bottom
      )
      .ignoresSafeArea()

      HolographicCardContainer(
        width: 260,
        height: 380,
        shadowColor: .cyan
      ) {
        ZStack {
          SimpleCardContent(
            title: "Let It Go",
            subtitle: "Frozen Magic",
            image: "santa"
          ) {
            RoundedRectangle(cornerRadius: 16)
              .fill(
                LinearGradient(
                  colors: [
                    Color(red: 0.75, green: 0.88, blue: 0.98),
                    Color(red: 0.85, green: 0.92, blue: 1.0),
                    Color(red: 0.7, green: 0.85, blue: 0.95)
                  ],
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                )
              )
              .shader(.frozen())
          }

          // Icy silver border
          RoundedRectangle(cornerRadius: 16)
            .strokeBorder(
              LinearGradient(
                colors: [
                  Color(red: 0.8, green: 0.9, blue: 1.0),
                  Color(red: 0.95, green: 0.98, blue: 1.0),
                  Color(red: 0.7, green: 0.85, blue: 0.95),
                  Color(red: 0.95, green: 0.98, blue: 1.0),
                  Color(red: 0.8, green: 0.9, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              ),
              lineWidth: 5
            )
            .shader(.frozen(intensity: 0.6, starDensity: 0.3))
        }
      }
    }
    .navigationTitle("Frozen")
  }
}

#Preview {
  NavigationStack {
    FrozenView()
  }
}
