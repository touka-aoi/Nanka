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

Varyings V2GToVaryings(float3 positionCS, float2 uv) 
{
  Varyings output;

  output.positionCS = TransformWorldToHClip(float4(positionCS, 0.0));
  output.uv = uv;
  return output;
}



[maxvertexcount(15)]
void GS(triangle V2G input[3] , inout TriangleStream<Varyings> triStream)
{

  // 三角形のワールド座標を取得する
  float3 w0 = input[0].positionWS.xyz;
  float3 w1 = input[1].positionWS.xyz;
  float3 w2 = input[2].positionWS.xyz;

  // 三角形の法線を取得する
  float3 normal = normalize(cross(w1 - w0, w2 - w0));

  // 法線を加算する
  float3 w3 = w0 + normal * _LocalTime;
  float3 w4 = w1 + normal * _LocalTime;
  float3 w5 = w2 + normal * _LocalTime;

  // 座標変換を行う
  float4 w3_cs = TransformWorldToHClip(float4(w3, 0.0));
  float4 w4_cs = TransformWorldToHClip(float4(w4, 0.0));
  float4 w5_cs = TransformWorldToHClip(float4(w5, 0.0));

  // 三角形を出力する
  triStream.Append(V2GToVaryings(w3, input[0].uv));
  triStream.Append(V2GToVaryings(w4, input[1].uv));
  triStream.Append(V2GToVaryings(w5, input[2].uv));

  triStream.RestartStrip();

  // 側面を作成する
  triStream.Append(V2GToVaryings(w3, input[0].uv));
  triStream.Append(V2GToVaryings(w0, input[2].uv));
  triStream.Append(V2GToVaryings(w4, input[1].uv));
  triStream.Append(V2GToVaryings(w1, input[1].uv));

  triStream.RestartStrip();

  triStream.Append(V2GToVaryings(w4, input[1].uv));
  triStream.Append(V2GToVaryings(w1, input[1].uv));
  triStream.Append(V2GToVaryings(w5, input[2].uv));
  triStream.Append(V2GToVaryings(w2, input[2].uv));

  triStream.RestartStrip();

  triStream.Append(V2GToVaryings(w5, input[2].uv));
  triStream.Append(V2GToVaryings(w2, input[2].uv));
  triStream.Append(V2GToVaryings(w3, input[0].uv));
  triStream.Append(V2GToVaryings(w0, input[2].uv));

  triStream.RestartStrip();
  
}

half4 ShadeFinalColor(Varyings input) : SV_TARGET
{
  half4 baseColor = half4(1, 1, 1, 1);
  return baseColor;
}

