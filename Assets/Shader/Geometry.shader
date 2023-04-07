Shader "Custom/Geometry"
{
    Properties
    {
        _LocalTime("Animation Time", Range(0.0, 10.0)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Tags 
        { 
            "RenderPipeline" = "UniversalRenderPipeline"
            "RenderType"="Opaque" 
            "Queue"="Transparent"
            "UniversalMaterialType" = "Lit"
        }

        Pass
        {
            Name "Geometry"
            Tags { "LightMode" = "UniversalForward" }

            // Shader設定 非透明
            Cull Off // 裏面カリング
            ZTest LEqual // Zテストを行う
            ZWrite On // Zバッファに書き込む
            Blend SrcAlpha OneMinusSrcAlpha// αオン

            HLSLPROGRAM

            // 便利ツールをリンク
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _SHADOWS_SOFT
            #pragma multi_compile_fog
            #pragma vertex VertexShaderWork
            #pragma geometry GS
            #pragma fragment ShadeFinalColor

            #include "geometry.hlsl"

            ENDHLSL
        }
    }
}
