Shader "Custom/WireFrameSquiare"
{
 Properties
 {
   _LineColor ("Line Color", Color) = (1,1,1,1)
   _GridColor ("Grid Color", Color) = (1,1,1,0)
   _LineWidth ("Line Width", float) = 0.2
 }
 SubShader
 {
   Pass
   {
     Tags { "RenderType" = "Transparent" }
     Blend SrcAlpha OneMinusSrcAlpha
     AlphaTest Greater 0.5
 
     Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 6 to 6
//   d3d9 - ALU: 6 to 6
//   d3d11 - ALU: 1 to 1, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 1 to 1, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "color" Color
"!!ARBvp1.0
# 6 ALU
PARAM c[5] = { program.local[0],
		state.matrix.mvp };
MOV result.texcoord[0], vertex.texcoord[0];
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
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
"vs_2_0
; 6 ALU
dcl_position0 v0
dcl_texcoord0 v1
dcl_color0 v2
mov oT0, v1
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
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 7 instructions, 1 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecediaiblejcajiaeokddlhggdbacmggddaoabaaaaaaeiacaaaaadaaaaaa
cmaaaaaajmaaaaaabaabaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaafjaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaagcaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaafaepfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaaepfdeheo
gmaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaagfaaaaaa
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
varying highp vec4 xlv_TEXCOORD0;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0;
  xlv_COLOR = _glesColor;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD0;
uniform highp float _LineWidth;
uniform highp vec4 _GridColor;
uniform highp vec4 _LineColor;
void main ()
{
  lowp vec4 answer_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = mix (_LineColor, _GridColor, vec4((((float((xlv_TEXCOORD0.x >= _LineWidth)) * float((xlv_TEXCOORD0.y >= _LineWidth))) * float(((1.0 - _LineWidth) >= xlv_TEXCOORD0.x))) * float(((1.0 - _LineWidth) >= xlv_TEXCOORD0.y)))));
  answer_1 = tmpvar_2;
  gl_FragData[0] = answer_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_COLOR;
varying highp vec4 xlv_TEXCOORD0;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0;
  xlv_COLOR = _glesColor;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD0;
uniform highp float _LineWidth;
uniform highp vec4 _GridColor;
uniform highp vec4 _LineColor;
void main ()
{
  lowp vec4 answer_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = mix (_LineColor, _GridColor, vec4((((float((xlv_TEXCOORD0.x >= _LineWidth)) * float((xlv_TEXCOORD0.y >= _LineWidth))) * float(((1.0 - _LineWidth) >= xlv_TEXCOORD0.x))) * float(((1.0 - _LineWidth) >= xlv_TEXCOORD0.y)))));
  answer_1 = tmpvar_2;
  gl_FragData[0] = answer_1;
}



#endif"
}

SubProgram "flash " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
"agal_vs
[bc]
aaaaaaaaaaaaapaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v0, a3
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
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 7 instructions, 1 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedemkflblcbfldkmkebfmpoombagbekjidabaaaaaadiadaaaaaeaaaaaa
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
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaagcaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapapaaaafaepfdejfeejepeoaafeeffiedepepfceeaaedep
emepfcaaepfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
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
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;

#line 60
struct v2f {
    highp vec4 pos;
    highp vec4 texcoord1;
    highp vec4 color;
};
#line 53
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
uniform highp vec4 _LineColor;
#line 51
uniform highp vec4 _GridColor;
uniform highp float _LineWidth;
#line 67
#line 75
#line 67
v2f vert( in appdata v ) {
    v2f o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 71
    o.texcoord1 = v.texcoord1;
    o.color = v.color;
    return o;
}
out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_COLOR;
void main() {
    v2f xl_retval;
    appdata xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord0);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.texcoord1);
    xlv_COLOR = vec4(xl_retval.color);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 60
struct v2f {
    highp vec4 pos;
    highp vec4 texcoord1;
    highp vec4 color;
};
#line 53
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
uniform highp vec4 _LineColor;
#line 51
uniform highp vec4 _GridColor;
uniform highp float _LineWidth;
#line 67
#line 75
#line 75
lowp vec4 frag( in v2f i ) {
    lowp vec4 answer;
    highp float lx = step( _LineWidth, i.texcoord1.x);
    #line 79
    highp float ly = step( _LineWidth, i.texcoord1.y);
    highp float hx = step( i.texcoord1.x, (1.0 - _LineWidth));
    highp float hy = step( i.texcoord1.y, (1.0 - _LineWidth));
    answer = mix( _LineColor, _GridColor, vec4( (((lx * ly) * hx) * hy)));
    #line 83
    return answer;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_COLOR;
void main() {
    lowp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.texcoord1 = vec4(xlv_TEXCOORD0);
    xlt_i.color = vec4(xlv_COLOR);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 12 to 12, TEX: 0 to 0
//   d3d9 - ALU: 17 to 17
//   d3d11 - ALU: 9 to 9, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 9 to 9, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Vector 0 [_LineColor]
Vector 1 [_GridColor]
Float 2 [_LineWidth]
"!!ARBfp1.0
# 12 ALU, 0 TEX
PARAM c[4] = { program.local[0..2],
		{ 1 } };
TEMP R0;
TEMP R1;
MOV R0, c[0];
MOV R1.x, c[3];
ADD R1.x, R1, -c[2];
SGE R1.z, fragment.texcoord[0].y, c[2].x;
SGE R1.y, fragment.texcoord[0].x, c[2].x;
MUL R1.y, R1, R1.z;
SGE R1.w, R1.x, fragment.texcoord[0].y;
SGE R1.z, R1.x, fragment.texcoord[0].x;
MUL R1.x, R1.y, R1.z;
ADD R0, -R0, c[1];
MUL R1.x, R1, R1.w;
MAD result.color, R1.x, R0, c[0];
END
# 12 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_LineColor]
Vector 1 [_GridColor]
Float 2 [_LineWidth]
"ps_2_0
; 17 ALU
def c3, 1.00000000, 0.00000000, 0, 0
dcl t0.xy
mov r0, c1
add r3, -c0, r0
add r1.x, t0.y, -c2
add r0.x, t0, -c2
add r2.x, -t0.y, -c2
add r2.x, r2, c3
cmp r1.x, r1, c3, c3.y
cmp r0.x, r0, c3, c3.y
mul r0.x, r0, r1
add r1.x, -t0, -c2
add r1.x, r1, c3
cmp r1.x, r1, c3, c3.y
cmp r2.x, r2, c3, c3.y
mul r0.x, r0, r1
mul r0.x, r0, r2
mad r0, r0.x, r3, c0
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { }
ConstBuffer "$Globals" 48 // 36 used size, 3 vars
Vector 0 [_LineColor] 4
Vector 16 [_GridColor] 4
Float 32 [_LineWidth]
BindCB "$Globals" 0
// 11 instructions, 2 temp regs, 0 temp arrays:
// ALU 7 float, 0 int, 2 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecednmllcjhfmlpldnofcaofdmdhcnfmndocabaaaaaagmacaaaaadaaaaaa
cmaaaaaakaaaaaaaneaaaaaaejfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapadaaaagfaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaaaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaedepemepfcaakl
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcjaabaaaaeaaaaaaa
geaaaaaafjaaaaaeegiocaaaaaaaaaaaadaaaaaagcbaaaaddcbabaaaabaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaabnaaaaaidcaabaaaaaaaaaaa
egbabaaaabaaaaaaagiacaaaaaaaaaaaacaaaaaaabaaaaakdcaabaaaaaaaaaaa
egaabaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaaaaaaaaaaaaadiaaaaah
bcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajccaabaaa
aaaaaaaaakiacaiaebaaaaaaaaaaaaaaacaaaaaaabeaaaaaaaaaiadpbnaaaaah
gcaabaaaaaaaaaaafgafbaaaaaaaaaaaagbbbaaaabaaaaaaabaaaaakgcaabaaa
aaaaaaaafgagbaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaiadpaaaaaaaa
diaaaaahbcaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaah
bcaabaaaaaaaaaaackaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaakpcaabaaa
abaaaaaaegiocaiaebaaaaaaaaaaaaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaa
dcaaaaakpccabaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaaegiocaaa
aaaaaaaaaaaaaaaadoaaaaab"
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
c3 1.0 0.0 0.0 0.0
c4 -1.0 1.0 1.0 0.0
[bc]
aaaaaaaaaaaaapacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c1
aaaaaaaaaeaaapacaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r4, c0
bfaaaaaaadaaapacaeaaaaoeacaaaaaaaaaaaaaaaaaaaaaa neg r3, r4
abaaaaaaadaaapacadaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r3, r3, r0
acaaaaaaabaaabacaaaaaaffaeaaaaaaacaaaaoeabaaaaaa sub r1.x, v0.y, c2
acaaaaaaaaaaabacaaaaaaoeaeaaaaaaacaaaaoeabaaaaaa sub r0.x, v0, c2
bfaaaaaaabaaacacaaaaaaffaeaaaaaaaaaaaaaaaaaaaaaa neg r1.y, v0.y
acaaaaaaacaaabacabaaaaffacaaaaaaacaaaaoeabaaaaaa sub r2.x, r1.y, c2
abaaaaaaacaaabacacaaaaaaacaaaaaaadaaaaoeabaaaaaa add r2.x, r2.x, c3
cjaaaaaaacaaacacabaaaaaaacaaaaaaadaaaaffabaaaaaa sge r2.y, r1.x, c3.y
adaaaaaaabaaabacaeaaaaaaabaaaaaaacaaaaffacaaaaaa mul r1.x, c4.x, r2.y
abaaaaaaabaaabacabaaaaaaacaaaaaaadaaaaoeabaaaaaa add r1.x, r1.x, c3
cjaaaaaaaeaaabacaaaaaaaaacaaaaaaaeaaaappabaaaaaa sge r4.x, r0.x, c4.w
adaaaaaaaaaaabacaeaaaaaaabaaaaaaaeaaaaaaacaaaaaa mul r0.x, c4.x, r4.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaoeabaaaaaa add r0.x, r0.x, c3
adaaaaaaaaaaabacaaaaaaaaacaaaaaaabaaaaaaacaaaaaa mul r0.x, r0.x, r1.x
bfaaaaaaabaaabacaaaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa neg r1.x, v0
acaaaaaaabaaabacabaaaaaaacaaaaaaacaaaaoeabaaaaaa sub r1.x, r1.x, c2
abaaaaaaabaaabacabaaaaaaacaaaaaaadaaaaoeabaaaaaa add r1.x, r1.x, c3
cjaaaaaaaeaaabacabaaaaaaacaaaaaaaeaaaappabaaaaaa sge r4.x, r1.x, c4.w
adaaaaaaabaaabacaeaaaaaaabaaaaaaaeaaaaaaacaaaaaa mul r1.x, c4.x, r4.x
abaaaaaaabaaabacabaaaaaaacaaaaaaadaaaaoeabaaaaaa add r1.x, r1.x, c3
cjaaaaaaaeaaabacacaaaaaaacaaaaaaaeaaaappabaaaaaa sge r4.x, r2.x, c4.w
adaaaaaaacaaabacaeaaaaaaabaaaaaaaeaaaaaaacaaaaaa mul r2.x, c4.x, r4.x
abaaaaaaacaaabacacaaaaaaacaaaaaaadaaaaoeabaaaaaa add r2.x, r2.x, c3
adaaaaaaaaaaabacaaaaaaaaacaaaaaaabaaaaaaacaaaaaa mul r0.x, r0.x, r1.x
adaaaaaaaaaaabacaaaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r0.x, r0.x, r2.x
adaaaaaaaaaaapacaaaaaaaaacaaaaaaadaaaaoeacaaaaaa mul r0, r0.x, r3
abaaaaaaaaaaapacaaaaaaoeacaaaaaaaaaaaaoeabaaaaaa add r0, r0, c0
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { }
ConstBuffer "$Globals" 48 // 36 used size, 3 vars
Vector 0 [_LineColor] 4
Vector 16 [_GridColor] 4
Float 32 [_LineWidth]
BindCB "$Globals" 0
// 11 instructions, 2 temp regs, 0 temp arrays:
// ALU 7 float, 0 int, 2 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedgacmncbhpebcioapoimicjfmigfkfonhabaaaaaakmadaaaaaeaaaaaa
daaaaaaagmabaaaaaeadaaaahiadaaaaebgpgodjdeabaaaadeabaaaaaaacpppp
aeabaaaadaaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaaaaadaaaaaaaaaaa
adaaaaaaaaaaaaaaaaacppppfbaaaaafadaaapkaaaaaiadpaaaaialpaaaaaaia
aaaaaaaabpaaaaacaaaaaaiaaaaaaplaabaaaaacaaaaaiiaadaaaakaacaaaaad
aaaaabiaaaaappiaacaaaakbacaaaaadaaaaaciaaaaaaaiaaaaafflbacaaaaad
aaaaabiaaaaaaaiaaaaaaalbfiaaaaaeaaaaaciaaaaaffiaadaaffkaadaakkka
fiaaaaaeaaaaabiaaaaaaaiaaaaaffiaadaappkaacaaaaadaaaaaciaaaaaffla
acaaaakbfiaaaaaeaaaaabiaaaaaffiaaaaaaaiaadaappkaacaaaaadaaaaacia
aaaaaalaacaaaakbfiaaaaaeaaaaabiaaaaaffiaaaaaaaiaadaappkaabaaaaac
abaaapiaaaaaoekafiaaaaaeaaaacpiaaaaaaaiaabaaoeiaabaaoekaabaaaaac
aaaicpiaaaaaoeiappppaaaafdeieefcjaabaaaaeaaaaaaageaaaaaafjaaaaae
egiocaaaaaaaaaaaadaaaaaagcbaaaaddcbabaaaabaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacacaaaaaabnaaaaaidcaabaaaaaaaaaaaegbabaaaabaaaaaa
agiacaaaaaaaaaaaacaaaaaaabaaaaakdcaabaaaaaaaaaaaegaabaaaaaaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaaaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaajccaabaaaaaaaaaaaakiacaia
ebaaaaaaaaaaaaaaacaaaaaaabeaaaaaaaaaiadpbnaaaaahgcaabaaaaaaaaaaa
fgafbaaaaaaaaaaaagbbbaaaabaaaaaaabaaaaakgcaabaaaaaaaaaaafgagbaaa
aaaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaiadpaaaaaaaadiaaaaahbcaabaaa
aaaaaaaabkaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaa
ckaabaaaaaaaaaaaakaabaaaaaaaaaaaaaaaaaakpcaabaaaabaaaaaaegiocaia
ebaaaaaaaaaaaaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaakpccabaaa
aaaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaaaaaaaaa
doaaaaabejfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apadaaaagfaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaafdfgfpfa
gphdgjhegjgpgoaafeeffiedepepfceeaaedepemepfcaaklepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklkl"
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