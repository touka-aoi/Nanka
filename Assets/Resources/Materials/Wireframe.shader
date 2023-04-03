Shader "Custom/WireFrame"
{
    Properties
    {
        [Header(Base Color)]
        [HDR][MainColor]_BaseColor("_BaseColor", Color) = (1,1,1,1)

        [Header(Line)]
        _LineWidth("_LineWidth", Range(0,1)) = 0.01

         [Toggle(_IsDiagonal)]_IsDiagonal("_IsDiagonal (on/off Diagonal)", Float) = 0
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Opaque" 
            "Queue"="Transparent"
        }

        Pass 
        {
        Name "Wireframe"
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


            #include "Wireframe.hlsl"

            ENDHLSL

        }
    }
}
