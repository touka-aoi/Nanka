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
    float3 baryCentriCorrds : TEXCOORD1;
};

Attributes AttributesCreate(float4 positionOS, float2 uv)
{
  Attributes output;
  output.positionOS = positionOS;
  output.uv = uv;
  return output;
}

float3 ConstructNormal(float3 v1, float3 v2, float3 v3)
{
    return normalize(cross(v2 - v1, v3 - v1));
}

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

[maxvertexcount(3)]
void GS(triangle Attributes input[3]: SV_GeometryIn, inout TriangleStream<Varyings> triStream)
{
  Varyings output[3];

  [unroll]
  for (int i = 0; i < 3; i++) 
  {
    output[i].positionCS = input[i].positionOS;
    output[i].uv = input[i].uv;
    output[i].baryCentriCorrds = float3(i == 0, i == 1, i == 2);
    triStream.Append(output[i]);
  }

  triStream.RestartStrip();


  // float4 wp0 = input[0].positionOS;
  // float4 wp1 = input[1].positionOS;
  // float4 wp2 = input[2].positionOS;

  // float3 normal = ConstructNormal(wp0.xyz, wp1.xyz, wp2.xyz);

  // float4 wp3 = wp0 + float4(normal * 2, 0.0);
  // float4 wp4 = wp1 + float4(normal * 2, 0.0);
  // float4 wp5 = wp2 + float4(normal * 2, 0.0);

  // // Cap
  // triStream.Append(AttributesCreate(wp3, input[0].uv));
  // triStream.Append(AttributesCreate(wp4, input[1].uv));
  // triStream.Append(AttributesCreate(wp5, input[2].uv));
  // triStream.RestartStrip();

  // // Side
  // triStream.Append(VertexShaderWork(AttributesCreate(wp3, input[0].uv)));
  // triStream.Append(VertexShaderWork(AttributesCreate(wp0, input[0].uv)));
  // triStream.Append(VertexShaderWork(AttributesCreate(wp4, input[1].uv)));
  // triStream.Append(VertexShaderWork(AttributesCreate(wp1, input[1].uv)));
  // triStream.RestartStrip();

  // triStream.Append(VertexShaderWork(AttributesCreate(wp4, input[1].uv)));
  // triStream.Append(VertexShaderWork(AttributesCreate(wp1, input[1].uv)));
  // triStream.Append(VertexShaderWork(AttributesCreate(wp5, input[2].uv)));
  // triStream.Append(VertexShaderWork(AttributesCreate(wp2, input[2].uv)));
  // triStream.RestartStrip();

  // triStream.Append(VertexShaderWork(AttributesCreate(wp5, input[2].uv)));
  // triStream.Append(VertexShaderWork(AttributesCreate(wp2, input[2].uv)));
  // triStream.Append(VertexShaderWork(AttributesCreate(wp3, input[0].uv)));
  // triStream.Append(VertexShaderWork(AttributesCreate(wp0, input[0].uv)));
  // triStream.RestartStrip();

}

half4 ShadeFinalColor(Varyings input) : SV_TARGET
{
  float3 fd = fwidth(input.baryCentriCorrds);

  half4 baseColor = half4(saturate(input.baryCentriCorrds / fd), 1);
  // half4 baseColor = half4(input.baryCentriCorrds, 1);
  return baseColor;
}

