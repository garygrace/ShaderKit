//
//  FrozenShader.metal
//  ShaderKit
//
//  Frozen-inspired shader with super shiny icy silver background
//  and floating light blue stars - Elsa aesthetic
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
#include "ShaderUtilities.metal"
using namespace metal;

[[stitchable]] half4 frozen(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float2 tilt,
    float time,
    float intensity,
    float starDensity,
    float shimmerIntensity,
    float4 iceColor,
    float4 starColor
) {
    float2 uv = position / size;
    half4 originalColor = layer.sample(position);

    if (originalColor.a < 0.01h) {
        return originalColor;
    }

    // Ice/Frozen colors - darker base for contrast
    half3 iceSilver = half3(iceColor.x, iceColor.y, iceColor.z);
    half3 frostedBlue = half3(starColor.x, starColor.y, starColor.z);
    half3 pureWhite = half3(1.0h, 1.0h, 1.0h);
    half3 deepIce = half3(0.4h, 0.55h, 0.7h);  // Darker blue-silver
    half3 midIce = half3(0.55h, 0.7h, 0.85h);

    // === ICY SILVER BACKGROUND WITH DEPTH ===
    float2 center = float2(0.5 + tilt.x * 0.15, 0.5 + tilt.y * 0.15);
    float dist = length(uv - center);

    // Radial gradient - darker edges, brighter center
    float radialShine = 1.0 - smoothstep(0.0, 0.7, dist);
    radialShine = pow(radialShine, 1.2);

    // Ice crystal shimmer pattern - subtle
    float shimmer1 = sin(uv.x * 30.0 + uv.y * 20.0 + tilt.x * 8.0 + time * 0.5);
    float shimmer2 = sin(uv.x * 45.0 - uv.y * 35.0 + tilt.y * 6.0 + time * 0.3);
    float shimmerCombined = (shimmer1 * 0.5 + shimmer2 * 0.5) * 0.5 + 0.5;
    shimmerCombined = pow(shimmerCombined, 3.0);  // More contrast

    // Diagonal light sweep - focused shine band
    float sweepAngle = 0.7854 + tilt.x * 2.0 + tilt.y * 1.0;
    float2 sweepDir = float2(cos(sweepAngle), sin(sweepAngle));
    float sweepPos = dot(uv - 0.5, sweepDir);
    float sweep = exp(-sweepPos * sweepPos * 15.0) * 0.5;

    // Compose base - keep it somewhat dark for star contrast
    half3 silverBase = mix(deepIce, midIce, half(radialShine * 0.7));
    silverBase = mix(silverBase, iceSilver, half(shimmerCombined * shimmerIntensity * 0.3));
    silverBase += pureWhite * half(sweep * 0.4);

    // === ICE CRYSTAL FACETS - subtle ===
    float2 crystalUV = uv * 6.0;
    float2 crystalCell = floor(crystalUV);
    float2 crystalFrac = fract(crystalUV);

    float minDist = 1.0;
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            float2 neighbor = float2(float(x), float(y));
            float2 point = float2(
                hash21(crystalCell + neighbor),
                hash21(crystalCell + neighbor + 50.0)
            );
            float2 diff = neighbor + point - crystalFrac;
            float d = length(diff);
            minDist = min(minDist, d);
        }
    }

    // Subtle facet edges
    float facetEdge = smoothstep(0.02, 0.1, minDist) * (1.0 - smoothstep(0.1, 0.2, minDist));
    silverBase += half3(0.6h, 0.75h, 0.9h) * half(facetEdge * 0.15);

    // === FLOATING LIGHT BLUE STARS - MORE VISIBLE ===
    float stars = 0.0;
    half3 starColorMix = half3(0.0h);

    // Layer 1: Medium stars
    for (int layer = 0; layer < 3; layer++) {
        float layerDepth = 1.0 + float(layer) * 0.4;
        float starScale = 18.0 + float(layer) * 12.0;  // Larger stars
        float layerSeed = float(layer) * 200.0;

        // Stars float gently - sinusoidal motion
        float2 starUV = uv * starScale;
        starUV.x += sin(time * 0.4 + float(layer) * 1.5) * 1.0 * layerDepth;
        starUV.y += cos(time * 0.3 + float(layer) * 2.0) * 0.8 * layerDepth;
        starUV += tilt * 2.0 * layerDepth;

        float2 starCell = floor(starUV);
        float starRand = hash21(starCell + layerSeed);

        float threshold = 0.82 - starDensity * 0.2;  // More stars
        if (starRand > threshold) {
            float2 cellPos = fract(starUV) - 0.5;
            float2 randOffset = float2(
                hash21(starCell + layerSeed + 50.0),
                hash21(starCell + layerSeed + 100.0)
            ) - 0.5;
            cellPos -= randOffset * 0.3;

            float starDist = length(cellPos);
            float starAngle = atan2(cellPos.y, cellPos.x);

            // 4-point star with rays
            float star4 = cos(starAngle * 4.0) * 0.5 + 0.5;
            star4 = pow(star4, 2.5);

            // 6-point overlay
            float star6 = cos(starAngle * 6.0 + 0.5236) * 0.5 + 0.5;
            star6 = pow(star6, 3.0) * 0.4;

            float starShape = smoothstep(0.25, 0.0, starDist) * (star4 + star6);
            starShape += smoothstep(0.08, 0.0, starDist) * 1.5;  // Bright core

            // Gentle twinkle
            float twinkleSpeed = 2.0 + starRand * 2.5;
            float twinkle = sin(starRand * 30.0 + time * twinkleSpeed);
            twinkle = twinkle * 0.35 + 0.65;

            // Color - light blue variations
            float colorVar = hash21(starCell + layerSeed + 150.0);
            half3 thisStarColor;
            if (colorVar < 0.5) {
                thisStarColor = frostedBlue * 1.2h;  // Bright blue
            } else if (colorVar < 0.8) {
                thisStarColor = mix(frostedBlue, pureWhite, 0.4h);
            } else {
                thisStarColor = half3(0.7h, 0.9h, 1.0h);  // Pale cyan
            }

            float starIntensity = starShape * twinkle * (0.8 + float(layer) * 0.15);
            stars += starIntensity;
            starColorMix += thisStarColor * half(starIntensity);
        }
    }

    // Layer 2: Large magical stars
    float2 bigStarUV = uv * 8.0;
    bigStarUV.x += sin(time * 0.25) * 1.5;
    bigStarUV.y += cos(time * 0.2 + 1.0) * 1.2;
    bigStarUV += tilt * 2.5;

    float2 bigStarCell = floor(bigStarUV);
    float bigStarRand = hash21(bigStarCell + 500.0);

    if (bigStarRand > 0.88) {
        float2 cellPos = fract(bigStarUV) - 0.5;
        float2 randOffset = float2(
            hash21(bigStarCell + 550.0),
            hash21(bigStarCell + 600.0)
        ) - 0.5;
        cellPos -= randOffset * 0.2;

        float dist = length(cellPos);
        float angle = atan2(cellPos.y, cellPos.x);

        // 8-point star
        float star8 = cos(angle * 8.0) * 0.5 + 0.5;
        star8 = pow(star8, 2.0);

        // 4-point rotating
        float star4 = cos(angle * 4.0 + time * 0.4) * 0.5 + 0.5;
        star4 = pow(star4, 2.5) * 0.5;

        float bigStarShape = smoothstep(0.35, 0.0, dist) * (star8 + star4);
        bigStarShape += smoothstep(0.1, 0.0, dist) * 2.0;  // Very bright core

        // Outer glow
        float glow = smoothstep(0.45, 0.0, dist) * 0.4;
        bigStarShape += glow;

        // Pulsing
        float pulse = sin(bigStarRand * 20.0 + time * 1.5);
        pulse = pulse * 0.2 + 0.8;
        bigStarShape *= pulse;

        stars += bigStarShape * 1.8;
        starColorMix += half3(0.7h, 0.9h, 1.0h) * half(bigStarShape * 1.8);
    }

    // === SPARKLE DUST - more visible ===
    float dust = 0.0;
    for (int d = 0; d < 2; d++) {
        float dustScale = 80.0 + float(d) * 40.0;
        float dustSeed = float(d) * 500.0;

        float2 dustUV = uv * dustScale;
        dustUV.x += time * (3.0 + float(d) * 2.0);
        dustUV.y += sin(dustUV.x * 0.15 + time + dustSeed) * 1.5;

        float2 dustCell = floor(dustUV);
        float dustRand = hash21(dustCell + dustSeed);

        if (dustRand > 0.92) {
            float2 cellPos = fract(dustUV) - 0.5;
            float dustDist = length(cellPos);
            float dustParticle = smoothstep(0.12, 0.0, dustDist);

            float dustTwinkle = sin(dustRand * 50.0 + time * 6.0);
            dustTwinkle = max(0.0, dustTwinkle);
            dustTwinkle = pow(dustTwinkle, 1.5);

            dust += dustParticle * dustTwinkle * 0.5;
        }
    }

    // === FINAL COMPOSITION ===
    half3 result = mix(originalColor.rgb, silverBase, half(intensity * 0.7));

    // Add stars with color - more prominent
    if (stars > 0.0) {
        half3 normalizedStarColor = starColorMix / max(half(stars), 0.001h);
        result += normalizedStarColor * half(stars * intensity * 1.2);
    }

    // Add sparkle dust
    result += half3(0.8h, 0.92h, 1.0h) * half(dust * intensity);

    // Subtle vignette
    float vignette = 1.0 - smoothstep(0.5, 1.0, length(uv - 0.5) * 1.2);
    result = mix(result * 0.9h, result, half(vignette));

    return half4(clamp(result, half3(0.0h), half3(1.0h)), originalColor.a);
}
