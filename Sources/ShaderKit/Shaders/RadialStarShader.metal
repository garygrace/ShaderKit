//
//  RadialStarShader.metal
//  SwiftUIAnimationDemos
//
//  VSTAR holographic effect with radial light burst
//  Smooth gradients and elegant sparkle effects
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
#include "ShaderUtilities.metal"
using namespace metal;

[[stitchable]] half4 radialStar(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float2 tilt,
    float time,
    float intensity
) {
    float2 uv = position / size;
    half4 originalColor = layer.sample(position);

    if (originalColor.a < 0.01h) {
        return originalColor;
    }

    // Dynamic center that follows tilt - creates the spotlight effect
    float2 lightCenter = float2(0.5 + tilt.x * 0.4, 0.5 + tilt.y * 0.4);
    float centerDist = length(uv - lightCenter);

    // Smooth radial falloff - the core VSTAR look
    float radialGlow = 1.0 - smoothstep(0.0, 0.7, centerDist);
    radialGlow = pow(radialGlow, 1.2);

    // Create smooth flowing rainbow based on angle from center
    float2 toCenter = uv - lightCenter;
    float angle = atan2(toCenter.y, toCenter.x);
    float hueShift = (angle + 3.14159) / (2.0 * 3.14159); // 0-1
    hueShift += tilt.x * 0.15 + tilt.y * 0.15 + time * 0.05;

    // Smooth rainbow colors
    half3 rainbow = hsv2rgb(half(fract(hueShift)), 0.6h, 1.0h);

    // Radial rays emanating from center
    float rays = sin(angle * 12.0 + time * 0.5) * 0.5 + 0.5;
    rays = pow(rays, 3.0) * radialGlow;

    // Smooth noise for subtle texture (not blocky)
    float smoothNoise = fbm(uv * 4.0 + tilt * 2.0 + time * 0.1, 3);
    smoothNoise = smoothstep(0.3, 0.7, smoothNoise);

    // Combine holographic layer
    half3 holoLayer = rainbow * half(0.5 + radialGlow * 0.5);

    // Add warm golden highlights at center
    half3 goldHighlight = half3(1.0h, 0.9h, 0.7h);
    holoLayer = mix(holoLayer, goldHighlight, half(radialGlow * 0.4));

    // Subtle rays overlay
    holoLayer += half3(half(rays * 0.15));

    // Soft texture variation (not blocky)
    holoLayer *= half(0.85 + smoothNoise * 0.15);

    // Star-shaped sparkles - random positions each cycle
    float sparkle = 0.0;
    float sparkleDensity = 30.0;
    float2 sparkleGrid = uv * sparkleDensity;
    float2 sparkleCell = floor(sparkleGrid);

    float sparkleHash = hash21(sparkleCell);
    if (sparkleHash > 0.94) {
        float sparklePhase = sparkleHash * 6.28318 + time * 2.0;
        float cycle = floor(sparklePhase / 3.14159); // Which cycle we're in
        float sparkleAnim = pow(max(0.0, sin(sparklePhase)), 3.0);

        // Random offset changes each cycle
        float2 randomOffset = float2(
            hash21(sparkleCell + cycle * 100.0) - 0.5,
            hash21(sparkleCell + cycle * 200.0 + 50.0) - 0.5
        ) * 0.8; // Stay within cell bounds

        float2 sparkleF = fract(sparkleGrid) - 0.5 - randomOffset;
        float2 p = abs(sparkleF);

        // Cross shape
        float armWidth = 0.03;
        float armLength = 0.35;
        float horizArm = smoothstep(armWidth, 0.0, p.y) * smoothstep(armLength, 0.0, p.x);
        float vertArm = smoothstep(armWidth, 0.0, p.x) * smoothstep(armLength, 0.0, p.y);
        float centerDot = smoothstep(0.07, 0.0, length(sparkleF));

        float star = max(max(horizArm, vertArm), centerDot);
        sparkle = star * sparkleAnim;
    }
    sparkle *= (0.4 + radialGlow * 0.6);

    // Blend with original image
    float blendStrength = intensity * (0.3 + radialGlow * 0.5);
    half3 result = mix(originalColor.rgb, holoLayer, half(blendStrength));

    // Screen blend for brightness boost at center
    half3 screenColor = 1.0h - (1.0h - result) * (1.0h - half3(half(radialGlow * 0.3)));
    result = mix(result, screenColor, half(radialGlow * intensity * 0.5));

    // Add sparkles - bright white stars
    result += half(sparkle * 1.5 * intensity) * half3(1.0h, 1.0h, 1.0h);

    // Subtle contrast enhancement
    result = (result - 0.5h) * 1.1h + 0.5h;

    return half4(clamp(result, half3(0.0h), half3(1.0h)), originalColor.a);
}
