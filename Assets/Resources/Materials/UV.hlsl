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

half4 ShadeFinalColor(Varyings input) : SV_TARGET
{
  half4 baseColor = half4(input.uv, 1, 1);
  return baseColor;
}