Shader "Custom/Geometry"
{
    Properties
    {
        [Header(Base Color)]
        [HDR][MainColor]_BaseColor("_BaseColor", Color) = (1,1,1,1)

        [Header(Line)]
        _LineWidth("_LineWidth", Range(0,1)) = 0.01

        [Toggle(_IsDiagonal)]_IsDiagonal("_IsDiagonal (on/off Diagonal)", Float) = 0

        [Header(Height)]
        _Height("_Height", Range(0, 20)) = 10
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
