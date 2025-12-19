//
//  HologramDemoView.swift
//  ShaderKitDemo
//
//  Demo view showcasing 6 holographic card effects
//

import SwiftUI
import ShaderKit

struct HologramDemoView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            TabView {
                CardOneView()
                CardTwoView()
                CardThreeView()
                CardFourView()
                CardFiveView()
                CardSixView()
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
        .navigationTitle("Hologram Cards")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottom) {
            Text("Tilt your device to see the effect")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))
                .padding(.bottom, 60)
        }
    }
}

// MARK: - Card One View

struct CardOneView: View {
    var body: some View {
        HolographicCardContainer(
            width: 260,
            height: 380,
            shadowColor: .orange,
            rotationMultiplier: 12
        ) { tilt, elapsedTime in
            CardOneContent()
                .cardThreeHolographicEffect(tilt: tilt, time: elapsedTime)
        }
    }
}

private struct CardOneContent: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.95, green: 0.85, blue: 0.5),
                            Color(red: 0.9, green: 0.75, blue: 0.4),
                            Color(red: 0.85, green: 0.7, blue: 0.35),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    HStack(spacing: 4) {
                        Text("STAGE 2")
                            .font(.system(size: 9, weight: .bold))
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(.black.opacity(0.7))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 3))

                        Text("Charizard")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.black)
                    }

                    Spacer()

                    HStack(spacing: 2) {
                        Text("HP")
                            .font(.system(size: 12, weight: .medium))
                        Text("180")
                            .font(.system(size: 20, weight: .bold))
                        Image(systemName: "flame.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.orange)
                    }
                    .foregroundStyle(.red)
                }
                .padding(.horizontal, 12)
                .padding(.top, 10)

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Ability")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(.red)
                            .clipShape(RoundedRectangle(cornerRadius: 4))

                        Text("Blazing Aura")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.black)
                    }
                    Text("Once during your turn, you may attach a Fire Energy from your discard pile.")
                        .font(.system(size: 9))
                        .foregroundStyle(.black.opacity(0.8))
                        .lineLimit(2)
                }
                .padding(.horizontal, 12)

                HStack {
                    HStack(spacing: 2) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(.orange)
                        Image(systemName: "flame.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(.orange)
                    }

                    Text("Fire Blast")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.black)
                        .padding(.leading, 8)

                    Spacer()

                    Text("150")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.black)
                }
                .padding(.horizontal, 12)
                .padding(.top, 8)

                Divider()
                    .padding(.horizontal, 12)
                    .padding(.top, 8)

                HStack {
                    HStack(spacing: 4) {
                        Text("weakness")
                            .font(.system(size: 8))
                        Image(systemName: "drop.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(.blue)
                        Text("x2")
                            .font(.system(size: 10, weight: .bold))
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        Text("resistance")
                            .font(.system(size: 8))
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(.green)
                        Text("-30")
                            .font(.system(size: 10, weight: .bold))
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        Text("retreat")
                            .font(.system(size: 8))
                        Image(systemName: "circle.fill")
                            .font(.system(size: 8))
                            .foregroundStyle(.gray.opacity(0.5))
                    }
                }
                .foregroundStyle(.black.opacity(0.7))
                .padding(.horizontal, 12)
                .padding(.top, 6)
                .padding(.bottom, 16)
            }

            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            .yellow.opacity(0.8),
                            .orange.opacity(0.6),
                            .yellow.opacity(0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 4
                )
        }
    }
}

// MARK: - Card Two View

struct CardTwoView: View {
    var body: some View {
        HolographicCardContainer(
            width: 280,
            height: 400,
            cornerRadius: 20,
            shadowColor: .orange
        ) { tilt, elapsedTime in
            CardTwoContent()
                .cardThreeHolographicEffect(
                    tilt: tilt,
                    time: elapsedTime,
                    intensity: 1.0
                )
        }
    }
}

private struct CardTwoContent: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [.pink, .purple, .blue, .orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(spacing: 12) {
                HStack {
                    Text("Ultra Rare")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                    Spacer()
                    Text("HP 200")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                Spacer()

                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "flame.circle.fill")
                            .foregroundStyle(.red)
                        Text("Inferno Strike")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        Spacer()
                        Text("150")
                            .font(.title3)
                            .fontWeight(.black)
                            .foregroundStyle(.orange)
                    }

                    Text("Secret Rare Holographic")
                        .font(.caption2)
                        .foregroundStyle(.yellow.opacity(0.8))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }

            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(
                    LinearGradient(
                        colors: [.orange, .yellow, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
        }
    }
}

// MARK: - Card Three View

struct CardThreeView: View {
    private let cardWidth: CGFloat = 280
    private var cardHeight: CGFloat { cardWidth * 1.4 }

    var body: some View {
        HolographicCardContainer(
            width: cardWidth,
            height: cardHeight,
            shadowColor: .purple
        ) { tilt, elapsedTime in
            CardThreeContent()
                .cardThreeHolographicEffect(
                    tilt: tilt,
                    time: elapsedTime,
                    intensity: 1.0
                )
        }
    }
}

private struct CardThreeContent: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.purple, .pink, .purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 0) {
                HStack {
                    Text("Starlight")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)

                    Spacer()

                    HStack(spacing: 4) {
                        Text("HP")
                            .font(.system(size: 12, weight: .medium))
                        Text("120")
                            .font(.system(size: 22, weight: .bold))
                    }
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                }
                .padding(.horizontal, 14)
                .padding(.top, 12)

                HStack {
                    Text("BASIC")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(.black.opacity(0.4)))

                    Spacer()

                    Image(systemName: "star.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(.yellow)
                }
                .padding(.horizontal, 14)
                .padding(.top, 6)

                Spacer()

                VStack(spacing: 12) {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "eye.fill")
                            .foregroundStyle(.purple)
                            .frame(width: 20)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Cosmic Ray")
                                .font(.system(size: 14, weight: .bold))
                            Text("Flip a coin. If heads, confusion.")
                                .font(.system(size: 9))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .foregroundStyle(.white)

                        Spacer()

                        Text("30")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 14)

                    Rectangle()
                        .fill(.white.opacity(0.2))
                        .frame(height: 1)
                        .padding(.horizontal, 14)

                    HStack(alignment: .top, spacing: 8) {
                        HStack(spacing: 2) {
                            Image(systemName: "eye.fill")
                                .foregroundStyle(.purple)
                            Image(systemName: "eye.fill")
                                .foregroundStyle(.purple)
                            Image(systemName: "star.fill")
                                .foregroundStyle(.gray)
                        }
                        .frame(width: 50, alignment: .leading)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Prismatic Burst")
                                .font(.system(size: 14, weight: .bold))
                            Text("Discard 2 Energy attached.")
                                .font(.system(size: 9))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .foregroundStyle(.white)

                        Spacer()

                        Text("100")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 14)

                    HStack {
                        VStack(spacing: 2) {
                            Text("weakness")
                                .font(.system(size: 8))
                                .foregroundStyle(.white.opacity(0.7))
                            HStack(spacing: 2) {
                                Image(systemName: "moon.fill")
                                    .font(.system(size: 10))
                                Text("+20")
                                    .font(.system(size: 9, weight: .bold))
                            }
                            .foregroundStyle(.white)
                        }

                        Spacer()

                        VStack(spacing: 2) {
                            Text("resistance")
                                .font(.system(size: 8))
                                .foregroundStyle(.white.opacity(0.7))
                            HStack(spacing: 2) {
                                Image(systemName: "figure.boxing")
                                    .font(.system(size: 10))
                                Text("-20")
                                    .font(.system(size: 9, weight: .bold))
                            }
                            .foregroundStyle(.white)
                        }

                        Spacer()

                        VStack(spacing: 2) {
                            Text("retreat cost")
                                .font(.system(size: 8))
                                .foregroundStyle(.white.opacity(0.7))
                            HStack(spacing: 2) {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 10, height: 10)
                                Circle()
                                    .fill(.white)
                                    .frame(width: 10, height: 10)
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                }
                .padding(.bottom, 12)
            }

            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.6),
                            .purple.opacity(0.8),
                            .white.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Card Four View

struct CardFourView: View {
    private let cardWidth: CGFloat = 260
    private var cardHeight: CGFloat { cardWidth * 1.4 }

    var body: some View {
        HolographicCardContainer(
            width: cardWidth,
            height: cardHeight,
            shadowColor: .yellow,
            rotationMultiplier: 12
        ) { tilt, elapsedTime in
            CardFourContent()
                .cardFourHolographicEffect(
                    tilt: tilt,
                    time: elapsedTime,
                    intensity: 1.0
                )
        }
    }
}

private struct CardFourContent: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.85, blue: 0.2),
                    Color(red: 1.0, green: 0.85, blue: 0.2).opacity(0.9),
                    Color(red: 1.0, green: 0.7, blue: 0.0).opacity(0.7)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    HStack(spacing: 6) {
                        Text("BASIC")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(.black.opacity(0.6)))

                        Text("Pikachu")
                            .font(.system(size: 22, weight: .heavy))
                            .foregroundStyle(.black)
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        Text("HP")
                            .font(.system(size: 10, weight: .medium))
                        Text("70")
                            .font(.system(size: 22, weight: .bold))
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 20))
                    }
                    .foregroundStyle(.black)
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)

                Spacer()

                VStack(spacing: 0) {
                    HStack(alignment: .top, spacing: 8) {
                        HStack(spacing: 3) {
                            ForEach(0..<3, id: \.self) { i in
                                ZStack {
                                    Circle()
                                        .fill(i < 2 ? Color(red: 1.0, green: 0.85, blue: 0.2) : Color.gray.opacity(0.4))
                                        .frame(width: 17, height: 17)
                                    Image(systemName: i < 2 ? "bolt.fill" : "star.fill")
                                        .font(.system(size: 10))
                                        .foregroundStyle(.white)
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Wild Charge")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.black)

                            Text("This Pokemon also does 30 damage to itself.")
                                .font(.system(size: 8))
                                .foregroundStyle(.black.opacity(0.8))
                                .lineLimit(2)
                        }

                        Spacer()

                        Text("90")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.black)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white.opacity(0.85))
                    )
                    .padding(.horizontal, 8)

                    Rectangle()
                        .fill(.black.opacity(0.3))
                        .frame(height: 1)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)

                    HStack {
                        HStack(spacing: 4) {
                            Text("weakness")
                                .font(.system(size: 7))
                                .foregroundStyle(.black.opacity(0.7))

                            ZStack {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 13, height: 13)
                                Image(systemName: "figure.boxing")
                                    .font(.system(size: 8))
                                    .foregroundStyle(.white)
                            }

                            Text("x2")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.black)
                        }

                        Spacer()

                        HStack(spacing: 4) {
                            Text("resistance")
                                .font(.system(size: 7))
                                .foregroundStyle(.black.opacity(0.7))
                            Text("-")
                                .font(.system(size: 9))
                                .foregroundStyle(.black.opacity(0.5))
                        }

                        Spacer()

                        HStack(spacing: 4) {
                            Text("retreat")
                                .font(.system(size: 7))
                                .foregroundStyle(.black.opacity(0.7))

                            Circle()
                                .fill(.white)
                                .stroke(.black.opacity(0.3), lineWidth: 1)
                                .frame(width: 10, height: 10)
                        }
                    }
                    .padding(.horizontal, 10)

                    Text("Pikachu can generate powerful electricity.")
                        .font(.system(size: 7).italic())
                        .foregroundStyle(.black.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 16)
                        .padding(.top, 6)

                    HStack {
                        Text("Illus. You Iribi")
                            .font(.system(size: 7))

                        Spacer()

                        Text("160/159")
                            .font(.system(size: 7, weight: .bold))
                    }
                    .foregroundStyle(.black.opacity(0.6))
                    .padding(.horizontal, 10)
                    .padding(.top, 4)
                    .padding(.bottom, 8)
                }
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.85, blue: 0.2).opacity(0.95),
                            Color(red: 1.0, green: 0.85, blue: 0.2)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }

            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.85, blue: 0.2),
                            .white.opacity(0.8),
                            Color(red: 1.0, green: 0.7, blue: 0.0),
                            .white.opacity(0.6),
                            Color(red: 1.0, green: 0.85, blue: 0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 5
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Card Five View

struct CardFiveView: View {
    private let cardWidth: CGFloat = 260
    private var cardHeight: CGFloat { cardWidth * 1.4 }

    var body: some View {
        HolographicCardContainer(
            width: cardWidth,
            height: cardHeight,
            shadowColor: .yellow,
            rotationMultiplier: 12
        ) { tilt, elapsedTime in
            ZStack {
                CardFiveBackground(width: cardWidth, height: cardHeight)
                    .cardFiveBackgroundHolo(
                        tilt: tilt,
                        time: elapsedTime,
                        intensity: 0.7,
                        saturation: 0.75
                    )
            }
            .cardFiveSweep(tilt: tilt, time: elapsedTime)
        }
    }
}

private struct CardFiveBackground: View {
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        GeometryReader { geometry in
            let w = geometry.size.width
            let h = geometry.size.height

            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.92, green: 0.85, blue: 0.55),
                        Color(red: 0.88, green: 0.8, blue: 0.45),
                        Color(red: 0.85, green: 0.75, blue: 0.4)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                VStack(spacing: 0) {
                    ZStack {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.2, green: 0.35, blue: 0.35),
                                        Color(red: 0.15, green: 0.25, blue: 0.3)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    .frame(width: w * 0.92, height: h * 0.44)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(
                                Color(red: 0.7, green: 0.6, blue: 0.3),
                                lineWidth: 3
                            )
                    )
                    .padding(.top, h * 0.03)

                    Text("NO. 248  Armor Pokemon  HT: 6'7\"  WT: 445.3 lbs.")
                        .font(.system(size: w * 0.025))
                        .foregroundStyle(.black.opacity(0.6))
                        .padding(.top, h * 0.01)

                    VStack(spacing: h * 0.012) {
                        HStack(alignment: .top, spacing: 6) {
                            HStack(spacing: 2) {
                                ForEach(0..<2, id: \.self) { _ in
                                    Circle()
                                        .fill(.white)
                                        .stroke(.black.opacity(0.3), lineWidth: 1)
                                        .frame(width: w * 0.055, height: w * 0.055)
                                }
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Raging Crash")
                                    .font(.system(size: w * 0.048, weight: .bold))
                                    .foregroundStyle(.black)

                                Text("10 damage for each damage counter on Benched Pokemon.")
                                    .font(.system(size: w * 0.026))
                                    .foregroundStyle(.black.opacity(0.75))
                                    .lineLimit(2)
                            }

                            Spacer()

                            Text("10x")
                                .font(.system(size: w * 0.055, weight: .bold))
                                .foregroundStyle(.black)
                        }
                        .padding(.horizontal, w * 0.04)

                        Rectangle()
                            .fill(.black.opacity(0.15))
                            .frame(height: 1)
                            .padding(.horizontal, w * 0.04)

                        HStack {
                            HStack(spacing: 3) {
                                Text("weakness")
                                    .font(.system(size: w * 0.022))
                                    .foregroundStyle(.black.opacity(0.6))

                                ZStack {
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: w * 0.04, height: w * 0.04)
                                    Image(systemName: "leaf.fill")
                                        .font(.system(size: w * 0.022))
                                        .foregroundStyle(.white)
                                }

                                Text("x2")
                                    .font(.system(size: w * 0.026, weight: .bold))
                                    .foregroundStyle(.black)
                            }

                            Spacer()

                            HStack(spacing: 3) {
                                Text("resistance")
                                    .font(.system(size: w * 0.022))
                                    .foregroundStyle(.black.opacity(0.6))
                                Text("-")
                                    .font(.system(size: w * 0.026))
                                    .foregroundStyle(.black.opacity(0.4))
                            }

                            Spacer()

                            HStack(spacing: 3) {
                                Text("retreat")
                                    .font(.system(size: w * 0.022))
                                    .foregroundStyle(.black.opacity(0.6))

                                ForEach(0..<3, id: \.self) { _ in
                                    Circle()
                                        .fill(.white)
                                        .stroke(.black.opacity(0.3), lineWidth: 1)
                                        .frame(width: w * 0.028, height: w * 0.028)
                                }
                            }
                        }
                        .padding(.horizontal, w * 0.04)

                        HStack {
                            Text("Illus. Nisota Niso")
                                .font(.system(size: w * 0.02))

                            Spacer()

                            HStack(spacing: 4) {
                                Image(systemName: "f.circle.fill")
                                    .font(.system(size: w * 0.025))
                                Text("043/078")
                                    .font(.system(size: w * 0.02, weight: .bold))
                                Image(systemName: "star.fill")
                                    .font(.system(size: w * 0.018))
                            }
                        }
                        .foregroundStyle(.black.opacity(0.45))
                        .padding(.horizontal, w * 0.04)
                        .padding(.bottom, h * 0.015)
                    }
                    .padding(.top, h * 0.01)
                }

                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color(red: 0.75, green: 0.65, blue: 0.3),
                                Color(red: 0.9, green: 0.85, blue: 0.5),
                                Color(red: 0.75, green: 0.65, blue: 0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 5
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .frame(width: width, height: height)
    }
}

// MARK: - Card Six View

struct CardSixView: View {
    private let cardWidth: CGFloat = 260
    private var cardHeight: CGFloat { cardWidth * 1.4 }

    private let imageWindow = SIMD4<Float>(
        0.04,
        0.11,
        0.96,
        0.55
    )

    var body: some View {
        HolographicCardContainer(
            width: cardWidth,
            height: cardHeight,
            shadowColor: .yellow,
            rotationMultiplier: 12
        ) { tilt, elapsedTime in
            CardSixContent()
                .cardSixReverseHoloEffect(
                    tilt: tilt,
                    time: elapsedTime,
                    imageWindow: imageWindow,
                    foilIntensity: 1.0
                )
        }
    }
}

private struct CardSixContent: View {
    var body: some View {
        GeometryReader { geometry in
            let w = geometry.size.width
            let h = geometry.size.height

            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.95, green: 0.9, blue: 0.6),
                        Color(red: 0.92, green: 0.85, blue: 0.5),
                        Color(red: 0.88, green: 0.8, blue: 0.45)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                VStack(spacing: 0) {
                    HStack(alignment: .top) {
                        HStack(spacing: 4) {
                            Text("BASIC")
                                .font(.system(size: w * 0.028, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(.black.opacity(0.7))
                                )

                            Text("Pikachu")
                                .font(.system(size: w * 0.07, weight: .bold))
                                .foregroundStyle(.black)
                        }

                        Spacer()

                        HStack(spacing: 3) {
                            Text("HP")
                                .font(.system(size: w * 0.032, weight: .medium))
                            Text("70")
                                .font(.system(size: w * 0.065, weight: .bold))

                            Image(systemName: "bolt.fill")
                                .font(.system(size: w * 0.05))
                                .foregroundStyle(.orange)
                        }
                        .foregroundStyle(.red)
                    }
                    .padding(.horizontal, w * 0.04)
                    .padding(.top, h * 0.025)
                    .padding(.bottom, h * 0.015)

                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.3))

                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.6),
                                        .black.opacity(0.2),
                                        .white.opacity(0.4)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    }
                    .frame(width: w * 0.92, height: h * 0.44)

                    Spacer()
                        .frame(height: h * 0.015)

                    VStack(spacing: h * 0.01) {
                        HStack(alignment: .top, spacing: 8) {
                            HStack(spacing: 2) {
                                ForEach(0..<2, id: \.self) { _ in
                                    ZStack {
                                        Circle()
                                            .fill(Color.yellow)
                                            .frame(width: w * 0.055, height: w * 0.055)
                                        Image(systemName: "bolt.fill")
                                            .font(.system(size: w * 0.032))
                                            .foregroundStyle(.black)
                                    }
                                }
                                ZStack {
                                    Circle()
                                        .fill(Color.gray.opacity(0.4))
                                        .frame(width: w * 0.055, height: w * 0.055)
                                    Image(systemName: "star.fill")
                                        .font(.system(size: w * 0.028))
                                        .foregroundStyle(.white)
                                }
                            }

                            VStack(alignment: .leading, spacing: 1) {
                                Text("Wild Charge")
                                    .font(.system(size: w * 0.045, weight: .bold))
                                    .foregroundStyle(.black)

                                Text("This Pokemon also does 30 damage to itself.")
                                    .font(.system(size: w * 0.025))
                                    .foregroundStyle(.black.opacity(0.7))
                                    .lineLimit(2)
                            }

                            Spacer()

                            Text("90")
                                .font(.system(size: w * 0.07, weight: .bold))
                                .foregroundStyle(.black)
                        }
                        .padding(.horizontal, w * 0.04)

                        Rectangle()
                            .fill(.black.opacity(0.15))
                            .frame(height: 1)
                            .padding(.horizontal, w * 0.04)

                        HStack {
                            HStack(spacing: 3) {
                                Text("weakness")
                                    .font(.system(size: w * 0.022))
                                    .foregroundStyle(.black.opacity(0.6))

                                ZStack {
                                    Circle()
                                        .fill(Color(red: 0.75, green: 0.35, blue: 0.25))
                                        .frame(width: w * 0.04, height: w * 0.04)
                                    Image(systemName: "figure.boxing")
                                        .font(.system(size: w * 0.022))
                                        .foregroundStyle(.white)
                                }

                                Text("x2")
                                    .font(.system(size: w * 0.026, weight: .bold))
                                    .foregroundStyle(.black)
                            }

                            Spacer()

                            HStack(spacing: 3) {
                                Text("resistance")
                                    .font(.system(size: w * 0.022))
                                    .foregroundStyle(.black.opacity(0.6))
                                Text("-")
                                    .font(.system(size: w * 0.026))
                                    .foregroundStyle(.black.opacity(0.4))
                            }

                            Spacer()

                            HStack(spacing: 3) {
                                Text("retreat")
                                    .font(.system(size: w * 0.022))
                                    .foregroundStyle(.black.opacity(0.6))

                                Circle()
                                    .fill(.white)
                                    .stroke(.black.opacity(0.3), lineWidth: 1)
                                    .frame(width: w * 0.03, height: w * 0.03)
                            }
                        }
                        .padding(.horizontal, w * 0.04)

                        Text("Pikachu can generate powerful electricity.")
                            .font(.system(size: w * 0.022).italic())
                            .foregroundStyle(.black.opacity(0.55))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding(.horizontal, w * 0.05)

                        HStack {
                            Text("Illus. You Iribi")
                                .font(.system(size: w * 0.02))

                            Spacer()

                            Text("160/159")
                                .font(.system(size: w * 0.02, weight: .bold))
                        }
                        .foregroundStyle(.black.opacity(0.45))
                        .padding(.horizontal, w * 0.04)
                        .padding(.bottom, h * 0.015)
                    }
                }

                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color(red: 0.8, green: 0.7, blue: 0.3),
                                Color(red: 0.95, green: 0.9, blue: 0.5),
                                Color(red: 0.8, green: 0.7, blue: 0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 4
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    HologramDemoView()
}
