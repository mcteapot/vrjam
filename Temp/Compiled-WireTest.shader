// Upgrade NOTE: replaced 'glstate.matrix.mvp' with 'UNITY_MATRIX_MVP'

﻿Shader "Custom/WireTest" {
	Properties {
		_LineColor ("Line Color", Color) = (1,1,1,1)
		_GridColor ("Grid Color", Color) = (0,0,0,0)
		_LineWidth ("Line Width", float) = 0.1
	}
	SubShader {
        Pass {

Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 6 to 6
//   d3d9 - ALU: 6 to 6
//   d3d11 - ALU: 1 to 1, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 1 to 1, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
"!!ARBvp1.0
# 6 ALU
PARAM c[5] = { program.local[0],
		state.matrix.mvp };
MOV result.texcoord[1], vertex.texcoord[1];
MOV result.color, vertex.color;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 6 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
"vs_2_0
; 6 ALU
dcl_position0 v0
dcl_texcoord1 v1
dcl_color0 v2
mov oT1, v1
mov oD0, v2
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 7 instructions, 1 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedhlfkjncjkaikhllalombhknoleinmkfnabaaaaaaeiacaaaaadaaaaaa
cmaaaaaajmaaaaaabaabaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaafjaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaagcaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaafaepfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaaepfdeheo
gmaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaagfaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaafdfgfpfagphdgjhegjgpgoaa
feeffiedepepfceeaaedepemepfcaaklfdeieefcdaabaaaaeaaaabaaemaaaaaa
fjaaaaaeegiocaaaaaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
pcbabaaaabaaaaaafpaaaaadpcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagiaaaaac
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaaf
pccabaaaabaaaaaaegbobaaaabaaaaaadgaaaaafpccabaaaacaaaaaaegbobaaa
acaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_COLOR;
varying highp vec4 xlv_TEXCOORD1;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD1 = _glesMultiTexCoord1;
  xlv_COLOR = _glesColor;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
uniform highp float _LineWidth;
uniform highp vec4 _GridColor;
uniform highp vec4 _LineColor;
void main ()
{
  highp vec4 tmpvar_1;
  if (((xlv_TEXCOORD1.x < _LineWidth) || (xlv_TEXCOORD1.y < _LineWidth))) {
    tmpvar_1 = _LineColor;
  } else {
    if ((((xlv_TEXCOORD1.x - xlv_TEXCOORD1.y) < _LineWidth) && ((xlv_TEXCOORD1.y - xlv_TEXCOORD1.x) < _LineWidth))) {
      tmpvar_1 = _LineColor;
    } else {
      tmpvar_1 = _GridColor;
    };
  };
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_COLOR;
varying highp vec4 xlv_TEXCOORD1;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD1 = _glesMultiTexCoord1;
  xlv_COLOR = _glesColor;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
uniform highp float _LineWidth;
uniform highp vec4 _GridColor;
uniform highp vec4 _LineColor;
void main ()
{
  highp vec4 tmpvar_1;
  if (((xlv_TEXCOORD1.x < _LineWidth) || (xlv_TEXCOORD1.y < _LineWidth))) {
    tmpvar_1 = _LineColor;
  } else {
    if ((((xlv_TEXCOORD1.x - xlv_TEXCOORD1.y) < _LineWidth) && ((xlv_TEXCOORD1.y - xlv_TEXCOORD1.x) < _LineWidth))) {
      tmpvar_1 = _LineColor;
    } else {
      tmpvar_1 = _GridColor;
    };
  };
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "flash " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
"agal_vs
[bc]
aaaaaaaaabaaapaeaeaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v1, a4
aaaaaaaaahaaapaeacaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v7, a2
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
"
}

SubProgram "d3d11_9x " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 7 instructions, 1 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedeohmmjojcbomlacpecompdhidejaekebabaaaaaadiadaaaaaeaaaaaa
daaaaaaabmabaaaafeacaaaameacaaaaebgpgodjoeaaaaaaoeaaaaaaaaacpopp
laaaaaaadeaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaabaadaaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaaaaaaaacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaac
afaaabiaabaaapjabpaaaaacafaaaciaacaaapjaafaaaaadaaaaapiaaaaaffja
acaaoekaaeaaaaaeaaaaapiaabaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapia
adaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaeaaoekaaaaappjaaaaaoeia
aeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeia
abaaaaacaaaaapoaabaaoejaabaaaaacabaaapoaacaaoejappppaaaafdeieefc
daabaaaaeaaaabaaemaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadpcbabaaaacaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
pccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaabaaaaaaegbobaaaabaaaaaadgaaaaaf
pccabaaaacaaaaaaegbobaaaacaaaaaadoaaaaabejfdeheogiaaaaaaadaaaaaa
aiaaaaaafaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaafjaaaaaa
abaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaagcaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapapaaaafaepfdejfeejepeoaafeeffiedepepfceeaaedep
emepfcaaepfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apaaaaaagfaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaafdfgfpfa
gphdgjhegjgpgoaafeeffiedepepfceeaaedepemepfcaakl"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;

#line 150
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 186
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 180
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 316
struct v2f {
    highp vec4 pos;
    highp vec4 texcoord1;
    highp vec4 color;
};
#line 309
struct appdata {
    highp vec4 vertex;
    highp vec4 texcoord1;
    highp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_LightPosition[4];
uniform highp vec4 unity_LightAtten[4];
#line 19
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHBr;
#line 23
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
#line 27
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
uniform highp vec4 _LightSplitsNear;
#line 31
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
#line 35
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 _Object2World;
#line 39
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
uniform highp mat4 glstate_matrix_texture0;
#line 43
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
uniform highp mat4 glstate_matrix_projection;
#line 47
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 unity_ColorSpaceGrey;
#line 76
#line 81
#line 86
#line 90
#line 95
#line 119
#line 136
#line 157
#line 165
#line 192
#line 205
#line 214
#line 219
#line 228
#line 233
#line 242
#line 259
#line 264
#line 290
#line 298
#line 302
#line 306
uniform highp vec4 _LineColor;
uniform highp vec4 _GridColor;
uniform highp float _LineWidth;
#line 323
#line 331
#line 323
v2f vert( in appdata v ) {
    v2f o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 327
    o.texcoord1 = v.texcoord1;
    o.color = v.color;
    return o;
}
out highp vec4 xlv_TEXCOORD1;
out highp vec4 xlv_COLOR;
void main() {
    v2f xl_retval;
    appdata xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD1 = vec4(xl_retval.texcoord1);
    xlv_COLOR = vec4(xl_retval.color);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 150
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 186
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 180
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 316
struct v2f {
    highp vec4 pos;
    highp vec4 texcoord1;
    highp vec4 color;
};
#line 309
struct appdata {
    highp vec4 vertex;
    highp vec4 texcoord1;
    highp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_LightPosition[4];
uniform highp vec4 unity_LightAtten[4];
#line 19
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHBr;
#line 23
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
#line 27
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
uniform highp vec4 _LightSplitsNear;
#line 31
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
#line 35
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 _Object2World;
#line 39
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
uniform highp mat4 glstate_matrix_texture0;
#line 43
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
uniform highp mat4 glstate_matrix_projection;
#line 47
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 unity_ColorSpaceGrey;
#line 76
#line 81
#line 86
#line 90
#line 95
#line 119
#line 136
#line 157
#line 165
#line 192
#line 205
#line 214
#line 219
#line 228
#line 233
#line 242
#line 259
#line 264
#line 290
#line 298
#line 302
#line 306
uniform highp vec4 _LineColor;
uniform highp vec4 _GridColor;
uniform highp float _LineWidth;
#line 323
#line 331
#line 331
highp vec4 frag( in v2f i ) {
    if (((i.texcoord1.x < _LineWidth) || (i.texcoord1.y < _LineWidth))){
        #line 335
        return _LineColor;
    }
    if ((((i.texcoord1.x - i.texcoord1.y) < _LineWidth) && ((i.texcoord1.y - i.texcoord1.x) < _LineWidth))){
        #line 339
        return _LineColor;
    }
    else{
        #line 343
        return _GridColor;
    }
}
in highp vec4 xlv_TEXCOORD1;
in highp vec4 xlv_COLOR;
void main() {
    highp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.texcoord1 = vec4(xlv_TEXCOORD1);
    xlt_i.color = vec4(xlv_COLOR);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 16 to 16, TEX: 0 to 0
//   d3d9 - ALU: 21 to 21
//   d3d11 - ALU: 5 to 5, TEX: 0 to 0, FLOW: 6 to 6
//   d3d11_9x - ALU: 5 to 5, TEX: 0 to 0, FLOW: 6 to 6
SubProgram "opengl " {
Keywords { }
Vector 0 [_LineColor]
Vector 1 [_GridColor]
Float 2 [_LineWidth]
"!!ARBfp1.0
# 16 ALU, 0 TEX
PARAM c[4] = { program.local[0..2],
		{ 1, 0 } };
TEMP R0;
TEMP R1;
ADD R1.z, fragment.texcoord[1].y, -fragment.texcoord[1].x;
SLT R1.y, fragment.texcoord[1], c[2].x;
SLT R1.x, fragment.texcoord[1], c[2];
ADD_SAT R1.x, R1, R1.y;
CMP R0, -R1.x, c[0], R0;
ADD R1.y, fragment.texcoord[1].x, -fragment.texcoord[1];
SLT R1.z, R1, c[2].x;
SLT R1.y, R1, c[2].x;
MUL R1.y, R1, R1.z;
CMP R1.x, -R1, c[3].y, c[3];
MUL R1.w, R1.x, R1.y;
ABS R1.z, R1.y;
CMP R1.y, -R1.z, c[3], c[3].x;
CMP R0, -R1.w, c[0], R0;
MUL R1.x, R1, R1.y;
CMP result.color, -R1.x, c[1], R0;
END
# 16 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_LineColor]
Vector 1 [_GridColor]
Float 2 [_LineWidth]
"ps_2_0
; 21 ALU
def c3, 0.00000000, 1.00000000, 0, 0
dcl t1.xy
add r0.x, t1.y, -c2
add r2.x, t1, -c2
add r3.x, t1, -t1.y
add r3.x, r3, -c2
cmp r2.x, r2, c3, c3.y
cmp r0.x, r0, c3, c3.y
add_pp_sat r0.x, r2, r0
cmp r1, -r0.x, r1, c0
add r2.x, t1.y, -t1
add r2.x, r2, -c2
cmp r2.x, r2, c3, c3.y
cmp r3.x, r3, c3, c3.y
mul_pp r3.x, r3, r2
abs_pp r2.x, r3
cmp_pp r0.x, -r0, c3.y, c3
mul_pp r3.x, r0, r3
cmp_pp r2.x, -r2, c3.y, c3
cmp r1, -r3.x, r1, c0
mul_pp r0.x, r0, r2
cmp r0, -r0.x, r1, c1
mov oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { }
ConstBuffer "$Globals" 64 // 52 used size, 4 vars
Vector 16 [_LineColor] 4
Vector 32 [_GridColor] 4
Float 48 [_LineWidth]
BindCB "$Globals" 0
// 17 instructions, 1 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 2 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 4 static, 2 dynamic
"ps_4_0
eefiecedajegnehdlbpmmnaeoogpeopkkmjmbengabaaaaaaciacaaaaadaaaaaa
cmaaaaaakaaaaaaaneaaaaaaejfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapadaaaagfaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaaaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaedepemepfcaakl
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcemabaaaaeaaaaaaa
fdaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaagcbaaaaddcbabaaaabaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacabaaaaaadbaaaaaidcaabaaaaaaaaaaa
egbabaaaabaaaaaaagiacaaaaaaaaaaaadaaaaaadmaaaaahbcaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaaaaaaaaabpaaaeadakaabaaaaaaaaaaadgaaaaag
pccabaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadoaaaaabbfaaaaabaaaaaaai
dcaabaaaaaaaaaaabgbfbaiaebaaaaaaabaaaaaaegbabaaaabaaaaaadbaaaaai
dcaabaaaaaaaaaaaegaabaaaaaaaaaaaagiacaaaaaaaaaaaadaaaaaaabaaaaah
bcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaabpaaaeadakaabaaa
aaaaaaaadgaaaaagpccabaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadoaaaaab
bcaaaaabdgaaaaagpccabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaadoaaaaab
bfaaaaabdoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

SubProgram "flash " {
Keywords { }
Vector 0 [_LineColor]
Vector 1 [_GridColor]
Float 2 [_LineWidth]
"agal_ps
c3 0.0 1.0 0.0 0.0
c4 -1.0 1.0 1.0 0.0
[bc]
acaaaaaaaaaaabacabaaaaffaeaaaaaaacaaaaoeabaaaaaa sub r0.x, v1.y, c2
acaaaaaaacaaabacabaaaaoeaeaaaaaaacaaaaoeabaaaaaa sub r2.x, v1, c2
acaaaaaaadaaabacabaaaaoeaeaaaaaaabaaaaffaeaaaaaa sub r3.x, v1, v1.y
acaaaaaaadaaabacadaaaaaaacaaaaaaacaaaaoeabaaaaaa sub r3.x, r3.x, c2
ckaaaaaaacaaabacacaaaaaaacaaaaaaadaaaaaaabaaaaaa slt r2.x, r2.x, c3.x
ckaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaaaabaaaaaa slt r0.x, r0.x, c3.x
abaaaaaaaaaaabacacaaaaaaacaaaaaaaaaaaaaaacaaaaaa add r0.x, r2.x, r0.x
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
bfaaaaaaaeaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r4.x, r0.x
ckaaaaaaaeaaapacaeaaaaaaacaaaaaaadaaaaaaabaaaaaa slt r4, r4.x, c3.x
acaaaaaaafaaapacaaaaaaoeabaaaaaaabaaaaoeacaaaaaa sub r5, c0, r1
adaaaaaaafaaapacafaaaaoeacaaaaaaaeaaaaoeacaaaaaa mul r5, r5, r4
abaaaaaaabaaapacafaaaaoeacaaaaaaabaaaaoeacaaaaaa add r1, r5, r1
acaaaaaaacaaabacabaaaaffaeaaaaaaabaaaaoeaeaaaaaa sub r2.x, v1.y, v1
acaaaaaaacaaabacacaaaaaaacaaaaaaacaaaaoeabaaaaaa sub r2.x, r2.x, c2
ckaaaaaaacaaabacacaaaaaaacaaaaaaadaaaaaaabaaaaaa slt r2.x, r2.x, c3.x
ckaaaaaaadaaabacadaaaaaaacaaaaaaadaaaaaaabaaaaaa slt r3.x, r3.x, c3.x
adaaaaaaadaaabacadaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r3.x, r3.x, r2.x
beaaaaaaacaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa abs r2.x, r3.x
bfaaaaaaaeaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r4.x, r0.x
cjaaaaaaaeaaabacaeaaaaaaacaaaaaaadaaaaaaabaaaaaa sge r4.x, r4.x, c3.x
adaaaaaaaaaaabacaeaaaaaaabaaaaaaaeaaaaaaacaaaaaa mul r0.x, c4.x, r4.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaffabaaaaaa add r0.x, r0.x, c3.y
adaaaaaaadaaabacaaaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r3.x, r0.x, r3.x
bfaaaaaaafaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r5.x, r2.x
cjaaaaaaafaaabacafaaaaaaacaaaaaaaeaaaappabaaaaaa sge r5.x, r5.x, c4.w
adaaaaaaacaaabacaeaaaaaaabaaaaaaafaaaaaaacaaaaaa mul r2.x, c4.x, r5.x
abaaaaaaacaaabacacaaaaaaacaaaaaaadaaaaffabaaaaaa add r2.x, r2.x, c3.y
bfaaaaaaaeaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r4.x, r3.x
ckaaaaaaaeaaapacaeaaaaaaacaaaaaaaeaaaappabaaaaaa slt r4, r4.x, c4.w
acaaaaaaafaaapacaaaaaaoeabaaaaaaabaaaaoeacaaaaaa sub r5, c0, r1
adaaaaaaafaaapacafaaaaoeacaaaaaaaeaaaaoeacaaaaaa mul r5, r5, r4
abaaaaaaabaaapacafaaaaoeacaaaaaaabaaaaoeacaaaaaa add r1, r5, r1
adaaaaaaaaaaabacaaaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r0.x, r0.x, r2.x
bfaaaaaaaeaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r4.x, r0.x
ckaaaaaaaeaaapacaeaaaaaaacaaaaaaaeaaaappabaaaaaa slt r4, r4.x, c4.w
acaaaaaaafaaapacabaaaaoeabaaaaaaabaaaaoeacaaaaaa sub r5, c1, r1
adaaaaaaaaaaapacafaaaaoeacaaaaaaaeaaaaoeacaaaaaa mul r0, r5, r4
abaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa add r0, r0, r1
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { }
ConstBuffer "$Globals" 64 // 52 used size, 4 vars
Vector 16 [_LineColor] 4
Vector 32 [_GridColor] 4
Float 48 [_LineWidth]
BindCB "$Globals" 0
// 17 instructions, 1 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 2 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 4 static, 2 dynamic
"ps_4_0_level_9_1
eefiecedeolgaapcglcfgddjlfkbondphopeglpcabaaaaaahmadaaaaaeaaaaaa
daaaaaaaiaabaaaaneacaaaaeiadaaaaebgpgodjeiabaaaaeiabaaaaaaacpppp
biabaaaadaaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaaaaadaaaaaaaabaa
adaaaaaaaaaaaaaaaaacppppfbaaaaafadaaapkaaaaaaaaaaaaaiadpaaaaaaia
aaaaialpbpaaaaacaaaaaaiaaaaaaplaacaaaaadaaaaaiiaaaaaaalbaaaaffla
acaaaaadaaaaabiaaaaappiaacaaaakbfiaaaaaeaaaaabiaaaaaaaiaadaakkka
adaappkaacaaaaadaaaaaciaaaaafflbaaaaaalaacaaaaadaaaaaciaaaaaffia
acaaaakbfiaaaaaeaaaaabiaaaaaffiaadaaaakaaaaaaaiaabaaaaacabaaapia
aaaaoekafiaaaaaeaaaaapiaaaaaaaiaabaaoekaabaaoeiaacaaaaadabaaabia
aaaaaalaacaaaakbacaaaaadabaaaciaaaaafflaacaaaakbfiaaaaaeabaaadia
abaaoeiaadaaaakaadaaffkaacaaaaadabaaabiaabaaffiaabaaaaiafiaaaaae
aaaaapiaabaaaaibaaaaoeiaaaaaoekaabaaaaacaaaiapiaaaaaoeiappppaaaa
fdeieefcemabaaaaeaaaaaaafdaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaa
gcbaaaaddcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacabaaaaaa
dbaaaaaidcaabaaaaaaaaaaaegbabaaaabaaaaaaagiacaaaaaaaaaaaadaaaaaa
dmaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaabpaaaead
akaabaaaaaaaaaaadgaaaaagpccabaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaa
doaaaaabbfaaaaabaaaaaaaidcaabaaaaaaaaaaabgbfbaiaebaaaaaaabaaaaaa
egbabaaaabaaaaaadbaaaaaidcaabaaaaaaaaaaaegaabaaaaaaaaaaaagiacaaa
aaaaaaaaadaaaaaaabaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaa
aaaaaaaabpaaaeadakaabaaaaaaaaaaadgaaaaagpccabaaaaaaaaaaaegiocaaa
aaaaaaaaabaaaaaadoaaaaabbcaaaaabdgaaaaagpccabaaaaaaaaaaaegiocaaa
aaaaaaaaacaaaaaadoaaaaabbfaaaaabdoaaaaabejfdeheogmaaaaaaadaaaaaa
aiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaa
abaaaaaaaaaaaaaaadaaaaaaabaaaaaaapadaaaagfaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfcee
aaedepemepfcaaklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3"
}

}

#LINE 62


        }
	} 
	Fallback "Vertex Colored", 1
}