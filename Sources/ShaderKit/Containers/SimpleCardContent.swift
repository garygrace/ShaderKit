//
//  SimpleCardContent.swift
//  ShaderKit
//
//  Reusable card content for Pokemon card holographic effects
//

import SwiftUI

public struct SimpleCardContent<Background: View>: View {
  public let title: String
  public let subtitle: String
  public let image: String
  public let background: Background

  public init(
    title: String = "HOLO CARD",
    subtitle: String = "Special Edition",
    image: String = "unicorn",
    @ViewBuilder background: () -> Background
  ) {
    self.title = title
    self.subtitle = subtitle
    self.image = image
    self.background = background()
  }

  public var body: some View {
    ZStack {
      // Background
      background
      
      // Content
      VStack(spacing: 16) {
        // Header
        HStack {
          Text(title)
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(.white)
          Spacer()
          Text("HP 200")
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(.white.opacity(0.8))
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        
        // Center artwork area
        Image(image)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .padding(.horizontal, 12)

        
        // Footer
        VStack(spacing: 8) {
          Text(subtitle)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(.white.opacity(0.7))
          
          HStack(spacing: 20) {
            Label("W", systemImage: "drop.fill")
            Label("R", systemImage: "leaf.fill")
            Label("2", systemImage: "circle.fill")
          }
          .font(.system(size: 10))
          .foregroundStyle(.white.opacity(0.5))
        }
        .padding(.bottom, 16)
      }
      
      // Border
      RoundedRectangle(cornerRadius: 16)
        .strokeBorder(
          LinearGradient(
            colors: [.white.opacity(0.3), .white.opacity(0.1)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          ),
          lineWidth: 2
        )
    }
  }
}
