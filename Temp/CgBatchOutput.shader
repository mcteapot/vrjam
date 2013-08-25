// Upgrade NOTE: replaced 'PositionFog()' with multiply of UNITY_MATRIX_MVP by position
// Upgrade NOTE: replaced 'V2F_POS_FOG' with 'float4 pos : SV_POSITION'

﻿Shader "Custom/XRay" {
    Properties {
        _Color ("Tint (RGB)", Color) = (1,1,1,1)
        _RampTex ("Facing Ratio Ramp (RGB)", 2D) = "white" {}
    }
    SubShader {
        ZWrite Off
        Tags { "Queue" = "Transparent" }
        Blend One One
        Pass {
            
            Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 15 to 15
//   d3d9 - ALU: 15 to 15
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 9 [_WorldSpaceCameraPos]
Matrix 5 [_World2Object]
Vector 10 [unity_Scale]
"!!ARBvp1.0
# 15 ALU
PARAM c[11] = { { 0.5, 0, 1 },
		state.matrix.mvp,
		program.local[5..10] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].z;
MOV R1.xyz, c[9];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
MAD R0.xyz, R0, c[10].w, -vertex.position;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 result.texcoord[0].x, R0, vertex.normal;
MOV result.texcoord[0].yzw, c[0].xxyz;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 15 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Matrix 4 [_World2Object]
Vector 9 [unity_Scale]
"vs_2_0
; 15 ALU
def c10, 1.00000000, 0.50000000, 0.00000000, 0
dcl_position0 v0
dcl_normal0 v1
mov r1.w, c10.x
mov r1.xyz, c8
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
mad r0.xyz, r0, c9.w, -v0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 oT0.x, r0, v1
mov oT0.yzw, c10.xyzx
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

}

#LINE 33
 

            SetTexture [_RampTex] {constantColor[_Color] combine texture * constant} 
        }
    }
    Fallback Off
}