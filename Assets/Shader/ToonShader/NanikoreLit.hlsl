// include Unity Engine
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

// データ定義

struct Attributes
{
  float3 positionMS   : POSITION;
  half3 normalMS      : NORMAL;
  half4 tangentMS     : TANGENT;
  float2 uv           : TEXCOORD0;
};

struct Varyings
{
    float2 uv                       : TEXCOORD0;
    float4 positionWSAndFogFactor   : TEXCOORD1; // xyz: positionWS, w: vertex fog factor
    half3 normalWS                  : TEXCOORD2;
    float4 positionCS               : SV_POSITION;
};

// サンプラー
sampler2D _BaseMap; 

// CBUFFER
CBUFFER_START(UnityPerMaterial)

// ベースカラー
float4 _BaseMap_ST;
half4 _BaseColor;

// アルファ
half _Cutoff;

// アウトライン
float _OutlineWidth;
half3 _OutlineColor;
float _OutlineZOffset;

CBUFFER_END

float3 _LightDirection;

// モデルサーフェース
struct ToonSurfaceData
{
  half3 albedo;
  half alpha;
  half3 emission;
  half occlusion;
};

// 光
struct ToonLightingData
{
  half3 normalWS;
  float3 positionWS;
  half3 viewDirectionWS;
  float4 shadowCoord;
}

// バーテックスシェーダー
Varyings VertexShaderWork(Attributes input)
{

}

ToonLightingData InitializeLightingData(Varyings input)
{
  ToonLightingData lightingData;
  lightingData.positionWS = input.positionWSAndFogFactor.xyz;
  lightingData.viewDirectionWS = SafeNormalize(GetCameraPositionWS() - lightingData.positionWS);
  lightingData.normalWS = normalize(input.normalWS);

  return lightingData;
}

// すべてのライトを計算する
half3 ShadeAllLights(ToonSurfaceData surfaceData, ToonLightingData lightingData)
{
  // 間接光
  half3 indirectResult = ShadeGI(surfaceData, lightingData);

  // 一番強い光を取得
  Light mainLight = GetMainLight();


}

// フラグメントシェーダー
half4 ShadeFinalColor(Varyings input): SV_TARGET
{
  // サーフェースデータ
  ToonSurfaceData surfaceData = InitializeSurfaceData(input);

  // ライトデータ
  ToonLightingData lightingData = InitializeLightingData(input);

  // シェーディング
  half3 color = ShadeAllLights(surfaceData, lightingData);

  // アウトライン
#ifdef ToonShaderIsOutline
  color = ConvertSurfaceColorToOutlineColor(color);
#endif

  // フォグ加算
  color = ApplyFog(color, input);

  return half4(color, surfaceData.alpha);
}