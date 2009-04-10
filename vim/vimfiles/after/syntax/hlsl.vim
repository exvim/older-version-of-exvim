" ======================================================================================
" File         : hlsl.vim
" Author       : Wu Jie 
" Last Change  : 10/21/2008 | 22:54:01 PM | Tuesday,October
" Description  : 
" ======================================================================================

"/////////////////////////////////////////////////////////////////////////////
" check script loading
"/////////////////////////////////////////////////////////////////////////////

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Read the C syntax to start with
if version < 600
  so <sfile>:p:h/c.vim
  so $VIM/vimfiles/after/syntax/c.vim
else
  runtime! syntax/c.vim
  runtime! $VIM/vimfiles/after/syntax/c.vim
  unlet b:current_syntax
endif

"/////////////////////////////////////////////////////////////////////////////
" syntax defines
"/////////////////////////////////////////////////////////////////////////////

" keyword definitions
" case match
syntax case match
" storage
syn keyword hlslStorage         extern shared static uniform volatile

" base type
syn keyword hlslType            const row_major col_major
syn keyword hlslType            snorm4 unorm4 matrix
syn match   hlslType            "\<\(bool\|int\|half\|float\|double\)[1-4]*\>"
syn match   hlslType            "\<\(bool\|int\|half\|float\|double\)[1-4]x[1-4]\>"
syn keyword hlslType            vertexshader pixelshader struct typedef
syn keyword hlslType            in out

" shader type
syn match   hlslShaderType      "\<\(vs\|ps\|gs\)_[1-4]_[0-4]\>"
syn keyword hlslBaseFunction    CompileShader SetVertexShader SetGeometryShader SetPixelShader SetDepthStencilState pass compile technique

" function
syn keyword hlslFunction        abs acos all any asin atan atan2 ceil clamp clip cos cosh cross 
syn keyword hlslFunction        D3DCOLORtoUBYTE4 ddx ddy degress determinant distance dot exp exp2
syn keyword hlslFunction        faceforward floor fmod frac frexp fwidth isfinite isinf isnan ldexp
syn keyword hlslFunction        length lerp lit log log10 log2 max min modf mul noise normalize pow
syn keyword hlslFunction        radians reflect refract round rsqrt saturate sign sin sincos sinh
syn keyword hlslFunction        smoothstep sqrt step tan tanh tex1D tex1Dqrad tex1Dbias tex1Dgrad 
syn keyword hlslFunction        tex1Dlod tex1Dproj tex2D tex2Dbias tex2Dqrad tex2Dlod tex2Dproj
syn keyword hlslFunction        tex3D tex3Dbias tex3Dqrad tex3Dlod tex3Dproj texCUBE texCUBEqrad
syn keyword hlslFunction        texCUBEproj transpose

" case ignore
syntax case ignore
"syn match   hlslSemantic        "\<\(BINORMAL\|BLENDINDICES\|BLENDWEIGHT\|COLOR\|NORMAL\|POSITION\|PSIZE\|TANGENT\|TESSFACTOR\|TEXCOORD\|DEPTH\)[0-7]*\>" contained
"syn match   hlslSemantic        "\<\(POSITIONT\|FOG\|PSIZE\|VFACE\|VPOS\)\>" contained
"syn match   hlslSemantic        "\<\(SV_ClipDistance\|SV_CullDistance\|SV_Target\)[0-7]*\>" contained
"syn match   hlslSemantic        "\<\(SV_ClipDistance\|SV_CullDistance\|SV_Depth\|SV_InstanceID\|SV_IsFrontFace\|SV_Position\|SV_PrimitiveID\|SV_RenderTargetArrayIndex\|SV_Target\|SV_VertexID\|SV_ViewportArrayIndex\)\>" contained

syn match   hlslType            "\<\(Texture\|sampler\)[1-3]D\>"
syn keyword hlslType            sampler texture filter
syn match   hlslType            "address[u,v,w]"

"/////////////////////////////////////////////////////////////////////////////
" exMacroHighlight Predeined Syntax
"/////////////////////////////////////////////////////////////////////////////

" add hlsl enable group
syn cluster exEnableContainedGroup add=hlslStorage,hlslType,hlslShaderType,hlslBaseFunction,hlslBaseFunction,hlslFunction

"/////////////////////////////////////////////////////////////////////////////
" highlight defines
"/////////////////////////////////////////////////////////////////////////////

" Define the default highlighting.
if version >= 508 || !exists("did_hlsl_syntax_inits")
  if version < 508
    let did_hlsl_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink hlslStorage         StorageClass
  HiLink hlslType            Type
  HiLink hlslBaseFunction    Type
  HiLink hlslShaderType      Special
  HiLink hlslFunction        Function
  HiLink hlslSemantic        Special
  delcommand HiLink
endif

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

let b:current_syntax = "hlsl"

" vim: ts=8


