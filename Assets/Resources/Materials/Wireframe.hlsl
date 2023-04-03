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

CBUFFER_START(UnityPerMaterial)

// lineWidth
float _LineWidth;
float _IsDiagonal;

CBUFFER_END



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
  
  // 対角線を削除する

  float3 param = float3(0, 0, 0);

  if(_IsDiagonal)
  {
    float edgeA = length(input[0].positionOS.xyz - input[1].positionOS.xyz);
    float edgeB = length(input[1].positionOS.xyz - input[2].positionOS.xyz);
    float edgeC = length(input[2].positionOS.xyz - input[0].positionOS.xyz);
    
    // if edgeA is the longest edge
    if (edgeA > edgeB && edgeA > edgeC)
    {
      param = float3(0, 0, 1);
    } else if (edgeB > edgeA && edgeB > edgeC)
    {
      param = float3(1, 0, 0);
    } else if (edgeC > edgeA && edgeC > edgeB)
    {
      param = float3(0, 1, 0);
    }
  }

  [unroll]
  for (int i = 0; i < 3; i++) 
  {
    output[i].positionCS = input[i].positionOS;
    output[i].uv = input[i].uv;
    output[i].baryCentriCorrds = float3(i == 0, i == 1, i == 2) + param;
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
  float edge = min(min(input.baryCentriCorrds.x, input.baryCentriCorrds.y), input.baryCentriCorrds.z);
  edge = step(edge, _LineWidth);
  half4 baseColor = half4(edge, edge, edge,  edge);
  // half4 baseColor = half4(input.baryCentriCorrds, 1);
  return baseColor;
}

