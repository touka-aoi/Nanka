Shader "Custom/Nanikore"
{
    Properties
    {
        // ベースカラー
        [Header(Base Color)]
        [MainTexture]_BaseMap("_BaseMap (Albedo)", 2D) = "white" {}
        [HDR][MainColor]_BaseColor("_BaseColor", Color) = (1,1,1,1)

        // アルファ
        [Header(Alpha)]
        [Toggle(_UseAlphaClipping)]_UseAlphaClipping("_UseAlphaClipping", Float) = 0
        _Cutoff("_Cutoff (Alpha Cutoff)", Range(0.0, 1.0)) = 0.5

        // アウトライン
         [Header(Outline)]
        _OutlineWidth("_OutlineWidth (World Space)", Range(0,4)) = 1
        _OutlineColor("_OutlineColor", Color) = (0.5,0.5,0.5,1)
        _OutlineZOffset("_OutlineZOffset (View Space)", Range(0,1)) = 0.0001
       

    }

    SubShader
    {
        Tags 
        { 
            "RenderPipeline"="UniversalPipeline" // URPのみ

            "RenderType"="Opaque" 
            "UniversalMaterialType"="Lit"
            "Queue"="Geometry"
        }

        HLSLINCLUDE
// 汎用HLSLコード
        #pragma shader_feature_local_fragment _UseAlphaClipping
        ENDHLSL

        // Main
        Pass
        {
            Name "ForwardLit"
            Tags 
            {
                "LightMode" = "UniversalForward"
            }

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

            #include "NanikoreLit.hlsl"

            ENDHLSL
        }
    }
}

