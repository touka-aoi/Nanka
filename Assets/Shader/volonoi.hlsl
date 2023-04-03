// include Unity Engine
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

// positionOSはObjectSpace

struct Attributes
{
    float4 positionOS   : POSITION;
    float2 uv          : TEXCOORD0;
};

struct Varyings
{
    float4 positionCS   : SV_POSITION;
    float2 uv          : TEXCOORD0;
};

Varyings VertexShaderWork(Attributes input) 
{
  Varyings output;

  VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS);

  // cs
  output.positionCS = vertexInput.positionCS;
  // uv
  output.uv = input.uv;

  return output;
}

float2 hash22(float2 p) 
{
  uint3 k = uint3(0x456789abu, 0x6789ab45u, 0x89ab4567u);
  const uint umax = UINT_MAX;
  uint2 n = asuint(p);
  uint3 u = uint3(1,2,3);
  n ^= (n.yx << u.xy);
  n ^= (n.yx >> u.xy);
  n *= k.xy;
  n ^= (n.yx << u.xy);
  return float2(n * k) / float(umax);
}

CBUFFER_START(UnityPerMaterial)

uint _VolonoiSize;
float _Seed;

CBUFFER_END

half4 ShadeFinalColor(Varyings input) : SV_TARGET
{
  // uv
  float2 uv = input.uv;
  uv *= _VolonoiSize;

  // volonoi
  // 近傍格子点
  float2 n = floor(uv + 0.5);
  float dist = sqrt(2.0);

  // 近傍格子点の中で最も近い格子点を探す
  for (float j = -2.0; j <= 2.0; j++) {
    for (float i = -2.0; i <= 2.0; i++) {
      // 隣の格子点
      float2 glid = n + float2(i, j);
      float2 jitter = sin(_Seed) * (hash22(glid) - 0.5);
      dist = min(dist, length(uv - glid + jitter));
    }
  }

  half4 baseColor = half4(dist, dist, dist, 1);
  return baseColor;
}