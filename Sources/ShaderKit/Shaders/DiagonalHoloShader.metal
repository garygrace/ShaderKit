//
//  PokemonVShader.metal
//  SwiftUIAnimationDemos
//
//  Diagonal holographic effect with parallel lines creating 3D depth
//  Based on CSS v-regular.css
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
#include "ShaderUtilities.metal"
using namespace metal;

[[stitchable]] half4 diagonalHolo(
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

    // Diagonal direction (133 degrees)
    float diagAngle = 133.0 * 3.14159 / 180.0;
    float2 diagDir = float2(cos(diagAngle), sin(diagAngle));

    // Diagonal position shifts with tilt for parallax
    float diagT = dot(uv + tilt * 0.25, diagDir);

    // Smooth rainbow colors along diagonal
    half3 rainbow = half3(
        0.5h + 0.5h * half(sin((diagT * 5.0 + tilt.x * 2.0) * 6.28)),
        0.5h + 0.5h * half(sin((diagT * 5.0 + tilt.x * 2.0 + 0.33) * 6.28)),
        0.5h + 0.5h * half(sin((diagT * 5.0 + tilt.x * 2.0 + 0.66) * 6.28))
    );

    // Thin diagonal light streaks
    float streaks = sin(diagT * 30.0) * 0.5 + 0.5;
    streaks = pow(streaks, 4.0); // Very thin lines

    // Radial light position follows tilt
    float2 lightPos = float2(0.5 + tilt.x * 0.3, 0.5 + tilt.y * 0.3);
    float lightDist = length(uv - lightPos);
    float radialGlow = smoothstep(0.7, 0.0, lightDist);

    // Keep original image perfectly sharp
    half3 result = originalColor.rgb;

    // Add rainbow streaks (pure additive - no blending that affects sharpness)
    result += rainbow * half(streaks * intensity * 0.25);

    // Add subtle overall rainbow tint (very light)
    result += rainbow * half(intensity * 0.08);

    // Add radial highlight
    result += half3(half(radialGlow * intensity * 0.12));

    return half4(clamp(result, half3(0.0h), half3(1.0h)), originalColor.a);
}
