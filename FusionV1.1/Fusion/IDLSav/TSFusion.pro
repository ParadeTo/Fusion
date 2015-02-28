;参数说明
;CFileDir----低分辨率影像路径
;FFileDir----高分辨率影像路径
;OutputPath----输出路径
;Method----时空融合方法（STARFM, ESTARFM, STAVFM）
;WinSize----相似像元搜索窗口大小
;TWinSize----基准影像搜索窗口大小
;Message----返回错误信息

pro TSFusion,CFileDir,FFileDir,OutputPath,Method,WinSize,TWinSize,Message=Message
  ;test
;      CFileDir = 'D:\TestData\TSFusion\MODIS\'
;      FFileDir = 'D:\TestData\TSFusion\HJ\'
;      OutPutPath = 'D:\'
;      Method = 'STARFM'
;      WinSize = 3
;      TWinSize = 48
;      Message = ''
  compile_opt idl2
  ENVI,/RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT
  
  ;输出路径一些处理
  if strmid(OutputPath,strlen(OutputPath)-1,1) ne '\' then begin
    OutputPath = OutputPath+'\'
  endif
  test_file = file_test(OutputPath,/directory)
  if test_file eq 0 then begin
    file_mkdir,OutputPath
  endif
  
  
  ;para
  D = fix(TwinSize);预测影像搜索范围48天
  WinSize=fix(WinSize);窗口大小
  ;高分辨率文件、低分辨率文件个数
  CFiles = file_search(CFileDir+'*.tif',count=c_count)
  FFiles = file_search(FFileDir+'*.tif',count=f_count)
  num=0.0
  
  Fx = ''
  ;  Str = '时空融合进行中...'
  ;  ENVI_REPORT_INIT,Str,title="时空融合",base=base,/interrupt
  ;  ENVI_REPORT_INC,BASE,1
  for i_count=0,c_count-1 do begin
    ;得到MODIS影像文件中的年和JuliaDay
    basename=file_basename(CFiles[i_count],'.tif')
    field = strsplit(basename,'.',/extract)
    YearNum = fix(strmid(field[1],1,4))
    juliaday = fix(strmid(field[1],5,3))
    ;将JuliaDay转成年月日
    caldat,julday(1,1,YearNum)+juliaday-1,month,day,year
    Month = strtrim(string(month),2)
    Day = strtrim(string(day),2)
    YearStr = strtrim(string(Year),2)
    if strlen(Month) eq 1 then begin
      Month = '0'+Month
    endif
    if strlen(Day) eq 1 then begin
      Day = '0'+Day
    ENDIF
    ;搜索对应的HJ文件
    Mark = YearStr+Month+Day
    temp = file_search(FFileDir+'*'+Mark+'*',count=count)
    ;没搜索到，说明是待预测影像
    
    if count eq 0 then begin
      num = num+1
      ;预测影像文件名
      Fx = OutputPath+Mark+'_prediction'+'_'+method+'_'+STRTRIM(STRING(WinSize),2)
      ;预测期对应的MODIS影像
      Cx = CFiles[i_count]
      ;预测期对应的Juliaday，只对STAVFM有用
      Tx = juliaday
      ;往前搜索
      DaysMinusD = JuliaDay-indgen(D)-1
      caldat,julday(1,1,YearNum)+DaysMinusD-1,MonthMinusD,DayMinusD,Year
      MonthMinusDStr = strarr(n_elements(MonthMinusD))
      DayMinusDStr = strarr(n_elements(DayMinusD))
      for i_MinusD=0,n_elements(MonthMinusD)-1 do begin
        MonthMinusDStr[i_MinusD]=strtrim(string(MonthMinusD[i_MinusD]),2)
        DayMinusDStr[i_MinusD]=strtrim(string(DayMinusD[i_MinusD]),2)
        if strlen(MonthMinusDStr[i_MinusD]) eq 1 then begin
          MonthMinusDStr[i_MinusD] = '0'+MonthMinusDStr[i_MinusD]
        endif
        if strlen(DayMinusDStr[i_MinusD]) eq 1 then begin
          DayMinusDStr[i_MinusD] = '0'+strtrim(string(DayMinusDStr[i_MinusD]),2)
        ENDIF
      endfor
      ;往后搜索
      DaysPlusD = JuliaDay+indgen(D)+1
      caldat,julday(1,1,YearNum)+DaysPlusD-1,MonthPlusD,DayPlusD,Year
      MonthPlusDStr = strarr(n_elements(MonthPlusD))
      DayPlusDStr = strarr(n_elements(DayPlusD))
      for i_PlusD=0,n_elements(MonthPlusD)-1 do begin
        MonthPlusDStr[i_PlusD]=strtrim(string(MonthPlusD[i_PlusD]),2)
        DayPlusDStr[i_PlusD]=strtrim(string(DayPlusD[i_PlusD]),2)
        if strlen(MonthPlusDStr[i_PlusD]) eq 1 then begin
          MonthPlusDStr[i_PlusD] = '0'+MonthPlusDStr[i_PlusD]
        endif
        if strlen(DayPlusDStr[i_PlusD]) eq 1 then begin
          DayPlusDStr[i_PlusD] = '0'+strtrim(string(DayPlusDStr[i_PlusD]),2)
        ENDIF
      endfor
      MarksMinusD = YearStr+MonthMinusDStr+DayMinusDStr
      MarksPlusD = YearStr+MonthPlusDStr+DayPlusDStr
      ;搜索的结果
      FilesMinusD = file_search(FFileDir+'*'+MarksMinusD+'*.tif',count=countMinusD)
      FilesPlusD = file_search(FFileDir+'*'+MarksPlusD+'*.tif',count=countPlusD)
      ;用于预测的基影像
      C = []
      F = []
      T = []
      if countMinusD ne 0 then begin
        F = [F,FilesMinusD[0]]
        basename=file_basename(FilesMinusD[0],'.tif')
        field = strsplit(basename,'-',/extract)
        Year = fix(strmid(field[4],0,4))
        Month = fix(strmid(field[4],4,2))
        Day = fix(strmid(field[4],6,2))
        JuliaDayStr = strtrim(string(julday(Month,Day,Year)-julday(1,1,Year)+1),2)
        Mark=YearStr+JuliaDayStr
        T = [T,fix(JuliaDayStr)]
        CFile = file_search(CFileDir+'*'+Mark+'*.tif',count=count)
        C = [C,CFile]
      endif
      if countPlusD ne 0 then begin
        F = [F,FilesPlusD[0]]
        basename=file_basename(FilesPlusD[0],'.tif')
        field = strsplit(basename,'-',/extract)
        Year = fix(strmid(field[4],0,4))
        Month = fix(strmid(field[4],4,2))
        Day = fix(strmid(field[4],6,2))
        JuliaDayStr = strtrim(string(julday(Month,Day,Year)-julday(1,1,Year)+1),2)
        Mark=YearStr+JuliaDayStr
        T = [T,fix(JuliaDayStr)]
        CFile = file_search(CFileDir+'*'+Mark+'*.tif',count=count)
        C = [C,CFile]
      endif
      
      if method eq 'STARFM' THEN BEGIN
        if F[0] ne '' and C[0] ne '' then begin
          Message = fusion_ts_method_starfm(Fx,Cx,F,C,WinSize)
        endif else begin
        ;Message = '预测日期前后'+strtrim(string(D),2)+'天内找不到高分辨率影像！'
        endelse
      ENDIF ELSE IF METHOD EQ 'STAVFM' THEN BEGIN
        if F[0] ne '' and C[0] ne '' then begin
          Message = fusion_ts_method_stavfm(Fx,Cx,F,C,Tx,T,WinSize)
        endif else begin
        ;Message = '预测日期前后'+strtrim(string(D),2)+'天内找不到高分辨率影像！'
        endelse
      ENDIF ELSE IF METHOD eq 'ESTARFM' THEN BEGIN
        if N_ELEMENTS(F) EQ 2 and N_ELEMENTS(C) EQ 2 then begin        
          Message = fusion_ts_method_ESTARFM(Fx,F[0],F[1],Cx,C[0],C[1],WinSize)
        endif else begin
        ;Message = 'ESTARFM法需要预测日期前后'+strtrim(string(D),2)+'均有高分辨率影像！'
        endelse
      ENDIF
      sMessage = Message
      if sMessage eq 'Finish' then begin
        Message = '时空融合中断！'
        break
      endif
      
    ;      p=(num)*1.0/(c_count-f_count)*100.
    ;      ENVI_REPORT_STAT,BASE,p,100.,cancel=cancelvar
    ;      IF cancelvar eq 1 then begin
    ;        Message = '完成了'+strtrim(tring(num),2)+'景影像！'
    ;        ENVI_REPORT_INIT,base=base,/finish
    ;        ENVI_BATCH_EXIT
    ;        break
    ;      endif
    endif
  endfor
  if num eq 0 then begin
    Message = '不存在待预测的影像！'
  endif else begin
  ;    ENVI_REPORT_INIT,base=base,/finish
  endELSE
  ENVI_BATCH_EXIT
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;STARFM;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Description
;STARFM TS fusion function
;Simplified formula:
;L2=convol((M2-M1+L1)/ABS(L1-M1)/ABS(M1-M2),1/Dijk)/convol(1./ABS(L1-M1)/ABS(M1-M2),1/Dijk)
;
;Calling method
;fusion_ts_method_STARFM,Fx,Cx,FArr,CArr,WIN_SIZE,Message=Message
;
;
;win_size-window size
;errormsg=msg  Error massage
function fusion_ts_method_STARFM,Fx,Cx,FArr,CArr,WIN_SIZE

  compile_opt idl2
  ENVI,/RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT
  ;
  N_File = n_elements(FArr)
  ;打开影像
  ;打开高空间分辨率影像
  ENVI_OPEN_FILE,FArr,r_fid=FArr_fid
  for i_File=0,N_File-1 do begin
    if (FArr_fid[i_File] eq -1) then begin
      Message  = '打开'+FArr[i_File]+'失败!'
      return,Message
      envi_batch_exit
    endif
  endfor
  ;获得高空间分辨率影像参数
  envi_file_query,FArr_fid[0],ns=f_ns,nl=f_nl,dims=f_dims,nb=f_nb,DATA_TYPE=F_TYPE
  f_mapinfo=ENVI_GET_MAP_INFO(fid=FArr_fid[0])
  
  ;打开低空间分辨率影像
  ENVI_OPEN_FILE,CArr,r_fid=CArr_fid
  for i_File=0,N_File-1 do begin
    if (CArr_fid[i_File] eq -1) then begin
      Message  = '打开'+FArr[i_File]+'失败!'
      return,Message
      envi_batch_exit
    endif
  endfor
  ;获得低空间分辨率影像参数
  envi_file_query,CArr_fid[0],ns=C_ns,nl=C_nl,dims=C_dims,nb=C_nb
  C0_mapinfo=ENVI_GET_MAP_INFO(fid=C0_fid)
  
  ;打开与Fx对应的Cx
  ENVI_OPEN_FILE,Cx,r_fid=Cx_fid
  if (Cx_fid eq -1) then begin
    Message  = '打开'+Cx+'失败!'
    return,Message
    envi_batch_exit
  endif
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  Str = '正在融合生成：'+Fx
  ENVI_REPORT_INIT,Str,title="STARFM",base=base,/interrupt
  ENVI_REPORT_INC,BASE,1
  m=10
  ;块
  OPENW,lun,Fx,/GET_LUN
  block=500
  win_radius=win_size/2
  FOR line=win_radius,f_nl-win_radius-1,block DO BEGIN
    block_line=((line+block+win_radius-1<(f_nl-1))-line+win_radius+1)
    CArrDATA=FLTARR(f_ns,block_line,F_nb,N_File)
    FArrDATA=FLTARR(f_ns,block_line,F_nb,N_File)
    FxDATA=FLTARR(f_ns,block_line,F_nb)
    CxDATA=FLTARR(f_ns,block_line,F_nb)
    For i_File=0,N_File-1 do begin
      FOR i_nb=0,F_nb-1 DO BEGIN
        tempdata = ENVI_GET_DATA(DIMS=[-1L,0,f_ns-1,line-win_radius,(line+block-1+win_radius)<(f_nl-1)],FID=CArr_fid[i_File],POS=i_nb)
        CArrDATA[*,*,i_nb,i_File] = tempdata
      ENDFOR
    endfor
    For i_File=0,N_File-1 do begin
      FOR i_nb=0,F_nb-1 DO BEGIN
        tempdata = ENVI_GET_DATA(DIMS=[-1L,0,f_ns-1,line-win_radius,(line+block-1+win_radius)<(f_nl-1)],FID=FArr_fid[i_File],POS=i_nb)
        FArrDATA[*,*,i_nb,i_File] = tempdata
      ENDFOR
    endfor
    FOR i_nb=0,F_nb-1 DO BEGIN
      tempdata = ENVI_GET_DATA(DIMS=[-1L,0,f_ns-1,line-win_radius,(line+block-1+win_radius)<(f_nl-1)],FID=Cx_fid,POS=i_nb)
      CxDATA[*,*,i_nb] = tempdata
    ENDFOR
    
    ;;;;;;;;;Starfm;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    kernel=dblarr(win_size,win_size)
    for i=0,win_size-1 do begin
      for j=0,win_size-1 do begin
        KERNEL[i,j]=1./((sqrt((j-win_radius)^2+(i-win_radius)^2))+1.0)
      endfor
    endfor
    ;;;Choose candidates according to QA layer
    ;Omit
    ;;;Choose candidates according to spectral difference
    for i_nb=0,f_nb-1 do begin
      for j=win_radius, block_line-1-win_radius do begin
        for i=win_radius, f_ns-1-win_radius do begin
          Candidate=intarr(win_size,win_size)
          Numerator_Sum = 0.
          Denominator_Sum = 0.
          flag = 0
          For i_File=0,N_File-1 do begin
            ;求标准差这里只用到了当前波段的标准差，跟原版有点区别
            temp = reform(FArrDATA[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,i_File],1,WIN_SIZE*WIN_SIZE)
            tempm = moment(temp)
            Std=sqrt(tempm[1])
            Candidate[*,*]=1
            S=abs(FArrDATA[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,i_File]-$
              CArrDATA[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,i_File])
            T=abs(CxData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb]-$
              CArrData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,i_File])
            if min(T) eq 0 then begin
              FxData[i,j,i_nb] = CArrData[i,j,i_nb,i_File]
              flag=1
              break
            endif
            if min(S) eq 0 then begin
              FxData[i,j,i_nb] = CxData[i,j,i_nb]
              flag=1
              break
            endif
            Candidate=(ABS(FArrDATA[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,i_File]-FArrDATA[i,j,i_nb,i_File]) le Std/M)*$
              (S Le ABS(FArrDATA[i,j,i_nb,i_File]-CArrDATA[i,j,i_nb,i_File]))*(T Le ABS(CxData[i,j,i_nb]-CArrData[i,j,i_nb,i_File]))*Candidate
            Numerator_Sum = Numerator_Sum + 1/(S*T)*(CxData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb]+$
              FArrData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,i_File]-$
              CArrData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,i_File])*Candidate
            Denominator_Sum = Denominator_Sum + 1/(S*T)*Candidate
          endfor
          if flag eq 0 then begin
            numerator=convol(Numerator_Sum,kernel)
            denominator=convol(Denominator_Sum,kernel)
            FxData[i,j,i_nb] = (numerator[win_radius,win_radius]*1.0/denominator[win_radius,win_radius]+0.00000001)
          endif
        endfor
        p=((line-win_radius)*f_nb*(f_ns-2*win_radius)+i_nb*block_line*(f_ns-2*win_radius)+j*(f_ns-2*win_radius))*1./$
          ((f_nl-2*win_radius)*f_nb*(f_ns-2*win_radius))*100.
        ENVI_REPORT_STAT,BASE,p,100.,cancel=cancelvar
        if cancelvar eq 1 then begin
          Message = 'Finish'
          ENVI_REPORT_INIT,base=base,/finish
          return,Message
        endif
      endfor
    endfor
    IF block_line eq f_nl then begin;块大于影像
      FOR i_block_line=0,block_line-1 DO BEGIN
        WRITEU,lun,Fxdata[*,i_block_line,*]
      ENDFOR
    endif else if line eq win_radius then begin;块小于影像，第一块
      FOR i_block_line=0,block_line-1-win_radius DO BEGIN
        WRITEU,lun,Fxdata[*,i_block_line,*]
      ENDFOR
    endif else if line+block ge f_nl-win_radius-1 then begin;块小于影像，最后一块
      FOR i_block_line=win_radius,block_line-1 DO BEGIN
        WRITEU,lun,Fxdata[*,i_block_line,*]
      ENDFOR
    endif else begin
      FOR i_block_line=win_radius,block_line-1-win_radius DO BEGIN;块小于影像，中间的块
        WRITEU,lun,Fxdata[*,i_block_line,*]
      ENDFOR
    endelse
  ENDFOR
  FREE_LUN,lun
  
  ;生成结果文件及转成TIF
  ENVI_SETUP_HEAD,fname=Fx,ns=f_ns,nl=f_nl,nb=f_nb,$
    DATA_TYPE=F_TYPE,offset=0,INTERLEAVE=1,MAP_INFO=f_mapinfo, /write, /open
  ENVI_OPEN_FILE,fx,r_fid=Out_fid
  ENVI_OUTPUT_TO_EXTERNAL_FORMAT, DIMS=f_dims, $
    FID=Out_fid, OUT_NAME=Fx+'.tif',POS=LINDGEN(f_nb), /TIFF
  ENVI_FILE_MNG,ID=Out_fid,/DELETE,/REMOVE
  
  ENVI_REPORT_INIT,base=base,/finish
  return,''
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ESTARFM;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Description
;ESTARFM TS fusion function. Detail in paper 'An enhanced spatial and temporal adaptive reflectance fusion model for complex'
;Before use it. Coarse images must be resampled to have the same ns&nl&resolution with fine images
;
;Simplified formula:
;L2=L1+convol(V*(M2-M1),1/Dijk)/convol(1,1/Dijk)
;V can be calculated by F0 F1 C0 C1
;
;Calling method
;fusion_ts_method_ESTARFM(Fx,F0,F1,Cx,C0,C1,WIN_SIZE)
;
;F0 FX F1
;   |
;   |
;C0 CX C1
;
;F*----Fine resolution image filename
;C*----Coarse resolution image filename
;
;win_size----window size


function fusion_ts_method_ESTARFM,Fx,F0,F1,Cx,C0,C1,WIN_SIZE

  compile_opt idl2
  ENVI,/RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT
  ;;;;;;Open files
  ;Open F0 image
  ENVI_OPEN_FILE,F0,r_fid=f0_fid
  if (f0_fid eq -1) then begin
    Message = '打开'+F0+'失败！'
    return,Message
    envi_batch_exit
  endif
  ;Get parameters of F0 image
  envi_file_query,f0_fid,ns=f0_ns,nl=f0_nl,dims=f0_dims,nb=f0_nb,DATA_TYPE=F0_TYPE
  f0_mapinfo=ENVI_GET_MAP_INFO(fid=f0_fid)
  
  ;Open F1 image
  ENVI_OPEN_FILE,F1,r_fid=F1_fid
  if (F1_fid eq -1) then begin
    Message = '打开'+F1+'失败！'
    return,Message
    envi_batch_exit
  endif
  ;Get parameters of F1 image
  envi_file_query,F1_fid,ns=F1_ns,nl=F1_nl,dims=F1_dims,nb=F1_nb
  F1_mapinfo=ENVI_GET_MAP_INFO(fid=F1_fid)
  
  ;Open C0 image
  ENVI_OPEN_FILE,C0,r_fid=C0_fid
  if (C0_fid eq -1) then begin
    Message = '打开'+C0+'失败！'
    return,Message
    envi_batch_exit
  endif
  ;Get parameters of C0 image
  envi_file_query,C0_fid,ns=C0_ns,nl=C0_nl,dims=C0_dims,nb=C0_nb
  C0_mapinfo=ENVI_GET_MAP_INFO(fid=C0_fid)
  
  ;Open C1 image
  ENVI_OPEN_FILE,C1,r_fid=C1_fid
  if (C1_fid eq -1) then begin
    Message = '打开'+C1+'失败！'
    return,Message
    envi_batch_exit
  endif
  ;Get parameters of C1 image
  envi_file_query,C1_fid,ns=C1_ns,nl=C1_nl,dims=C1_dims,nb=C1_nb
  C1_mapinfo=ENVI_GET_MAP_INFO(fid=C1_fid)
  
  ;Open Cx image
  ENVI_OPEN_FILE,Cx,r_fid=Cx_fid
  if (Cx_fid eq -1) then begin
    Message = '打开'+Cx+'失败！'
    return,Message
    envi_batch_exit
  endif
  ;Get parameters of Cx image
  envi_file_query,Cx_fid,ns=Cx_ns,nl=Cx_nl,dims=Cx_dims,nb=Cx_nb
  Cx_mapinfo=ENVI_GET_MAP_INFO(fid=Cx_fid)
  
  m=10
  Str = '正在融合生成：'+Fx
  ENVI_REPORT_INIT,Str,title="ESTARFM",base=base,/interrupt
  ENVI_REPORT_INC,BASE,1
  ;Block
  OPENW,lun,Fx,/GET_LUN
  block=500
  win_radius=win_size/2
  FOR line=win_radius,f0_nl-win_radius-1,block DO BEGIN
    block_line=((line+block+win_radius-1<(f0_nl-1))-line+win_radius+1)
    C0DATA=FLTARR(C0_ns,block_line,C0_nb)
    C1DATA=FLTARR(C0_ns,block_line,C0_nb)
    CxDATA=FLTARR(C0_ns,block_line,C0_nb)
    F0DATA=FLTARR(f0_ns,block_line,F0_nb)
    F1DATA=FLTARR(f0_ns,block_line,F0_nb)
    FxDATA=FLTARR(f0_ns,block_line,F0_nb)
    FOR i_nb=0,C0_nb-1 DO BEGIN
      tempdata = ENVI_GET_DATA(DIMS=[-1L,0,c0_ns-1,line-win_radius,(line+block-1+win_radius)<(C0_nl-1)],FID=C0_fid,POS=i_nb)
      C0DATA[*,*,i_nb] = tempdata
    ENDFOR
    FOR i_nb=0,C0_nb-1 DO BEGIN
      tempdata = ENVI_GET_DATA(DIMS=[-1L,0,c0_ns-1,line-win_radius,(line+block-1+win_radius)<(C0_nl-1)],FID=C1_fid,POS=i_nb)
      C1DATA[*,*,i_nb] = tempdata
    ENDFOR
    FOR i_nb=0,C0_nb-1 DO BEGIN
      tempdata = ENVI_GET_DATA(DIMS=[-1L,0,c0_ns-1,line-win_radius,(line+block-1+win_radius)<(C0_nl-1)],FID=CX_fid,POS=i_nb)
      CXDATA[*,*,i_nb] = tempdata
    ENDFOR
    FOR i_nb=0,F0_nb-1 DO BEGIN
      tempdata = ENVI_GET_DATA(DIMS=[-1L,0,f0_ns-1,line-win_radius,(line+block-1+win_radius)<(f0_nl-1)],FID=F0_fid,POS=i_nb)
      F0DATA[*,*,i_nb] = tempdata
    ENDFOR
    FOR i_nb=0,F0_nb-1 DO BEGIN
      tempdata = ENVI_GET_DATA(DIMS=[-1L,0,f0_ns-1,line-win_radius,(line+block-1+win_radius)<(f0_nl-1)],FID=F1_fid,POS=i_nb)
      F1DATA[*,*,i_nb] = tempdata
    ENDFOR
    ;;;;;;;;;EStarfm;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;kernel
    kernel=dblarr(win_size,win_size)
    for i=0,win_size-1 do begin
      for j=0,win_size-1 do begin
        KERNEL[i,j]=1./((sqrt((j-win_radius)^2+(i-win_radius)^2))/(win_size/2.0)+1.0)
      endfor
    endfor
    
    ;;;Choose candidates according to QA layer
    ;Omit this proceed
    
    ;;;Choose candidates according to spectral difference
    for i_nb=0,F0_nb-1 do begin
      for j=win_radius,block_line-1-win_radius do begin
        for i=win_radius,f0_ns-1-win_radius do begin
          ;Correlation Coefficient
          FR=[F0DATA[i,j,*],F1DATA[i,j,*]]
          CR=[C0DATA[i,j,*],C1DATA[i,j,*]]
          MeanF=MEAN(FR)
          MeanC=MEAN(CR)
          FRMoment=Moment(FR)
          CRMoment=Moment(CR)
          Ri = MEAN((FR-MeanF)*(CR-MeanC))/(SQRT(FRMoment[1]*CRMoment[1]))
          
          ;;;;;;Calculate V
          ;Similar pixels
          temp = reform(F0DATA[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb],1,WIN_SIZE*WIN_SIZE)
          tempm = moment(temp)
          F0Standev=sqrt(tempm[1])
          temp = reform(F1DATA[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb],1,WIN_SIZE*WIN_SIZE)
          tempm = moment(temp)
          F1Standev=sqrt(tempm[1])
          T0SimArr = (abs(F0Data[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb]-F0Data[i,j,i_nb]) le F0Standev*2.0/m)
          T1SimArr = (abs(F1Data[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb]-F1Data[i,j,i_nb]) le F1Standev*2.0/m)
          
          ;Coarse-resolution vector
          Cv=[]
          T0SimArrC0 = T0SimArr*(C0DATA[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb]+0.0001)
          T1SimArrC1 = T1SimArr*(C1DATA[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb]+0.0001)
          n_F0SimArrC0=N_ELEMENTS(T0SimArrC0)
          FOR i_n_F0SimArrC0=0,n_F0SimArrC0-1 do begin
            if T0SimArrC0[i_n_F0SimArrC0] ne 0 then begin
              Cv=[Cv,T0SimArrC0[i_n_F0SimArrC0]]
            endif
          endfor
          n_F1SimArrC1=N_ELEMENTS(T1SimArrC1)
          FOR i_n_F1SimArrC1=0,n_F1SimArrC1-1 do begin
            if T1SimArrC1[i_n_F1SimArrC1] ne 0 then begin
              Cv=[Cv,T1SimArrC1[i_n_F1SimArrC1]]
            endif
          endfor
          ;Fine-resolution vector
          Fv=[]
          T0SimArrF0 = T0SimArr*$
            (F0DATA[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb]+0.0001);以免F0DATA中出现0时使得程序无法进行下去
          T1SimArrF1 = T1SimArr*$
            (F1DATA[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb]+0.0001)
          n_F0SimArrF0=N_ELEMENTS(T0SimArrF0)
          FOR i_n_F0SimArrF0=0,n_F0SimArrF0-1 do begin
            if T0SimArrF0[i_n_F0SimArrF0] gt -1 and  T0SimArrF0[i_n_F0SimArrF0] lt 2 and T0SimArrF0[i_n_F0SimArrF0] ne 0 then begin ;排除无穷小和无穷大
              Fv=[Fv,T0SimArrF0[i_n_F0SimArrF0]]
            endif
          endfoR
          n_F1SimArrF1=N_ELEMENTS(T1SimArrF1)
          FOR i_n_F1SimArrF1=0,n_F1SimArrF1-1 do begin
            if T1SimArrF1[i_n_F1SimArrF1] gt -1 and T1SimArrF1[i_n_F1SimArrF1] lt 2 and T1SimArrF1[i_n_F1SimArrF1] ne 0 then begin
              Fv=[Fv,T1SimArrF1[i_n_F1SimArrF1]]
            endif
          endfor
          ;Calculate Vi
          n_Cv = size(Cv)
          if n_Cv[1] gt 1 then begin
            Vi = regress(Cv,Fv)
          endif else begin
            Vi = Fv/Cv
          endelse
          ;Use F0 to predict Fx
          Temp1 = (CxData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb]-$
            C0Data[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb])*Vi[0]*T0SimArr*(1./(1.-Ri))
          numerator1=convol(Temp1,kernel)
          Temp2 = fltarr(win_size,win_size)
          Temp2[*,*] = 1
          Temp3=(1./(1.-Ri))*Temp2
          denominator1=convol(Temp3,kernel)
          ;Use F1 to predict Fx
          Temp2 = (C1Data[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb]-$
            CxData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb])*Vi[0]*T0SimArr*(1./(1.-Ri))
          numerator2=convol(Temp1,kernel)
          Temp2 = fltarr(win_size,win_size)
          Temp2[*,*] = 1
          Temp3=(1./(1.-Ri))*Temp2
          denominator2=convol(Temp3,kernel)
          ;T0
          TempSum = 1./abs(total(C0Data[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb])-$
            total(CxData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb]))+$
            1./abs(total(C1Data[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb])-$
            total(CxData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb]))
          Temp1=1./abs(total(C0Data[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb])-$
            total(CxData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb]))
          Temp2=1./abs(total(C1Data[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb])-$
            total(CxData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb]))
          T0=Temp1*1.0/TempSum
          T1=Temp2*1.0/TempSum
          if F0DATA[I,J,i_nb]-F1DATA[I,J,i_nb] eq 0 then begin
            Fxdata[i,j,i_nb]=(F0DATA[I,J,i_nb])
          endif else IF C0DATA[I,J,i_nb]-C1DATA[I,J,i_nb] eq 0 THEN begin
            Fxdata[i,j,i_nb]=(C0DATA[I,J,i_nb])
          endif else begin
            Result1=(F0Data[i,j,i_nb]+(numerator1[win_radius,win_radius]*1.0/denominator1[win_radius,win_radius]))
            Result2=(F1Data[i,j,i_nb]-(numerator2[win_radius,win_radius]*1.0/denominator2[win_radius,win_radius]))
            FxDATA[i,j,i_nb] = Result1*T0+Result2*T1
          endelsE
        endfor
        p=((line-win_radius)*f0_nb*(f0_ns-2*win_radius)+i_nb*block_line*(f0_ns-2*win_radius)+j*(f0_ns-2*win_radius))*1./$
          ((f0_nl-2*win_radius)*f0_nb*(f0_ns-2*win_radius))*100.
        ENVI_REPORT_STAT,BASE,p,100.,cancel=cancelvar
        if cancelvar eq 1 then begin
          Message = 'Finish'
          ENVI_REPORT_INIT,base=base,/finish
          return,Message
        endif
      endfor
    endfor
    
     IF block_line eq f0_nl then begin;块大于影像
      FOR i_block_line=0,block_line-1 DO BEGIN
        WRITEU,lun,Fxdata[*,i_block_line,*]
      ENDFOR
    endif else if line eq win_radius then begin;块小于影像，第一块
      FOR i_block_line=0,block_line-1-win_radius DO BEGIN
        WRITEU,lun,Fxdata[*,i_block_line,*]
      ENDFOR
    endif else if line+block ge f_nl-win_radius-1 then begin;块小于影像，最后一块
      FOR i_block_line=win_radius,block_line-1 DO BEGIN
        WRITEU,lun,Fxdata[*,i_block_line,*]
      ENDFOR
    endif else begin
      FOR i_block_line=win_radius,block_line-1-win_radius DO BEGIN;块小于影像，中间的块
        WRITEU,lun,Fxdata[*,i_block_line,*]
      ENDFOR
    endelse
    
  ENDFOR
  
  FREE_LUN,lun
  ENVI_SETUP_HEAD,fname=Fx,ns=f0_ns,nl=f0_nl,nb=f0_nb,$
    DATA_TYPE=F0_TYPE,offset=0,INTERLEAVE=1,MAP_INFO=f0_mapinfo, /write, /open
  ENVI_OPEN_FILE,fx,r_fid=Out_fid
  ENVI_OUTPUT_TO_EXTERNAL_FORMAT, DIMS=f0_dims, $
    FID=Out_fid, OUT_NAME=Fx+'.tif',POS=LINDGEN(f0_nb), /TIFF
  ENVI_FILE_MNG,ID=Out_fid,/DELETE,/REMOVE
  
  ENVI_REPORT_INIT,base=base,/finish
  return,''
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;STAVFM;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
function fusion_ts_method_STAVFM,Fx,Cx,FArr,CArr,Tx,TArr,WIN_SIZE
  compile_opt idl2
  ENVI,/RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT
  
  N_File = n_elements(FArr)
  
  ;打开影像
  ;打开高空间分辨率影像
  ENVI_OPEN_FILE,FArr,r_fid=FArr_fid
  for i_File=0,N_File-1 do begin
    if (FArr_fid[i_File] eq -1) then begin
      Message  = '打开'+FArr[i_File]+'失败!'
      return,Message
      envi_batch_exit
    endif
  endfor
  ;获得高空间分辨率影像参数
  envi_file_query,FArr_fid[0],ns=f_ns,nl=f_nl,dims=f_dims,nb=f_nb,DATA_TYPE=F_TYPE
  f_mapinfo=ENVI_GET_MAP_INFO(fid=FArr_fid[0])
  
  ;打开低空间分辨率影像
  ENVI_OPEN_FILE,CArr,r_fid=CArr_fid
  for i_File=0,N_File-1 do begin
    if (CArr_fid[i_File] eq -1) then begin
      Message  = '打开'+FArr[i_File]+'失败!'
      return,Message
      envi_batch_exit
    endif
  endfor
  ;获得低空间分辨率影像参数
  envi_file_query,CArr_fid[0],ns=C_ns,nl=C_nl,dims=C_dims,nb=C_nb
  C0_mapinfo=ENVI_GET_MAP_INFO(fid=C0_fid)
  
  ;打开与Fx对应的Cx
  ENVI_OPEN_FILE,Cx,r_fid=Cx_fid
  if (Cx_fid eq -1) then begin
    Message  = '打开'+Cx+'失败!'
    return,Message
    envi_batch_exit
  endif
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  Str = '正在融合生成：'+Fx
  ENVI_REPORT_INIT,Str,title="STAVFM",base=base,/interrupt
  ENVI_REPORT_INC,BASE,1
  M=10
  OPENW,lun,Fx,/GET_LUN
  block=500
  win_radius=win_size/2
  FOR line=win_radius,f_nl-win_radius-1,block DO BEGIN
    block_line=((line+block+win_radius-1<(f_nl-1))-line+win_radius+1)
    CArrDATA=FLTARR(f_ns,block_line,F_nb,N_File)
    FArrDATA=FLTARR(f_ns,block_line,F_nb,N_File)
    FxDATA=FLTARR(f_ns,block_line,F_nb)
    CxDATA=FLTARR(f_ns,block_line,F_nb)
    For i_File=0,N_File-1 do begin
      FOR i_nb=0,F_nb-1 DO BEGIN
        tempdata = ENVI_GET_DATA(DIMS=[-1L,0,f_ns-1,line-win_radius,(line+block-1+win_radius)<(f_nl-1)],FID=CArr_fid[i_File],POS=i_nb)
        CArrDATA[*,*,i_nb,i_File] = tempdata
      ENDFOR
    endfor
    For i_File=0,N_File-1 do begin
      FOR i_nb=0,F_nb-1 DO BEGIN
        tempdata = ENVI_GET_DATA(DIMS=[-1L,0,f_ns-1,line-win_radius,(line+block-1+win_radius)<(f_nl-1)],FID=FArr_fid[i_File],POS=i_nb)
        FArrDATA[*,*,i_nb,i_File] = tempdata
      ENDFOR
    endfor
    FOR i_nb=0,F_nb-1 DO BEGIN
      tempdata = ENVI_GET_DATA(DIMS=[-1L,0,f_ns-1,line-win_radius,(line+block-1+win_radius)<(f_nl-1)],FID=Cx_fid,POS=i_nb)
      CxDATA[*,*,i_nb] = tempdata
    ENDFOR
    
    ;;;;;;;;;Starfm;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    kernel=dblarr(win_size,win_size)
    for i=0,win_size-1 do begin
      for j=0,win_size-1 do begin
        KERNEL[i,j]=1./((sqrt((j-win_radius)^2+(i-win_radius)^2))+1.0)
      endfor
    endfor
    for i_nb=0,f_nb-1 do begin
      for j=win_radius, block_line-1-win_radius do begin
        for i=win_radius, f_ns-1-win_radius do begin
          ;预测窗口只有一期数据
          if N_File eq 1 then begin
            Candidate=intarr(win_size,win_size)
            Numerator_Sum = 0.
            Denominator_Sum = 0.
            ;相似像元过滤
            Candidate[*,*]=1
            ;求标准差这里只用到了当前波段的标准差，跟原版有点区别
            temp = reform(FArrDATA[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,0],1,WIN_SIZE*WIN_SIZE)
            tempm = moment(temp)
            Std=sqrt(tempm[1])
            ;核心代码
            S=abs(FArrDATA[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,0]-$
              CArrDATA[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,0])
            T=abs(CxData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb]-$
              CArrData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,0])
            Candidate=(ABS(FArrDATA[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,0]-FArrDATA[i,j,i_nb,0]) le Std/M)*$
              (S Le ABS(FArrDATA[i,j,i_nb,0]-CArrDATA[i,j,i_nb,0]))*(T Le ABS(CxData[i,j,i_nb]-CArrData[i,j,i_nb,0]))*Candidate
            Numerator_Sum = 1/(S*T)*(CxData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb]+$
              FArrData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,0]-$
              CArrData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,0])*Candidate
            Denominator_Sum = 1/(S*T)*Candidate
            numerator=convol(Numerator_Sum,kernel)
            denominator=convol(Denominator_Sum,kernel)
            ;特殊情况考虑
            if min(T) eq 0 then begin
              FxData[i,j,i_nb] = CArrData[i,j,i_nb,0]
            endif else if min(s) eq 0 then begin
              FxData[i,j,i_nb] = CxData[i,j,i_nb]
            endif else begin
              FxData[i,j,i_nb] = (numerator[win_radius,win_radius]*1.0/denominator[win_radius,win_radius])
            endelse
            
          ;预测窗口有两期数据
          endif else begin
            Candidate=intarr(win_size,win_size)
            Numerator_Sum = 0.0
            Denominator_Sum = 0.0
            Results = fltarr(2)
            for i_file=0,N_file-1 do begin
              Candidate[*,*]=1
              ;求标准差这里只用到了当前波段的标准差，跟原版有点区别
              temp = reform(FArrDATA[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,i_file],1,WIN_SIZE*WIN_SIZE)
              tempm = moment(temp)
              Std=sqrt(tempm[1])
              ;核心代码
              S=abs(FArrDATA[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,i_file]-$
                CArrDATA[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,i_file])
              T=abs(CxData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb]-$
                CArrData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,i_file])
              Candidate=(ABS(FArrDATA[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,i_File]-FArrDATA[i,j,i_nb,i_File]) le Std/M)*$
                (S Le ABS(FArrDATA[i,j,i_nb,i_File]-CArrDATA[i,j,i_nb,i_File]))*(T Le ABS(CxData[i,j,i_nb]-CArrData[i,j,i_nb,i_File]))*Candidate
              Numerator_Sum = 1/(S*T)*(CxData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb]+$
                FArrData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,i_file]-$
                CArrData[i-win_radius:i+win_radius,j-win_radius:j+win_radius,i_nb,i_file])*Candidate
              Denominator_Sum = 1/(S*T)*Candidate
              numerator=convol(Numerator_Sum,kernel)
              denominator=convol(Denominator_Sum,kernel)
              ;特殊情况考虑
              if min(T) eq 0 then begin
                Results[i_file] = CArrData[i,j,i_nb,i_file]
              endif else if MIN(S) eq 0 then begin
                Results[i_file] = CxData[i,j,i_nb]
              endif else begin
                Results[i_file] = (numerator[win_radius,win_radius]*1.0/denominator[win_radius,win_radius]+0.00000001)
              endelse
            endfor
            FxDATA[i,j,i_nb] = (Results[0]*abs(TArr[0]-Tx)+Results[1]*abs(TArr[1]-Tx))/(abs(TArr[0]-TArr[1]))
          endelse
        endfor
        p=((line-win_radius)*f_nb*(f_ns-2*win_radius)+i_nb*block_line*(f_ns-2*win_radius)+j*(f_ns-2*win_radius))*1./$
          ((f_nl-2*win_radius)*f_nb*(f_ns-2*win_radius))*100.
        ENVI_REPORT_STAT,BASE,p,100.,cancel=cancelvar
        if cancelvar eq 1 then begin
          Message = 'Finish'
          ENVI_REPORT_INIT,base=base,/finish
          return,Message
        endif
      endfor
    endfor
    ;写块
    IF block_line eq f_nl then begin;块大于影像
      FOR i_block_line=0,block_line-1 DO BEGIN
        WRITEU,lun,Fxdata[*,i_block_line,*]
      ENDFOR
    endif else if line eq win_radius then begin;块小于影像，第一块
      FOR i_block_line=0,block_line-1-win_radius DO BEGIN
        WRITEU,lun,Fxdata[*,i_block_line,*]
      ENDFOR
    endif else if line+block ge f_nl-win_radius-1 then begin;块小于影像，最后一块
      FOR i_block_line=win_radius,block_line-1 DO BEGIN
        WRITEU,lun,Fxdata[*,i_block_line,*]
      ENDFOR
    endif else begin
      FOR i_block_line=win_radius,block_line-1-win_radius DO BEGIN;块小于影像，中间的块
        WRITEU,lun,Fxdata[*,i_block_line,*]
      ENDFOR
    endelse
  ENDFOR
  FREE_LUN,lun
  
  ;Output the file
  ENVI_SETUP_HEAD,fname=Fx,ns=f_ns,nl=f_nl,nb=f_nb,$
    DATA_TYPE=F_TYPE,offset=0,INTERLEAVE=1,MAP_INFO=f_mapinfo, /write, /open
  ENVI_OPEN_FILE,fx,r_fid=Out_fid
  ENVI_OUTPUT_TO_EXTERNAL_FORMAT, DIMS=f_dims, $
    FID=Out_fid, OUT_NAME=Fx+'.tif',POS=LINDGEN(f_nb), /TIFF
  ENVI_FILE_MNG,ID=Out_fid,/DELETE,/REMOVE
  
  ENVI_REPORT_INIT,base=base,/finish
  return,''
end