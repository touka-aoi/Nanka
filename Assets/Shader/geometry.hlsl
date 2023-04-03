// include Unity Engine
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

// positionOSはObjectSpace

struct Attributes
{
    float4 positionOS   : POSITION;
    float2 uv           : TEXCOORD0;
};

struct Varyings
{
    float4 positionCS   : SV_POSITION;
    float2 uv          : TEXCOORD0;
};

CBUFFER_START(UnityPerMaterial)

// lineWidth
float _LineWidth;
float _IsDiagonal;
uint _Height;

CBUFFER_END

Varyings VertexShaderWork(Attributes input) 
{
  Varyings output;
  output.positionCS = input.positionOS;
  output.uv = input.uv;
  return output;
}

[maxvertexcount(3)]
void GS(triangle Attributes input[3]: SV_GeometryIn, inout TriangleStream<Varyings> triStream)
{
  float3 edgeA = input[1].positionOS - input[0].positionOS;
  float3 edgeB = input[2].positionOS - input[0].positionOS;
  float3 normal = normalize(cross(edgeA, edgeB));

  [unroll]
  for (int i = 0; i < 3; i++)
  {
    Varyings output;
    // 移動
    input[i].positionOS.xyz += normal * _Height;
    output.positionCS = GetVertexPositionInputs(input[i].positionOS).positionCS;
    output.uv = input[i].uv;
    triStream.Append(output);
  }
  triStream.RestartStrip();
}

half4 ShadeFinalColor(Varyings input) : SV_TARGET
{
  half4 baseColor = half4(1, 1, 1, 1);
  return baseColor;
}

