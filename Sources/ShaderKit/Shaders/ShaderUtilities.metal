//
//  ShaderUtilities.metal
//  SwiftUIAnimationDemos
//
//  Shared utility functions for Pokemon card holographic effects
//  Includes blend modes, gradients, noise, and procedural textures
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// =============================================================================
// MARK: - Color Space Conversions
// =============================================================================

/// Convert RGB to HSV color space
static half3 rgb2hsv(half3 c) {
    half4 K = half4(0.0h, -1.0h / 3.0h, 2.0h / 3.0h, -1.0h);
    half4 p = mix(half4(c.bg, K.wz), half4(c.gb, K.xy), step(c.b, c.g));
    half4 q = mix(half4(p.xyw, c.r), half4(c.r, p.yzx), step(p.x, c.r));

    half d = q.x - min(q.w, q.y);
    half e = 1.0e-7h;  // Minimum for half is ~5.96e-8
    return half3(abs(q.z + (q.w - q.y) / (6.0h * d + e)), d / (q.x + e), q.x);
}

/// Convert HSV to RGB color space
static half3 hsv2rgb(half3 c) {
    half4 K = half4(1.0h, 2.0h / 3.0h, 1.0h / 3.0h, 3.0h);
    half3 p = abs(fract(c.xxx + K.xyz) * 6.0h - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0h, 1.0h), c.y);
}

/// Convert HSV to RGB color space (3-parameter overload)
static half3 hsv2rgb(half h, half s, half v) {
    return hsv2rgb(half3(h, s, v));
}

/// Get luminance of a color
static half luminance(half3 c) {
    return dot(c, half3(0.299h, 0.587h, 0.114h));
}

// =============================================================================
// MARK: - Blend Modes (CSS-equivalent)
// =============================================================================

/// Color Dodge: Brightens base color to reflect blend color
static half3 blendColorDodge(half3 base, half3 blend) {
    return min(half3(1.0h), base / max(1.0h - blend, half3(0.001h)));
}

/// Color Burn: Darkens base color to reflect blend color
static half3 blendColorBurn(half3 base, half3 blend) {
    return 1.0h - min(half3(1.0h), (1.0h - base) / max(blend, half3(0.001h)));
}

/// Multiply: Darkens by multiplying colors
static half3 blendMultiply(half3 base, half3 blend) {
    return base * blend;
}

/// Screen: Lightens by inverting, multiplying, and inverting again
static half3 blendScreen(half3 base, half3 blend) {
    return 1.0h - (1.0h - base) * (1.0h - blend);
}

/// Overlay: Combines multiply and screen
static half3 blendOverlay(half3 base, half3 blend) {
    half3 result;
    result.r = base.r < 0.5h ? (2.0h * base.r * blend.r) : (1.0h - 2.0h * (1.0h - base.r) * (1.0h - blend.r));
    result.g = base.g < 0.5h ? (2.0h * base.g * blend.g) : (1.0h - 2.0h * (1.0h - base.g) * (1.0h - blend.g));
    result.b = base.b < 0.5h ? (2.0h * base.b * blend.b) : (1.0h - 2.0h * (1.0h - base.b) * (1.0h - blend.b));
    return result;
}

/// Hard Light: Similar to overlay but swapped
static half3 blendHardLight(half3 base, half3 blend) {
    return blendOverlay(blend, base);
}

/// Soft Light: Gentler version of overlay
static half3 blendSoftLight(half3 base, half3 blend) {
    half3 result;
    for (int i = 0; i < 3; i++) {
        if (blend[i] < 0.5h) {
            result[i] = base[i] - (1.0h - 2.0h * blend[i]) * base[i] * (1.0h - base[i]);
        } else {
            half d = base[i] < 0.25h ?
                ((16.0h * base[i] - 12.0h) * base[i] + 4.0h) * base[i] :
                sqrt(base[i]);
            result[i] = base[i] + (2.0h * blend[i] - 1.0h) * (d - base[i]);
        }
    }
    return result;
}

/// Difference: Subtracts darker from lighter
static half3 blendDifference(half3 base, half3 blend) {
    return abs(base - blend);
}

/// Exclusion: Similar to difference but lower contrast
static half3 blendExclusion(half3 base, half3 blend) {
    return base + blend - 2.0h * base * blend;
}

/// Lighten: Takes the lighter of two colors
static half3 blendLighten(half3 base, half3 blend) {
    return max(base, blend);
}

/// Darken: Takes the darker of two colors
static half3 blendDarken(half3 base, half3 blend) {
    return min(base, blend);
}

/// Hue: Applies hue from blend to base
static half3 blendHue(half3 base, half3 blend) {
    half3 baseHSV = rgb2hsv(base);
    half3 blendHSV = rgb2hsv(blend);
    return hsv2rgb(half3(blendHSV.x, baseHSV.y, baseHSV.z));
}

/// Saturation: Applies saturation from blend to base
static half3 blendSaturation(half3 base, half3 blend) {
    half3 baseHSV = rgb2hsv(base);
    half3 blendHSV = rgb2hsv(blend);
    return hsv2rgb(half3(baseHSV.x, blendHSV.y, baseHSV.z));
}

/// Luminosity: Applies luminosity from blend to base
static half3 blendLuminosity(half3 base, half3 blend) {
    half baseLum = luminance(base);
    half blendLum = luminance(blend);
    half lumDiff = blendLum - baseLum;
    half3 result = base + lumDiff;
    return clamp(result, half3(0.0h), half3(1.0h));
}

// =============================================================================
// MARK: - Color Adjustments (CSS filter equivalents)
// =============================================================================

/// Adjust brightness (multiply RGB by factor)
static half3 adjustBrightness(half3 color, float brightness) {
    return color * half(brightness);
}

/// Adjust contrast ((color - 0.5) * contrast + 0.5)
static half3 adjustContrast(half3 color, float contrast) {
    return (color - 0.5h) * half(contrast) + 0.5h;
}

/// Adjust saturation using HSV
static half3 adjustSaturation(half3 color, float saturation) {
    half3 hsv = rgb2hsv(color);
    hsv.y *= half(saturation);
    hsv.y = clamp(hsv.y, 0.0h, 1.0h);
    return hsv2rgb(hsv);
}

// =============================================================================
// MARK: - Noise Functions
// =============================================================================

/// Simple hash function for pseudo-random values
static float hash11(float p) {
    p = fract(p * 0.1031);
    p *= p + 33.33;
    p *= p + p;
    return fract(p);
}

/// 2D hash for pseudo-random values
static float hash21(float2 p) {
    float3 p3 = fract(float3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

/// 2D value noise
static float valueNoise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);

    float a = hash21(i);
    float b = hash21(i + float2(1.0, 0.0));
    float c = hash21(i + float2(0.0, 1.0));
    float d = hash21(i + float2(1.0, 1.0));

    float2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

/// Fractal Brownian Motion (layered noise)
static float fbm(float2 p, int octaves) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;

    for (int i = 0; i < octaves; i++) {
        value += amplitude * valueNoise(p * frequency);
        amplitude *= 0.5;
        frequency *= 2.0;
    }

    return value;
}

/// Voronoi noise for cellular patterns
static float voronoi(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);

    float minDist = 1.0;

    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            float2 neighbor = float2(float(x), float(y));
            float2 point = float2(hash21(i + neighbor), hash21(i + neighbor + 100.0));
            float2 diff = neighbor + point - f;
            float dist = length(diff);
            minDist = min(minDist, dist);
        }
    }

    return minDist;
}

// =============================================================================
// MARK: - Procedural Textures
// =============================================================================

/// Glitter/sparkle pattern
static float glitterPattern(float2 uv, float seed, float density, float time) {
    float2 cell = floor(uv * density);
    float cellHash = hash21(cell + seed);

    // Sparkle probability
    float sparkle = step(0.85, cellHash);

    // Animate sparkle intensity
    float phase = cellHash * 6.28318 + time * 3.0;
    float intensity = pow(max(0.0, sin(phase)), 8.0);

    return sparkle * intensity;
}

/// Dual layer glitter (like CSS dual glitter layers)
static float dualGlitter(float2 uv, float time, float2 offset1, float2 offset2) {
    float glitter1 = glitterPattern(uv + offset1, 0.0, 60.0, time);
    float glitter2 = glitterPattern(uv + offset2, 100.0, 80.0, time * 1.3);
    return max(glitter1, glitter2);
}

/// Foil shimmer texture
static float foilPattern(float2 uv, float time, float2 tilt) {
    float noise1 = fbm(uv * 8.0 + tilt * 0.5, 4);
    float noise2 = fbm(uv * 16.0 - tilt * 0.3 + time * 0.1, 3);
    return mix(noise1, noise2, 0.5);
}

/// Galaxy/cosmos procedural background
static half3 galaxyPattern(float2 uv, float time) {
    // Stars
    float stars = pow(hash21(floor(uv * 200.0)), 20.0);

    // Nebula clouds
    float nebula1 = fbm(uv * 3.0 + time * 0.02, 5);
    float nebula2 = fbm(uv * 2.0 - time * 0.01 + 100.0, 4);

    // Color the nebula
    half3 color1 = half3(0.1h, 0.0h, 0.3h); // Purple
    half3 color2 = half3(0.0h, 0.1h, 0.4h); // Blue
    half3 color3 = half3(0.3h, 0.0h, 0.2h); // Magenta

    half3 nebula = mix(color1, color2, half(nebula1));
    nebula = mix(nebula, color3, half(nebula2 * 0.5));

    // Add stars
    nebula += half(stars) * half3(1.0h, 1.0h, 1.0h);

    return nebula;
}

/// Film grain texture
static float filmGrain(float2 uv, float time) {
    return hash21(uv * 1000.0 + time * 100.0);
}

/// Diamond grid pattern
static float diamondGrid(float2 uv, float2 offset, float width, float height) {
    float2 scaled = float2(uv.x * width, uv.y * height) + offset;

    // Offset every other row
    float row = floor(scaled.y);
    if (fmod(row, 2.0) == 1.0) {
        scaled.x += 0.5;
    }

    float2 cell = fract(scaled) - 0.5;
    float dist = abs(cell.x) * 2.0 + abs(cell.y);

    return smoothstep(0.5, 0.35, dist);
}

// =============================================================================
// MARK: - Gradient Functions
// =============================================================================

/// Linear gradient along an angle
static half3 linearGradientAngle(float2 uv, float angleDeg, half3 color1, half3 color2) {
    float angle = angleDeg * 3.14159 / 180.0;
    float2 dir = float2(cos(angle), sin(angle));
    float t = dot(uv - 0.5, dir) + 0.5;
    t = clamp(t, 0.0, 1.0);
    return mix(color1, color2, half(t));
}

/// Repeating linear gradient
static float repeatingLinearGradient(float2 uv, float angleDeg, float size, float2 offset) {
    float angle = angleDeg * 3.14159 / 180.0;
    float2 dir = float2(cos(angle), sin(angle));
    float t = dot(uv + offset, dir);
    return fract(t / size);
}

/// Multi-stop rainbow gradient (7 colors)
static half3 rainbowGradient(float t) {
    // 7 rainbow colors
    half3 colors[7] = {
        half3(1.0h, 0.0h, 0.0h),   // Red
        half3(1.0h, 0.5h, 0.0h),   // Orange
        half3(1.0h, 1.0h, 0.0h),   // Yellow
        half3(0.0h, 1.0h, 0.0h),   // Green
        half3(0.0h, 0.5h, 1.0h),   // Blue
        half3(0.3h, 0.0h, 1.0h),   // Indigo
        half3(0.5h, 0.0h, 0.5h)    // Violet
    };

    float scaledT = fract(t) * 6.0;
    int index = int(scaledT);
    float blend = fract(scaledT);

    int nextIndex = (index + 1) % 7;
    return mix(colors[index], colors[nextIndex], half(blend));
}

/// Radial gradient from center
static float radialGradient(float2 uv, float2 center, float radius) {
    float dist = length(uv - center);
    return smoothstep(radius, 0.0, dist);
}

/// Sun pillar colors (used in shiny/metallic effects)
static half3 sunPillarGradient(float t) {
    half3 colors[6] = {
        half3(1.0h, 0.8h, 0.6h),   // Warm gold
        half3(1.0h, 0.9h, 0.7h),   // Light gold
        half3(0.9h, 0.95h, 1.0h),  // Cool white
        half3(0.7h, 0.85h, 1.0h),  // Light blue
        half3(0.8h, 0.7h, 1.0h),   // Lavender
        half3(1.0h, 0.75h, 0.8h)   // Pink
    };

    float scaledT = fract(t) * 5.0;
    int index = int(scaledT);
    float blend = fract(scaledT);

    int nextIndex = (index + 1) % 6;
    return mix(colors[index], colors[nextIndex], half(blend));
}

/// Gold gradient for secret rare
static half3 goldGradient(float t) {
    half3 gold1 = half3(0.83h, 0.69h, 0.22h); // Deep gold
    half3 gold2 = half3(1.0h, 0.84h, 0.0h);   // Bright gold
    half3 gold3 = half3(1.0h, 0.93h, 0.55h);  // Light gold

    float scaledT = fract(t) * 2.0;
    if (scaledT < 1.0) {
        return mix(gold1, gold2, half(scaledT));
    } else {
        return mix(gold2, gold3, half(scaledT - 1.0));
    }
}

// =============================================================================
// MARK: - Utility Functions
// =============================================================================

/// Calculate distance from center (0-1 normalized)
static float distanceFromCenter(float2 uv) {
    float2 center = float2(0.5, 0.5);
    return length(uv - center) / 0.7071; // Normalize to ~1 at corners
}

/// Rotate UV coordinates
static float2 rotateUV(float2 uv, float angleDeg) {
    float angle = angleDeg * 3.14159 / 180.0;
    float2 center = float2(0.5, 0.5);
    float2 centered = uv - center;
    float2 rotated = float2(
        centered.x * cos(angle) - centered.y * sin(angle),
        centered.x * sin(angle) + centered.y * cos(angle)
    );
    return rotated + center;
}

/// Scanlines effect (horizontal lines)
static float scanlines(float2 uv, float density, float thickness) {
    float line = fract(uv.y * density);
    return smoothstep(0.0, thickness, line) * smoothstep(1.0, 1.0 - thickness, line);
}
