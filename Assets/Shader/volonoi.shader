Shader "Custom/volonoi"
{
    Properties
    {
        // ボロノイの細かさ
        _VolonoiSize("Volonoi Size", Range(1, 20)) = 10

        // セルの数値
        _Seed("Seed", Range(0.0, 1.0)) = 0.5


        [Header(Edge)]

        // エッジを表示するか選択します
        [Toggle(_IsEdge)]_IsEdge("isEdge", Range(0.0, 1.0)) = 1.0

        // 透明度を制御します
        _Opacity("Opacity", Range(0.0, 1.0)) = 1.0

    }
    SubShader
    {
        Tags 
        { 
            "RenderPipeline" = "UniversalRenderPipeline"
            "RenderType"="Opaque" 
            "Queue"="Transparent"
            "UniversalMaterialType" = "Lit"
        }

        Pass 
        {
            Name "UV"
            Tags { "LightMode" = "UniversalForward" }

            // Shader設定 非透明
            Cull Off // 裏面カリング
            ZTest LEqual // Zテストを行う
            ZWrite On // Zバッファに書き込む
            Blend SrcAlpha OneMinusSrcAlpha// 上書き

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
