// include Unity Engine
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

// positionOSはObjectSpace

struct Attributes
{
    float4 positionOS   : POSITION;
    float2 uv           : TEXCOORD1;
};

struct V2G 
{
    float4 positionOS   : POSITION;
    float3 positionWS    : TEXCOORD0;
    float2 uv           : TEXCOORD1;
};

struct Varyings
{
    float4 positionCS   : SV_POSITION;
    float2 uv          : TEXCOORD1;
};

CBUFFER_START(UnityPerMaterial)
float _LocalTime;
CBUFFER_END

V2G VertexShaderWork(Attributes input) 
{
  V2G output;

  output.positionWS = TransformObjectToWorld(input.positionOS);
  // output.positionOS = TransformWorldToHClip(input.positionOS);
  // VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS); 
  output.positionOS = input.positionOS;
  output.uv = input.uv;
  return output;
}

[maxvertexcount(3)]
void GS(triangle V2G input[3] , inout TriangleStream<Varyings> triStream)
{

  Varyings w1;
  Varyings w2;
  Varyings w3;

  float3 normal = normalize(cross(input[1].positionWS - input[0].positionWS, input[2].positionWS - input[0].positionWS));

  // input[i].positionOS = float4(TransformObjectToWorld(input[i].positionOS), 1.0);
  // VertexPositionInputs vertexInput = GetVertexPositionInputs(input[i].positionOS); 
  w1.positionCS = TransformWorldToHClip(input[0].positionWS + float4(normal * _LocalTime, 0.0));
  w2.positionCS = TransformWorldToHClip(input[1].positionWS + float4(normal * _LocalTime, 0.0));
  w3.positionCS = TransformWorldToHClip(input[2].positionWS + float4(normal * _LocalTime, 0.0));

  w1.uv = input[0].uv;
  w2.uv = input[1].uv;
  w3.uv = input[2].uv;

  triStream.Append(w1);
  triStream.Append(w2);
  triStream.Append(w3);

  triStream.RestartStrip();
}

half4 ShadeFinalColor(Varyings input) : SV_TARGET
{
  half4 baseColor = half4(1, 1, 1, 1);
  return baseColor;
}

