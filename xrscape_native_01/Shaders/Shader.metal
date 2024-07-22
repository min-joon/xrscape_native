//
//  File.metal
//  xrscape_native_01
//
//  Created by minjoon on 8/12/24.
//

#include <metal_stdlib>
using namespace metal;

fragment float4 unlit_fragment_shader(texture2d<float> colorTexture [[texture(0)]],
                                      sampler colorSampler [[sampler(0)]],
                                      float2 uv [[position_in]]) {
    return colorTexture.sample(colorSampler, uv);
}
