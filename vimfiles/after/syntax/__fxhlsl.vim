" Vim syntax file
" Language:	HLSL FX
" Maintainer:	Kevin Bjorke <kbjorke@nvidia.com>
" Last change:	$Date: 2003/12/05 $
" File Types:	.hlsl .fxc .fx .fxh
" $Id: //devrel/Playpen/kbjorke/doc/fx.vim#3 $

" Added: a number of useful insert-mode abbreviations for creating tweakables entries and
"	their default values. See end of the file for definitions. (":ia" will list them,
"	but cryptically)

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Read the C syntax to start with
if version < 600
  so <sfile>:p:h/c.vim
else
  runtime! syntax/c.vim
  unlet b:current_syntax
endif

" HLSL extentions
syn keyword fxStatement		tex1D tex2D tex3D texRECT texCUBE
syn keyword fxStatement		tex1Dproj tex2Dproj tex3Dproj texRECTproj texCUBEproj
" syn keyword fxStatement	tex1D_proj tex2D_proj tex3D_proj texRECT_proj texCUBE_proj
" syn keyword fxStatement	tex1D_bias tex2D_bias tex3D_bias texRECT_bias texCUBE_bias
syn keyword fxStatement		offsettex2D offsettexRECT offsettex2DScaleBias offsettexRECTScaleBias 
syn keyword fxStatement		tex1D_dp3 tex2D_dp3x2 texRECT_dp3x2
syn keyword fxStatement		tex3D_dp3x3 texCUBE_dp3x3 tex_dp3x2_depth
syn keyword fxStatement		texCUBE_reflect_dp3x3 texCUBE_reflect_eye_dp3x3
syn keyword fxStatement		discard
syn keyword fxProfile		arbfp1 arbvp1
syn keyword fxProfile		ps_1_1 ps_1_2 ps_1_3 vs_1_1 vs_2_0 vs_2_x ps_2_0 ps_2_x
syn keyword fxProfile		fp20 vp20 fp30 vp30
" many HLSL data types
syn keyword fxType		bool bool2 bool3 bool4
syn keyword fxType		bool1x2 bool1x3 bool1x4
syn keyword fxType		bool2x2 bool2x3 bool2x4
syn keyword fxType		bool3x2 bool3x3 bool3x4
syn keyword fxType		bool4x2 bool4x3 bool4x4
syn keyword fxType		half half2 half3 half4
syn keyword fxType		half1x2 half1x3 half1x4
syn keyword fxType		half2x2 half2x3 half2x4
syn keyword fxType		half3x2 half3x3 half3x4
syn keyword fxType		half4x2 half4x3 half4x4
syn keyword fxType		fixed fixed2 fixed3 fixed4
syn keyword fxType		fixed1x2 fixed1x3 fixed1x4
syn keyword fxType		fixed2x2 fixed2x3 fixed2x4
syn keyword fxType		fixed3x2 fixed3x3 fixed3x4
syn keyword fxType		fixed4x2 fixed4x3 fixed4x4
" 'float' is already a C type
syn keyword fxType		float2 float3 float4
syn keyword fxType		float1x2 float1x3 float1x4
syn keyword fxType		float2x2 float2x3 float2x4
syn keyword fxType		float3x2 float3x3 float3x4
syn keyword fxType		float4x2 float4x3 float4x4
" likewise 'int'
syn keyword fxType		int2 int3 int4
syn keyword fxType		int1x2 int1x3 int1x4
syn keyword fxType		int2x2 int2x3 int2x4
syn keyword fxType		int3x2 int3x3 int3x4
syn keyword fxType		int4x2 int4x3 int4x4
" texture types
syn keyword fxType		sampler1D sampler2D sampler3D samplerCUBE
" syn keyword fxType		samplerRECT
" compile-time special types
" syn keyword fxType		cint cfloat

syn keyword fxAnnotation	Space UIDesc UIName UIObject UIType UIMin UIMax UIStep
syn keyword fxAnnotation	Texture MinFilter MagFilter MipFilter AddressU AddressV AddressW
syn keyword fxAnnotation	usage width height levels DepthBuffer format
syn keyword fxAnnotation	geometry cleardepth clearcolor rendertarget

" how to disable switch continue case default int break goto double enum union

" syn keyword fxSamplerArg	MinFilter MagFilter MipFilter
syn match fxSamplerArg	/\<\c\(min\|mag\|mip\)filter\>/
syn keyword fxSamplerArg	AddressU AddressV AddressW

" fx
syn keyword fxStatement		compile asm
syn keyword fxType		string texture technique pass

" syn match fxCast		"\<\(const\|static\|dynamic\|reinterpret\)_cast\s*<"me=e-1
" syn match fxCast		"\<\(const\|static\|dynamic\|reinterpret\)_cast\s*$"
syn match fxSwizzle		/\.[xyzw]\{1,4\}/
syn match fxSwizzle		/\.[rgba]\{1,4\}/
syn match fxSwizzle		/\.\(_m[0-3]\{2}\)\{1,4\}/
syn match fxSwizzle		/\.\(_[1-4]\{2}\)\{1,4\}/
syn match fxSemantic		/:\s*[A-Z]\w*/
syn keyword fxStorageClass	in out inout uniform packed const
syn keyword fxNumber	NPOS
"syn keyword fxBoolean	true false none
syn match fxBoolean	/\<\c\(true\|false\|none\)\>/

" The minimum and maximum operators in GNU C++
syn match fxMinMax "[<>]?"

" Default highlighting
if version >= 508 || !exists("did_fx_syntax_inits")
  if version < 508
    let did_fx_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  " HiLink fxCast			fxStatement
  HiLink fxStatement		fxStatement
  HiLink fxProfile		fxStatement
  HiLink fxSamplerArg		fxStatement
  HiLink fxStatement		Statement
  HiLink fxType			Type
  HiLink fxType			Type
  HiLink fxStorageClass		StorageClass
  HiLink fxSemantic		Structure
  HiLink fxNumber		Number
  highlight fxAnnotation	ctermfg=red guifg=red
  highlight fxSwizzle		ctermfg=magenta guifg=magenta
  HiLink fxBoolean		Boolean
  delcommand HiLink
endif

"make compatible with VS.Net and FXComposer...
set ts=4

let b:current_syntax = "fx"

"
" ABBREVIATIONS FOR FX FILES
"

" Float tweakables of various sorts
iabbrev fl! float Name : POWER <string UIName = "UI Name";string UIType = "slider";float UIMin = 0.0;float UIMax = 1.0;float UIStep = 0.01;> = 0.0f;<Up><Up><Up><Up><Up><Up>
iabbrev f1! float Name : POWER <string UIName = "UI Name";string UIType = "slider";float UIMin = 0.0;float UIMax = 1.0;float UIStep = 0.01;> = 0.0f;<Up><Up><Up><Up><Up><Up>
iabbrev f2! float2 Name <string UIName = "UI Name";> = { 0.0f, 0.0f};<Up><Up>
iabbrev f3! float3 Name <string UIName = "UI Name";> = { 0.0f, 0.0f, 0.0f};<Up><Up>
iabbrev f4! float4 Name <string UIName = "UI Name";> = { 0.0f, 0.0f, 0.0f, 0.0f};<Up><Up>

" 4x4 matrix with identity
iabbrev xf! float4x4 Name = {1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1};

" color tweakables as float3 or float4
iabbrev c3! float3 Name : DIFFUSE <string UIName = "Color Name";string UIType = "Color";> = {1.0f, 1.0f, 1.0f};<Up><Up><Up>
iabbrev c4! float4 Name : DIFFUSE <string UIName = "Color Name";string UIType = "Color";> = {1.0f, 1.0f, 1.0f, 1.0f};<Up><Up><Up>

" direction tweakables as float3 or float4
iabbrev d3! float3 Name : DIRECTION <string UIName = "Direction";string UIObject = "DirectionalLight";string Space = "World";> = {0.717f, 1.0f, 0.717f};<Up><Up><Up><Up>
iabbrev d4! float4 Name : DIRECTION <string UIName = "Direction";string UIObject = "DirectionalLight";string Space = "World";> = {0.717f, 1.0f, 0.717f, 0.0f};<Up><Up><Up><Up>

" position tweakables as float3 or float4
iabbrev p3! float3 Name : POSITION <string UIName = "Position";string UIObject = "PointLight";string Space = "World";> = {10.0f, 10.0f, 10.0f};<Up><Up><Up><Up>
iabbrev p4! float4 Name : POSITION <string UIName = "Position";string UIObject = "PointLight";string Space = "World";> = {10.0f, 10.0f, 10.0f, 1.0f};<Up><Up><Up><Up>

" standard set of "untweakables"
iabbrev ut! float4x4 WorldITXf : WorldInverseTranspose = {1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1};float4x4 WvpXf : WorldViewProjection;float4x4 WorldXf : World;float4x4 ViewIXf : ViewInverse;

" simple pass (within a technique)
iabbrev ps! pass PassName {VertexShader = compile vs_2_0 namedVS();ZEnable = true;ZWriteEnable = false;ZFunc = LessEqual;CullMode = None;AlphaBlendEnable = true;SrcBlend = One;DestBlend = One;PixelShader = compile ps_2_a namedPS();}<Up><Up><Up><Up><Up><Up><Up><Up><Up><Up>

" application data struct declaration
iabbrev ad! /* data from application vertex buffer */struct appdata {float3 Position	: POSITION;float4 Normal	: NORMAL;float4 Tangent	: TANGENT0;float4 Binormal	: BINORMAL0;float4 UV		: TEXCOORD0;};<Up><Up><Up><Up><Up><Up>

" vertex data struct declaration
iabbrev vd! struct vertexOutput {float4 HPosition	: POSITION;float2 UV		: TEXCOORD0;float3 LightVec	: TEXCOORD1;float3 WorldNormal	: TEXCOORD2;float3 WorldEyeVec	: TEXCOORD3;float3 WorldTangent	: TEXCOORD4;float3 WorldBinormal : TEXCOORD5;};<Up><Up><Up><Up><Up><Up><Up><Up>

" file-based 2D texture and sampler declaration
iabbrev tx! texture NamedTexture : DiffuseMap <string Name = "default_color.dds";string type = "2D";>;sampler2D NamedSampler = sampler_state{Texture = <NamedTexture>;MinFilter = Linear;MagFilter = Linear;MipFilter = Linear;AddressU = WRAP;AddressV = WRAP;};<Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up>

" render-to-texture texture and sampler declaration
iabbrev rtx! #define RTT_SIZE 256texture RTTMap1<string usage = "RenderTarget";int width = RTT_SIZE;int height = RTT_SIZE;int levels = 1;bool DepthBuffer = true;string format = "X8R8G8B8";>;sampler RTTSamp1 = sampler_state{texture = <RTTMap1>;AddressU  = CLAMP;AddressV  = CLAMP;AddressW  = CLAMP;MIPFILTER = NONE;MINFILTER = LINEAR;MAGFILTER = LINEAR;};<Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up>

" declaration of data structure and vertex shader for using "fullscreenquad" geometry
iabbrev vq! struct rttOut{float4 Position	: POSITION;float4 Diffuse	: COLOR0;float4 UV		: TEXCOORD0;};rttOut VS_Quad(float3 Position : POSITION,float3 TexCoord : TEXCOORD0) {rttOut OUT;VS_OUTPUT OUT = (rttOut)0;OUT.Position = float4(Position, 1);OUT.UV = float4(TexCoord, 1); OUT.Diffuse = (1).xxxx; return (OUT);}<Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up>

" render-to-texture pass declarations (within technique) -- create and use
iabbrev rtp! pass WriteBuffer <string rendertarget = "RTTMap1";float cleardepth = 1.0f;dword clearcolor = 0x0;> {cullmode = none;ZEnable = true;VertexShader = compile vs_1_1 namedVS();PixelShader  = compile ps_2_0 namedPS();}pass ReadBuffer <string geometry = "fullscreenquad";> {cullmode = none;ZEnable = false;ZWriteEnable = false;AlphaBlendEnable = true;SrcBlend = one;DestBlend = one;VertexShader = compile vs_1_1 VS_Quad();PixelShader = compile ps_2_0 imageProcessPS(RTTSamp1);}<Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up>

" FX-generated 2D texture, sampler, and template function
iabbrev gtx! #define GEN_TEX_SIZE 64texture namedGenTex <string function = "namedGenFunc";int width = GEN_TEX_SIZE;int height = GEN_TEX_SIZE;>;sampler2D namedGenSampler = sampler_state{Texture = <namedGenTex>;MinFilter = LINEAR;MagFilter = LINEAR;MipFilter = LINEAR;AddressU = WRAP;AddressV = WRAP;};/* generate texture colors for the above */float4 namedGenFunc(float2 Pos : POSITION,float2 texelSize : PSIZE) : COLOR{return float4(Pos.xy,1,1);}<Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up>

" ambient light color
iabbrev la! float3 AmbiLightColor : AMBIENT<string UIName =  "Ambient Color";string UIType = "Color";> = {0.1f, 0.1f, 0.1f};<Up><Up><Up><Up>

" Directional Light Parameters
iabbrev ld! // Directional Light 1 ////float3 LightDirD1 : DIRECTION<string UIName = "Light Direction 1";string UIObject = "DirectionalLight";string Space = "World";> = {-0.7f, 1.0f, 0.7f};float3 LightColorD1 : SPECULAR<string UIName =  "Dist Light Color 1";string UIType = "Color";> = {1.0f, 0.9f, 0.8f};<Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up>

" Point light parameters
iabbrev lp! // Point Light 1 ////float4 LightPosP1 : POSITION <string UIName = "Light Pos 1";string UIObject = "PointLight";string Space = "World";> = {10.0f, 10.0f, 10.0f, 1.0f};float4 LightColorP1 : SPECULAR <string UIName = "Light Color 1";string UIType = "Color";> = {1.0f, 1.0f, 1.0f, 1.0f};float LightIntensityP1 <string UIName = "Light Strength 1";string UIType = "slider";float UIMin = 0.0;float UIMax = 10000.0;float UIStep = 1.0;> = 10.0f;<Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up><Up>

" vim: ts=8
