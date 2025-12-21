//
//  AmazingRareShader.metal
//  SwiftUIAnimationDemos
//
//  Glittery metallic shimmer effect
//  Based on CSS amazing-rare.css
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
#include "ShaderUtilities.metal"
using namespace metal;

[[stitchable]] half4 shimmer(
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

    // Smooth flowing shimmer waves instead of grid-based glitter
    float2 waveUV1 = uv + tilt * 0.15;
    float2 waveUV2 = uv - tilt * 0.1;

    // Layer 1: diagonal flowing shimmer
    float wave1 = sin((waveUV1.x + waveUV1.y) * 12.0 + time * 2.5) * 0.5 + 0.5;
    wave1 *= sin(waveUV1.x * 8.0 - time * 1.8) * 0.5 + 0.5;
    wave1 = pow(wave1, 3.0);

    // Layer 2: cross-hatch shimmer at different frequency
    float wave2 = sin((waveUV2.x - waveUV2.y) * 15.0 + time * 3.0) * 0.5 + 0.5;
    wave2 *= sin(waveUV2.y * 10.0 + time * 2.2) * 0.5 + 0.5;
    wave2 = pow(wave2, 3.0);

    // Layer 3: circular ripple from tilt position
    float2 rippleCenter = float2(0.5 + tilt.x * 0.3, 0.5 + tilt.y * 0.3);
    float rippleDist = length(uv - rippleCenter);
    float ripple = sin(rippleDist * 25.0 - time * 4.0) * 0.5 + 0.5;
    ripple *= smoothstep(0.6, 0.0, rippleDist);
    ripple = pow(ripple, 2.0);

    // Combine shimmer layers
    float totalGlitter = max(max(wave1 * 0.6, wave2 * 0.5), ripple * 0.7);

    // Radial gradient at tilt position
    float2 radialCenter = float2(0.5 + tilt.x * 0.35, 0.5 + tilt.y * 0.35);
    float radialDist = length(uv - radialCenter);
    float radialGlow = smoothstep(0.7, 0.0, radialDist);

    // Dynamic angle sun pillar gradient
    float dynamicAngle = (tilt.x * 0.5 + tilt.y * 0.3) * 3.14159;
    float2 sunDir = float2(cos(dynamicAngle), sin(dynamicAngle));
    float sunT = dot(uv, sunDir) + 0.5;
    half3 sunPillarColor = sunPillarGradient(sunT * 3.0 + time * 0.1);

    // Foil base with color burn
    half3 foilBase = sunPillarColor * half(0.7 + radialGlow * 0.3);

    // Combine effects
    half3 holoLayer = foilBase;

    // Soft-light with glitter
    half3 glitterColor = half3(half(totalGlitter));
    holoLayer = blendSoftLight(holoLayer, glitterColor * 0.8h);

    // Color burn for depth
    holoLayer = blendColorBurn(holoLayer, sunPillarColor * 0.2h + 0.8h);

    // Overlay for shimmer
    half3 shimmerColor = half3(
        0.5h + 0.5h * half(sin(time * 2.0 + uv.x * 10.0)),
        0.5h + 0.5h * half(sin(time * 2.0 + uv.y * 10.0 + 1.0)),
        0.5h + 0.5h * half(sin(time * 2.0 + (uv.x + uv.y) * 5.0 + 2.0))
    );
    holoLayer = blendOverlay(holoLayer, shimmerColor * 0.2h);

    // Lighten blend
    holoLayer = blendLighten(holoLayer, half3(half(radialGlow * 0.4)));

    // Saturation blend (simulate CSS saturation blend)
    half lum = dot(holoLayer, half3(0.299h, 0.587h, 0.114h));
    half3 saturatedLayer = mix(half3(lum), holoLayer, 1.5h);
    holoLayer = mix(holoLayer, saturatedLayer, 0.3h);

    // Overlay glare based on radial glow
    half3 glareColor = half3(half(radialGlow));
    holoLayer = blendOverlay(holoLayer, glareColor * 0.4h);

    // Mix with original
    half3 result = mix(originalColor.rgb, holoLayer, half(intensity * 0.75));

    // Add sparkle highlights
    result += half(totalGlitter * 1.2 * intensity) * half3(1.0h, 0.98h, 0.95h);

    // Brightness and contrast
    result *= 0.95h;
    result = (result - 0.5h) * 1.2h + 0.5h;

    return half4(clamp(result, half3(0.0h), half3(1.0h)), originalColor.a);
}
