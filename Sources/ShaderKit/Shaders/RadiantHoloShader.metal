//
//  RadiantHoloShader.metal
//  SwiftUIAnimationDemos
//
//  Criss-cross diamond pattern with intense brightness
//  Based on CSS radiant-holo.css
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
#include "ShaderUtilities.metal"
using namespace metal;

[[stitchable]] half4 crisscrossHolo(
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

    // Two diagonal directions for criss-cross
    float angle1 = 45.0 * 3.14159 / 180.0;
    float angle2 = -45.0 * 3.14159 / 180.0;
    float2 dir1 = float2(cos(angle1), sin(angle1));
    float2 dir2 = float2(cos(angle2), sin(angle2));

    // Diagonal positions with tilt parallax
    float diag1 = dot(uv + tilt * 0.2, dir1);
    float diag2 = dot(uv + tilt * 0.2, dir2);

    // Smooth crossing lines (not harsh bars)
    float line1 = sin(diag1 * 40.0) * 0.5 + 0.5;
    float line2 = sin(diag2 * 40.0) * 0.5 + 0.5;
    line1 = pow(line1, 3.0); // Thin the lines
    line2 = pow(line2, 3.0);

    // Diamond pattern where lines cross
    float diamond = max(line1, line2);

    // Rainbow colors that shift along diagonal with tilt
    half3 rainbow1 = half3(
        0.5h + 0.5h * half(sin((diag1 * 6.0 + tilt.x * 3.0) * 6.28)),
        0.5h + 0.5h * half(sin((diag1 * 6.0 + tilt.x * 3.0 + 0.33) * 6.28)),
        0.5h + 0.5h * half(sin((diag1 * 6.0 + tilt.x * 3.0 + 0.66) * 6.28))
    );
    half3 rainbow2 = half3(
        0.5h + 0.5h * half(sin((diag2 * 6.0 + tilt.y * 3.0) * 6.28)),
        0.5h + 0.5h * half(sin((diag2 * 6.0 + tilt.y * 3.0 + 0.33) * 6.28)),
        0.5h + 0.5h * half(sin((diag2 * 6.0 + tilt.y * 3.0 + 0.66) * 6.28))
    );

    // Blend the two rainbow directions
    half3 rainbow = mix(rainbow1, rainbow2, 0.5h);

    // Radial glow that follows tilt
    float2 lightPos = float2(0.5 + tilt.x * 0.3, 0.5 + tilt.y * 0.3);
    float radialGlow = smoothstep(0.8, 0.0, length(uv - lightPos));

    // Keep original image sharp
    half3 result = originalColor.rgb;

    // Add rainbow along the crossing lines (additive)
    result += rainbow * half(diamond * intensity * 0.35);

    // Add subtle overall rainbow tint
    result += rainbow * half(intensity * 0.1);

    // Add radial highlight
    result += half3(half(radialGlow * intensity * 0.15));

    // Slight saturation boost
    half lum = dot(result, half3(0.299h, 0.587h, 0.114h));
    result = mix(half3(lum), result, 1.15h);

    return half4(clamp(result, half3(0.0h), half3(1.0h)), originalColor.a);
}
