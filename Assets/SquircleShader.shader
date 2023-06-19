Shader "UI/SquircleShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Smoothness ("Smoothness", Range(0, 1)) = 0.1
        _Roundness ("Roundness", Range(0, 1000)) = 0.1
    }

    SubShader
    {
        Tags { 
            "RenderType"="Transparent" 
            "Queue"="Transparent" 
        }
        LOD 100

        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off
        ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _TextureSampleAdd;
            float _Smoothness;
            float _Roundness;

            struct appdata_t
            {
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float2 texcoord : TEXCOORD0;
            };

            v2f vert(appdata_t v)
            {
                v2f o;
                o.texcoord = v.texcoord;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float2 center = float2(0.5, 0.5);
                float2 offset = i.texcoord - center;
                
                float r = pow(0.5, _Roundness);
                
                // distance to squircle
                float distance = pow(abs(offset.x), _Roundness) + pow(abs(offset.y), _Roundness);

                float4 color = tex2D(_MainTex, i.texcoord) + _TextureSampleAdd;
                color.a = smoothstep(r, r - _Smoothness, distance);

                return color;
            }
            ENDCG
        }
    }
}
