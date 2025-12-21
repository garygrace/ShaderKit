//
//  BasicGlareShader.metal
//  SwiftUIAnimationDemos
//
//  Simple radial glare effect following tilt position
//  Based on CSS basic.css - the simplest holographic effect
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
#include "ShaderUtilities.metal"
using namespace metal;

[[stitchable]] half4 simpleGlare(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float2 tilt,
    float time,
    float intensity,
    float2 touchPos  // Touch position in 0-1 UV space, (-1,-1) means no touch
) {
    float2 uv = position / size;
    half4 originalColor = layer.sample(position);

    // Skip transparent pixels
    if (originalColor.a < 0.01h) {
        return originalColor;
    }

    // Check if we have a valid touch position
    bool isTouching = touchPos.x >= 0.0 && touchPos.y >= 0.0;

    // No touch = no glare
    if (!isTouching) {
        return originalColor;
    }

    // Glare centered exactly on touch position
    float2 glareCenter = touchPos;

    // Glare follows finger exactly
    float dist = length(uv - glareCenter);
    float glare = smoothstep(0.45, 0.0, dist);
    glare = pow(glare, 1.5);

    float totalGlare = glare;

    half3 result = originalColor.rgb;

    // Soft light for the base glare - visible but not overpowering
    half3 glareLayer = half3(0.5h + half(totalGlare * 0.7));
    result = blendSoftLight(result, glareLayer * half(intensity));

    // Add a touch of screen blend for extra pop
    result = mix(result, result + half3(half(totalGlare * 0.25)), half(intensity));

    // Rainbow tint that follows the glare position
    float hueShift = (touchPos.x + touchPos.y) * 0.3 + time * 0.05;
    half3 tint = half3(
        0.5h + 0.5h * half(sin(hueShift * 6.28)),
        0.5h + 0.5h * half(sin((hueShift + 0.33) * 6.28)),
        0.5h + 0.5h * half(sin((hueShift + 0.66) * 6.28))
    );

    // Color tint in the glare area
    result = mix(result, blendOverlay(result, tint), half(totalGlare * 0.25 * intensity));

    return half4(clamp(result, half3(0.0h), half3(1.0h)), originalColor.a);
}
