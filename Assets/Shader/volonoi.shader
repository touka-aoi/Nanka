Shader "Custom/volonoi"
{
    Properties
    {
        // ボロノイの細かさ
        _VolonoiSize("Volonoi Size", Range(1, 20)) = 10

        // セルの数値
        _Seed("Seed", Range(0.1, 1.0)) = 0.5
    }
    SubShader
    {
        Tags 
        { 
            "RenderPipeline" = "UniversalRenderPipeline"
            "RenderType"="Opaque" 
            "Queue"="Geometry"
            "UniversalMaterialType" = "Lit"
        }

        Pass 
        {
            Name "UV"
            Tags { "LightMode" = "UniversalForward" }

            // Shader設定 非透明
            Cull Back // 裏面カリング
            ZTest LEqual // Zテストを行う
            ZWrite On // Zバッファに書き込む
            Blend One Zero // 上書き

            HLSLPROGRAM

            // 便利ツールをリンク
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _SHADOWS_SOFT
            #pragma multi_compile_fog
            #pragma vertex VertexShaderWork
            #pragma fragment ShadeFinalColor

            #include "volonoi.hlsl"

            ENDHLSL
        }
    }
}
