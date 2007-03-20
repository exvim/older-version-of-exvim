" Vim syntax file
" Language:	avs - An avisynth movie script file
" Maintainer:	Justin Randall <Randall311@yahoo.com>
" Last change:	30 November 2005

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore

" Keywords
syn keyword avsKeyword if else while for break continue return result 
syn keyword avsKeyword LoadPlugin input output Import RawSource readAvs
syn keyword avsKeyword mpeg2source VobSub AviSource BlankClip Mpeg2dec

" Variable
syn keyword avsType Decimate Crop Blur 2DCleanYUY2 AdaptiveMedian AddGrain
syn keyword avsType Telecide LanczosResize Undot Subtitle SSIQ Adjust
syn keyword avsType GreyScale FFT3dFilter LeakKernelDeint MipSmooth
syn keyword avsType ReduceBy2 smoothuv SmartSSIQ BiFrost Dust edgemask
syn keyword avsType derainbow AddBorders AddAudio ConvertToYUY2 TDeint
syn keyword avsType Blend LimitedSharpen GuavaComb TFM BiFrost aWarpSharp
syn keyword avsType Lanczos4Resize FixVHSOverSharp Temporalsoften
syn keyword avsType mergechroma FluxSmoothST Convolution3D Antiflicker Area
syn keyword avsType Asharp Atc AudioGraph AutoCrop AutoYUY2 AVInfo AviShader
syn keyword avsType AvsTimer BeFa Blockbuster BorderControl Call CheckMask
syn keyword avsType Chromashift CNR2 Colorit ColorMatrix CompareYV12 
syn keyword avsType ConditionalTemporalMedian ColourizeSmooth ColourLike
syn keyword avsType DCT DctFilter Deblend DeBlot DeClick Decomb Deen DeFreq
syn keyword avsType DeGrainMedian DeNoise DePan Descratch Despot DGBob DNR2
syn keyword avsType DumpPixelValues Dup DVInfo DVUtilities DVTimeStampEx Edeen
syn keyword avsType EdiUpsizer EffectsMany EquLines EvilMPASource ExpSat
syn keyword avsType ExtendedBilateral FanFilter FFT3DFilter FFT3Dgpu FFTW3
syn keyword avsType FillMargins FixVHSOversharp Fluxsmooth FrameDbl FreeFrame
syn keyword avsType GenMotion GetDups GetSystemEnv GiCocu GraMaMa GrapeSmoother
syn keyword avsType GreedyHMA Grid GuavaComb Hdragc HistogramAdjust HollywoodSQ
syn keyword avsType HQdn3d ImageSequence InterpolationBob InverseTelecine IT IUF
syn keyword avsType KernelDeint Kronos MaskTools MedianBlur MergeClips MipSmooth
syn keyword avsType MPASource Mpegdecoder Msharpen Msmooth MT MultiDecimate
syn keyword avsType MVTools NeuralNet NicAudio NoiseGenerator NoMoSmooth 
syn keyword avsType PeachSmoother PlaneMinMax PseudoColor Reform ReMatch RePal
syn keyword avsType ProgressiveFrameRestorer RemoveBlend RemoveDirt RemoveGrain
syn keyword avsType RestoreFPS ReverseFieldDominance RGBManipulate SangNom 
syn keyword avsType Scanlines SceneChangeLavc ShowPixelValues SimpleResize
syn keyword avsType SmartDecimate SmartSmoother SmoothDeinterlacer SmootherHiQ
syn keyword avsType SmoothUV SSIM SSIQ STMedianFilter SubtitleEx TBilateral
syn keyword avsType TComb TDeint TemporalCleaner Textsub TIvtc TomsMoComp 
syn keyword avsType TMonitor TPRivtc TransAll Transition TTempSmooth TUnsharp
syn keyword avsType TweakColor UnComb Unblend Unfilter VagueDenoiser 
syn keyword avsType VariableBlur Videoscope ViewAudio ViewFields UnViewFields
syn keyword avsType VQMCalc WarpSharp WarpSharpYV12 WaterShed Xlogo XStatImport
syn keyword avsType YV12InterlacedReduceBy2 Zoom LBKillerLBKiller BlendBob

" Identifier
syn keyword Identifier avsynth version true false

" String
syn match avsString		"\"[^"]*\""

" Number
syn match avsNumber		"[0-9]\+"

" Comment
syn match avsComment		"\#.*"

" Parent ()
syn cluster avsAll contains=avsList,avsIdentifier,avsNumber,avsKeyword,avsType,avsConstant,avsString,avsParentError


syn case match

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_avs_syntax_inits")
  if version < 508
    let did_avs_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink avsKeyword		Statement
  HiLink avsType		Type
  HiLink avsIdentifier		Identifier
  HiLink avsNumber		Number
  HiLink avsComment		Comment
  HiLink avsString		String
  HiLink avsSpecialChar		SpecialChar
  HiLink avsParenError		Error

  delcommand HiLink
endif

let b:current_syntax = "avs"
" vim: ts=8
