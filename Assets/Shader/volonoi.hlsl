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
  float2 id;

  // 近傍格子点の中で最も近い格子点を探す
  for (float j = -2.0; j <= 2.0; j++) {
    for (float i = -2.0; i <= 2.0; i++) {
      // 隣の格子点
      float2 glid = n + float2(i, j);
      float2 jitter = sin(_Seed) * (hash22(glid) - 0.5);
      // dist = min(dist, length(uv - glid + jitter));
      if (dist >= length(glid + jitter - uv)) {
        dist = length(glid + jitter - uv);
        id = glid;
      }
    }
  }

  // 境界線を描画する
  float md = sqrt(2.0); // 閾値
  float2 a = id + sin(_Seed) * (hash22(id) - 0.5) - uv; // 現在の特徴点を取得

  for (float k = -2.0; k <= 2.0; k++) {
    for (float l = -2.0; l <= 2.0; l++) {
      float2 glid = id  + float2(l, k); // 隣の格子点を検索する
      float2 b = glid + sin(_Seed) * (hash22(glid) - 0.5) - uv; // 特徴点を取得
      if ( dot(a-b, a-b) > 0.0001) {
        // 同じ点だと内積が0になるので除外できる
        md = min(md, dot(0.5 * (a + b), normalize(b - a)));
      }
    }
  }

  id = hash22(id);

  half4 baseColor = lerp( float4(1, 1,1.0, 1.0), float4(0.0, 0.0, 0.0, 0.0), smoothstep( 0.02, 0.07, md ) );
  // half4 baseColor = float4(md, 1, 1, 1);
  return baseColor;
}
