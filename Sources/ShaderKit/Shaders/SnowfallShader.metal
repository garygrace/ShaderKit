//
//  SnowfallShader.metal
//  ShaderKit
//
//  Snowfall shader with falling snowflakes, twinkling stars,
//  and customizable gradient colors
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
#include "ShaderUtilities.metal"
using namespace metal;

[[stitchable]] half4 snowfall(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float2 tilt,
    float time,
    float intensity,
    float snowDensity,
    float starDensity,
    float4 primaryColor,
    float4 secondaryColor
) {
    float2 uv = position / size;
    half4 originalColor = layer.sample(position);

    if (originalColor.a < 0.01h) {
        return originalColor;
    }

    // Gradient colors
    half3 colorA = half3(primaryColor.x, primaryColor.y, primaryColor.z);
    half3 colorB = half3(secondaryColor.x, secondaryColor.y, secondaryColor.z);
    half3 accentGold = half3(1.0h, 0.84h, 0.0h);
    half3 warmWhite = half3(1.0h, 0.98h, 0.94h);

    // === GRADIENT BACKGROUND ===
    // Diagonal gradient that shifts with tilt
    float gradientAngle = 0.7854 + tilt.x * 0.3; // ~45 degrees
    float2 gradDir = float2(cos(gradientAngle), sin(gradientAngle));
    float gradientT = dot(uv - 0.5, gradDir) + 0.5;
    gradientT = clamp(gradientT, 0.0, 1.0);

    // Blend between primary and secondary colors
    half3 baseGradient = mix(colorA, colorB, half(gradientT));

    // Add subtle shimmer based on position
    float shimmer = sin(uv.x * 20.0 + uv.y * 15.0 + time * 0.5) * 0.5 + 0.5;
    shimmer *= sin(uv.x * 12.0 - uv.y * 18.0 + tilt.x * 5.0) * 0.5 + 0.5;
    shimmer = pow(shimmer, 3.0) * 0.15;
    baseGradient = mix(baseGradient, accentGold, half(shimmer));

    // === FALLING SNOWFLAKES ===
    float snow = 0.0;

    // Layer 1: Small, fast snowflakes (background)
    for (int i = 0; i < 3; i++) {
        float layerSpeed = 0.3 + float(i) * 0.15;
        float layerScale = 50.0 + float(i) * 20.0;
        float layerSeed = float(i) * 100.0;

        float2 snowUV = uv * layerScale;
        // Add falling motion - snow falls down, drifts slightly with tilt
        snowUV.y += time * layerSpeed * 10.0;
        snowUV.x += sin(snowUV.y * 0.5 + time * 0.5 + layerSeed) * 0.3;
        snowUV.x += tilt.x * 2.0;

        float2 snowCell = floor(snowUV);
        float snowRand = hash21(snowCell + layerSeed);

        if (snowRand > (0.92 - snowDensity * 0.1)) {
            float2 cellPos = fract(snowUV) - 0.5;
            float2 randOffset = float2(
                hash21(snowCell + layerSeed + 50.0),
                hash21(snowCell + layerSeed + 100.0)
            ) - 0.5;
            cellPos -= randOffset * 0.4;

            float flakeDist = length(cellPos);
            float flakeSize = 0.08 + snowRand * 0.06;
            float flake = smoothstep(flakeSize, 0.0, flakeDist);

            // Add sparkle
            float sparkle = sin(snowRand * 50.0 + time * 3.0 + tilt.x * 4.0);
            sparkle = sparkle * 0.3 + 0.7;

            snow += flake * sparkle * (0.5 + float(i) * 0.25);
        }
    }

    // Layer 2: Large, slow snowflakes (foreground) with 6-point star shape
    float2 bigSnowUV = uv * 15.0;
    bigSnowUV.y += time * 0.8;
    bigSnowUV.x += sin(bigSnowUV.y * 0.3 + time * 0.3) * 0.5;
    bigSnowUV.x += tilt.x * 1.5;

    float2 bigSnowCell = floor(bigSnowUV);
    float bigSnowRand = hash21(bigSnowCell + 500.0);

    if (bigSnowRand > 0.85) {
        float2 cellPos = fract(bigSnowUV) - 0.5;
        float2 randOffset = float2(
            hash21(bigSnowCell + 550.0),
            hash21(bigSnowCell + 600.0)
        ) - 0.5;
        cellPos -= randOffset * 0.3;

        float dist = length(cellPos);
        float angle = atan2(cellPos.y, cellPos.x);

        // 6-point snowflake pattern
        float snowflakePattern = cos(angle * 6.0) * 0.5 + 0.5;
        snowflakePattern = pow(snowflakePattern, 2.0);

        float snowflakeShape = smoothstep(0.2, 0.0, dist) * snowflakePattern;
        snowflakeShape += smoothstep(0.08, 0.0, dist) * 0.8; // Bright center

        // Gentle rotation
        float rotation = sin(bigSnowRand * 20.0 + time * 0.5);
        snowflakeShape *= (0.7 + rotation * 0.3);

        snow += snowflakeShape * 1.2;
    }

    // === TWINKLING STARS ===
    float stars = 0.0;

    // Star field with different densities
    for (int layer = 0; layer < 2; layer++) {
        float starScale = 30.0 + float(layer) * 25.0;
        float starSeed = float(layer) * 300.0;

        float2 starUV = uv * starScale;
        float2 starCell = floor(starUV);
        float starRand = hash21(starCell + starSeed);

        float threshold = 0.9 - starDensity * 0.15 + float(layer) * 0.03;
        if (starRand > threshold) {
            float2 cellPos = fract(starUV) - 0.5;
            float2 randOffset = float2(
                hash21(starCell + starSeed + 50.0),
                hash21(starCell + starSeed + 100.0)
            ) - 0.5;
            cellPos -= randOffset * 0.3;

            float starDist = length(cellPos);
            float starAngle = atan2(cellPos.y, cellPos.x);

            // 4-point star with cross pattern
            float star4 = cos(starAngle * 4.0) * 0.5 + 0.5;
            star4 = pow(star4, 4.0);
            float starShape = smoothstep(0.15, 0.0, starDist) * star4;
            starShape += smoothstep(0.04, 0.0, starDist); // Bright core

            // Twinkling based on time and tilt
            float twinkleSpeed = 2.0 + starRand * 3.0;
            float twinkle = sin(starRand * 40.0 + time * twinkleSpeed + tilt.x * 6.0 + tilt.y * 4.0);
            twinkle = pow(max(0.0, twinkle), 2.0);

            // Color variation - gold, white, or slight color tint
            float colorChoice = hash21(starCell + starSeed + 200.0);
            half3 starColor;
            if (colorChoice < 0.4) {
                starColor = accentGold;
            } else if (colorChoice < 0.6) {
                starColor = mix(warmWhite, colorA, 0.2h);
            } else if (colorChoice < 0.8) {
                starColor = mix(warmWhite, colorB, 0.15h);
            } else {
                starColor = warmWhite;
            }

            stars += starShape * twinkle * (0.8 + float(layer) * 0.4);
        }
    }

    // === LIGHT SWEEP / AURORA EFFECT ===
    // Gentle sweeping light that follows tilt
    float sweepAngle = tilt.x * 2.0 + tilt.y * 1.5;
    float sweep = sin(uv.x * 6.0 + uv.y * 4.0 + sweepAngle + time * 0.3);
    sweep = pow(max(0.0, sweep), 4.0) * 0.15;

    // Aurora-like color shift
    half3 auroraColor = mix(colorB * 1.2h, accentGold, half(uv.y));
    auroraColor = mix(auroraColor, warmWhite, 0.3h);

    // === FINAL COMPOSITION ===
    // Start with original color
    half3 result = originalColor.rgb;

    // Blend in gradient
    result = mix(result, baseGradient, half(intensity * 0.6));

    // Add aurora sweep
    result += auroraColor * half(sweep * intensity);

    // Add snow (additive, white)
    result += warmWhite * half(snow * intensity * 0.9);

    // Add stars (additive with color)
    result += half(stars * intensity) * accentGold;

    // Subtle vignette for warmth
    float vignette = 1.0 - smoothstep(0.4, 1.0, length(uv - 0.5) * 1.2);
    result = mix(result * 0.85h, result, half(vignette));

    return half4(clamp(result, half3(0.0h), half3(1.0h)), originalColor.a);
}
