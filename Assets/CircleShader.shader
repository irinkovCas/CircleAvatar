Shader "CircularShader"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _Radius ("Radius", Float) = 0.5
        _Center ("Center", Vector) = (0.5, 0.5, 0.5, 0.5)
        _Smoothness ("Smoothness", Float) = 0.01
    }

    SubShader
    {
        Tags { 
            "RenderType"="Transparent" 
            "Queue"="Transparent" 
        }

        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off
        ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float2 _MainTex_TexelSize;
            float _Radius;
            float4 _Center;
            float _Smoothness;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float width = _MainTex_TexelSize.x;
                float height = _MainTex_TexelSize.y;

                float aspect = width / height;

                float2 center = float2(_Center.x, _Center.y);
                float2 uvNoStretch = i.uv;
                
                if (aspect < 1) 
                {
                    center.x /= aspect;
                    uvNoStretch.x /= aspect;
                } 
                else 
                {
                    center.y *= aspect;
                    uvNoStretch.y *= aspect;
                }

                fixed4 texColor = tex2D(_MainTex, i.uv);
                fixed dist = distance(uvNoStretch, center);
                texColor.a = smoothstep(_Radius, _Radius - _Smoothness, dist);
                return texColor;
            }
            ENDCG
        }
    }
}
