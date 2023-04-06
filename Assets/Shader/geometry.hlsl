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

CBUFFER_END

Attributes VertexShaderWork(Attributes input) 
{
  return input;
}

[maxvertexcount(3)]
void GS(triangle Attributes input[3]: SV_GeometryIn, inout TriangleStream<Varyings> triStream)
{

  // 座標変換
  [unroll]
  for (int i = 0; i < 3; i++)
  {
    Varyings output;
  
    VertexPositionInputs vertexInput = GetVertexPositionInputs(input[i].positionOS); 
    output.positionCS = vertexInput.positionCS;
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

