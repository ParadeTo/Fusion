PRO SpecFusionAss,FilenameAss,FilenameRef,OutputPath,QuaKind,QuaArr,Message=Message
  ;Test
  ;  FilenameAss = 'D:\Fusion\Data\HXFusion\IRS\9-hj1b-irs-452-56-20130826.tif'
  ;  FilenameRef = 'D:\Fusion\Data\HXFusion\IRS\9-hj1b-irs-452-56-20130826.tif'
  ;  OutPutPath = 'D:\'
  ;  QuaKind = '空间质量'
  ;  QuaArr = ['TRUE','TRUE','TRUE','TRUE','TRUE','TRUE','TRUE','TRUE','TRUE','TRUE','TRUE']
  ;描述:
  ;光谱融合后质量评价
  ;
  ;参数说明：
  ;FilenameAss----待评价的文件数组
  ;FilenameRef----参考影像文件数组
  ;OutputPath----输出路径
  ;QuaArr----评价指标（暂时为6个）
  ;Message----返回消息
  compile_opt idl2
  ENVI,/RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT
  
  ;高空间分辨率影像各个波段的平均作为全色影像
  band = 6
  Kernel = 'Laplacian1'
  ;输出路径一些处理
  if strmid(OutputPath,strlen(OutputPath)-1,1) ne '\' then begin
    OutputPath = OutputPath+'\'
  endif
  test_file = file_test(OutputPath,/directory)
  if test_file eq 0 then begin
    file_mkdir,OutputPath
  endif
  ;影像个数
  countImg = n_elements(FilenameAss)
  for i_countimg = 0,countImg-1 do begin
    if QuaKind eq 'SpecQua' then begin
      ;
      ENVI_OPEN_FILE,FilenameAss[i_countimg],R_FID=AssFid
      ENVI_OPEN_FILE,FilenameRef[i_countimg],R_FID=RefFid
      ENVI_FILE_QUERY,RefFid,nb=m_nb,nl=m_nl,ns=m_ns
      ENVI_FILE_QUERY,AssFid,nb=f_nb,nl=f_nl,ns=f_ns
      if m_nb ne f_nb then begin
        Message = '融合影像与参考影像波段不一致！'
        break
      endif
      f_data = fltarr(f_ns,f_nl,f_nb)
      muldata = fltarr(f_ns,f_nl,f_nb)
      for i_f_nb=0,f_nb-1 do begin
        temp = ENVI_GET_DATA(DIMS=[-1L,0,f_ns-1,0,(f_nl-1)],FID=AssFid,POS=i_f_nb)
        f_data[*,*,i_f_nb] = temp
        temp = ENVI_GET_DATA(DIMS=[-1L,0,f_ns-1,0,(f_nl-1)],FID=RefFid,POS=i_f_nb)
        muldata[*,*,i_f_nb] = temp
      endfor
      ;
      Basename = file_basename(FilenameAss[i_countimg],'.tif')
      OutFileName = OutputPath+Basename+'_SpecQua.txt'
      ;
      ENVI_REPORT_INIT,["Input File 1:"+FilenameAss[i_countimg],"Input File 2:"+FilenameRef[i_countimg],"Output File:"+OutFileName],$
        title="光谱质量",base=base,/interrupt
      ENVI_REPORT_INC,BASE,1
      Openw,lun,Outfilename,/get_lun
      printf,lun,'----------------------------------------------Spectral Quality---------------------------------------------'
      IF QuaArr[0] eq 'TRUE' THEN BEGIN
        printf,lun,'-----------------------Mean-----------------------------'
        ;IRS
        for i_m_nb=0,m_nb-1 do begin
          temp = muldata[*,*,i_m_nb]
          index_muldatagt0 = where(temp gt 0)
          irs_Mean = mean(temp[index_muldatagt0])
          temp = '   Band'+strtrim(string(i_m_nb+1),2)
          printf,lun,'Low spatial resolution image',temp,irs_mean
        endfor
        printf,lun,''
        ;Fusion
        for i_f_nb=0,f_nb-1 do begin
          temp = f_data[*,*,i_f_nb]
          index_f_datagt0 = where(temp gt 0)
          fusion_Mean = mean(temp[index_f_datagt0])
          temp = '   Band'+strtrim(string(i_f_nb+1),2)
          printf,lun,'Fusion image',temp,fusion_Mean
        endfor
        ENVI_REPORT_STAT,BASE,20,100
      ENDIF
      IF QuaArr[1] EQ 'TRUE' THEN BEGIN
        printf,lun,'-----------------------Standard Deviation-----------------------------'
        ;IRS
        for i_m_nb=0,m_nb-1 do begin
          temp = muldata[*,*,i_m_nb]
          index_muldatagt0 = where(temp gt 0)
          irs_Moment = Moment(temp[index_muldatagt0])
          irs_SD = SQRT(irs_Moment[1])
          temp='   Band'+strtrim(string(i_m_nb+1),2)
          printf,lun,'Low spatial resolution image',temp,irs_SD
        endfor
        printf,lun,''
        ;Fusion
        for i_f_nb=0,f_nb-1 do begin
          temp = f_data[*,*,i_f_nb]
          index_f_datagt0 = where(temp gt 0)
          fusion_Moment = Moment(temp[index_f_datagt0])
          fusion_SD = SQRT(fusion_Moment[1])
          temp='   Band'+strtrim(string(i_f_nb+1),2)
          printf,lun,'Fusion image',temp,fusion_SD
        endfor
        ENVI_REPORT_STAT,BASE,30,100
      ENDIF
      IF QuaArr[2] EQ 'TRUE' THEN BEGIN
        printf,lun,'-----------------------Spectral ERGAS-----------------------------';Quality of high resolution synthesised images is there a simple criterion
        H=30
        L=150
        MiArr = fltarr(m_nb)
        RMSEArr = fltarr(m_nb)
        for i_m_nb=0,m_nb-1 do begin
          MiArr[i_m_nb]=Mean(muldata[*,*,i_m_nb])
          RMSEArr[i_m_nb]=sqrt(total((muldata[*,*,i_m_nb]-f_data[*,*,i_m_nb])^2.0))/(m_ns*m_nl)
        endfor
        ERGAS = 100.0*H/L*SQRT(TOTAL(RMSEArr^2/MiArr^2)/M_NB)
        printf,lun,'ERGAS',ERGAS
        ENVI_REPORT_STAT,BASE,40,100
      ENDIF
      IF QuaArr[3] EQ 'TRUE' THEN BEGIN
        printf,lun,'-----------------------Spectral Distortion-----------------------------'
        ;;;;;Spectral Distortion
        ;Fusion
        for i_f_nb=0,f_nb-1 do begin
          tempf = f_data[*,*,i_f_nb]
          tempm = muldata[*,*,i_f_nb]
          distortion=mean(abs(tempf-tempm))
          temp='   Band'+strtrim(string(i_f_nb+1),2)
          printf,lun,'Spectral Distortion',temp,distortion
        endfor
        ENVI_REPORT_STAT,BASE,50,100
      ENDIF
      IF QuaArr[4] EQ 'TRUE' THEN BEGIN
        printf,lun,'-----------------------Spectral Angel Map-----------------------------'
        ;;;;;Spectral Angle Map
        ;Fusion
        vMuldata=reform(muldata,m_ns*m_nl,m_nb)
        vFdata=reform(f_data,m_ns*m_nl,m_nb)
        for i_f_nb=0,f_nb-1 do begin
          ;SAM = acos(total(vMuldata[*,i_f_nb]*vMuldata[*,i_f_nb])/(sqrt(total(vMuldata[*,i_f_nb]^2.0))*sqrt(total(vMuldata[*,i_f_nb]^2.0))))
          SAM = acos(total(vMuldata[*,i_f_nb]*vFdata[*,i_f_nb])/(sqrt(total(vMuldata[*,i_f_nb]^2.0))*sqrt(total(vFdata[*,i_f_nb]^2.0))))
          temp='   Band'+strtrim(string(i_f_nb+1),2)
          printf,lun,'Spectral Angel Map',temp,SAM
        endfor
        ENVI_REPORT_STAT,BASE,60,100
      ENDIF
      IF QuaArr[5] EQ 'TRUE' THEN BEGIN
        printf,lun,'-----------------------Correlate Coefficient with Low Spatial Resolution Image-----------------------------'
        ;;;;;Correlated Coefficient
        for i_f_nb=0,f_nb-1 do begin
          tempf = f_data[*,*,i_f_nb]
          tempm = muldata[*,*,i_f_nb]
          meanf = mean(tempf)
          meanm = mean(tempm)
          minus_f = tempf-meanf
          minus_m = tempm-meanm
          C = total(minus_f*minus_m)/sqrt(float(total(minus_f^2))*total(minus_m^2))
          temp='   Band'+strtrim(string(i_f_nb+1),2)
          printf,lun,'Correlate Coefficient',temp,C
        endfor
      ENDIF
      free_lun,lun
      ENVI_REPORT_STAT,BASE,100,100
      ENVI_REPORT_INIT,BASE=BASE,/FINISH
    endif else if QuaKind eq 'SpatQua' then begin
      ;
      ENVI_OPEN_FILE,FilenameAss[i_countimg],R_FID=AssFid
      ENVI_OPEN_FILE,FilenameRef[i_countimg],R_FID=RefFid
      ENVI_FILE_QUERY,RefFid,nb=h_nb,nl=h_nl,ns=h_ns
      ENVI_FILE_QUERY,AssFid,nb=f_nb,nl=f_nl,ns=f_ns
      f_data = fltarr(f_ns,f_nl,f_nb)
      h_redata = fltarr(f_ns,f_nl,f_nb)
      for i_f_nb=0,f_nb-1 do begin
        temp = ENVI_GET_DATA(DIMS=[-1L,0,f_ns-1,0,(f_nl-1)],FID=AssFid,POS=i_f_nb)
        f_data[*,*,i_f_nb] = temp
      endfor
      h_redata = fusion_function_getpandata(band,h_ns,h_nl,h_nb,RefFid)
      ;
      Basename = file_basename(FilenameAss[i_countimg],'.tif')
      OutFileName = OutputPath+Basename+'_SpatQua.txt'
      ;
      ENVI_REPORT_INIT,["Input File 1:"+FilenameAss[i_countimg],"Input File 2:"+FilenameRef[i_countimg],"Output File:"+OutFileName],$
        title="空间质量",base=base,/interrupt
      ENVI_REPORT_INC,BASE,1
      Openw,lun,Outfilename,/get_lun
      printf,lun,'----------------------------------------------Spatial Quality---------------------------------------------'
      if QuaArr[6] EQ 'TRUE' THEN BEGIN
        printf,lun,'-----------------------Mean-----------------------------'
        ;;;;;Mean
        ;CCD
        CCD_Mean = mean(h_redata)
        printf,lun,'High spatial image',CCD_Mean
        printf,lun,''
        ;Fusion
        for i_f_nb=0,f_nb-1 do begin
          temp = f_data[*,*,i_f_nb]
          index_f_datagt0 = where(temp gt 0)
          fusion_Mean = mean(temp[index_f_datagt0])
          temp='   Band'+strtrim(string(i_f_nb+1),2)
          printf,lun,'Fusion image',temp,fusion_Mean
        endfor
        ENVI_REPORT_STAT,BASE,10,100
      ENDIF
      IF QuaArr[7] eq 'TRUE' THEN BEGIN
        printf,lun,'-----------------------Standard Deviation-----------------------------'
        ;;;;;Standard Deviation
        ;CCD
        CCD_Moment = Moment(h_redata)
        CCD_SD = SQRT(CCD_Moment[1])
        printf,lun,'High spatial resolution image',CCD_SD
        printf,lun,''
        ;Fusion
        for i_f_nb=0,f_nb-1 do begin
          temp = f_data[*,*,i_f_nb]
          index_f_datagt0 = where(temp gt 0)
          fusion_Moment = Moment(temp[index_f_datagt0])
          fusion_SD = SQRT(fusion_Moment[1])
          temp='   Band'+strtrim(string(i_f_nb+1),2)
          printf,lun,'Fusion image',temp,fusion_SD
        endfor
        ENVI_REPORT_STAT,BASE,20,100
      ENDIF
      if QuaArr[8] EQ 'TRUE' THEN BEGIN
        printf,lun,'-----------------------Average Gradient-----------------------------'
        ;;;;;Aerage Gradient
        ;CCD
        G = 0.0
        for i_h_ns=0,h_ns-2 do begin
          for i_h_nl=0,h_nl-2 do begin
            G = G + SQRT(((float(h_redata[i_h_ns,i_h_nl])-h_redata[i_h_ns+1,i_h_nl])^2+$
              (float(h_redata[i_h_ns,i_h_nl])-h_redata[i_h_ns,i_h_nl+1])^2)/2.0)
          endfor
          p=(i_h_ns+1.0)/(h_ns-1)*100.*0.1
          ENVI_REPORT_STAT,BASE,30+p,100
        endfor
        G = G/(FLOAT(h_ns-1)*(h_nl-1))
        PRINTF,LUN,'High spatial resolution image',G
        printf,lun,''
        ;FUSION
        for i_f_nb=0,f_nb-1 do begin
          G=0.0
          temp = F_DATA[*,*,i_f_nb]
          for i_f_ns=0,f_ns-2 do begin
            for i_f_nl=0,f_nl-2 do begin
              G = G + SQRT(((temp[i_f_ns,i_f_nl]-temp[i_f_ns+1,i_f_nl])^2+$
                (temp[i_f_ns,i_f_nl]-temp[i_f_ns,i_f_nl+1])^2)/2.0)
            endfor
            p=(i_f_nb*(f_ns-1)+i_f_ns+1.0)/((f_ns-1)*f_nb)*100.*0.1
            ENVI_REPORT_STAT,BASE,60+p,100
          endfor
          G = G/(FLOAT(f_ns-1)*(f_nl-1))
          temp='   Band'+strtrim(string(i_f_nb+1),2)
          printf,lun,'Fusion image',temp,G
        endfor
      endif
      IF QuaArr[9] EQ 'TRUE' THEN BEGIN
        printf,lun,'-----------------------Correlate Coefficient with High Spatial Resolution Image-----------------------------'
        ;;;;;Correlated Coefficient with ccd
        for i_f_nb=0,f_nb-1 do begin
          if Kernel eq 'Sobel' then begin
            S_X=[[1,2,1],[0,0,0],[-1,-2,-1]]
            S_Y=[[1,0,-1],[2,0,-2],[1,0,-1]]
            H_fdataTemp = convol(f_data[*,*,i_f_nb],S_X)
            H_fdata = convol(H_fdataTemp,S_Y)
            H_HdataTemp = convol(h_redata,S_X)
            H_Hdata = convol(H_HdataTemp,S_Y)
          endif else if Kernel eq 'Robert' then begin
            ;Robert
            R_135=[[1,0],[0,-1]]
            R_45=[[0,1],[-1,0]]
            H_fdataTemp = convol(f_data[*,*,i_f_nb],R_135)
            H_fdata = convol(H_fdataTemp,R_45)
            H_HdataTemp = convol(h_redata,R_135)
            H_Hdata = convol(H_HdataTemp,R_45)
          endif else if Kernel eq 'Prewitt' then begin
            ;Prewitt
            P_X=[[-1,-1,-1],[0,0,0],[1,1,1]]
            P_Y=[[1,0,-1],[1,0,-1],[1,0,-1]]
            H_fdataTemp = convol(f_data[*,*,i_f_nb],P_X)
            H_fdata = convol(H_fdataTemp,P_Y)
            H_HdataTemp = convol(h_redata,P_X)
            H_Hdata = convol(H_HdataTemp,P_Y)
          endif else if Kernel eq 'Laplacian1' then begin
            ;Laplacian1
            L1=[[0,-1,0],[-1,4,-1],[0,-1,0]]
            H_fdata = convol(f_data[*,*,i_f_nb],L1)
            H_Hdata = convol(h_redata,L1)
          endif else if Kernel eq 'Laplacian2' then begin
            ;Laplacian2
            L2=[[-1,-1,-1],[-1,8,-1],[-1,-1,-1]]
            H_fdata = convol(f_data[*,*,i_f_nb],L2)
            H_Hdata = convol(h_redata,L2)
          endif else if Kernel eq 'Log' then begin
            ;Log
            Log=[[-2,-4,-4,-4,-2],$
              [-4,0,8,0,-4],$
              [-4,8,24,8,-4],$
              [-4,0,8,0,-4],$
              [-2,-4,-4,-4,-2]]
            H_fdata = convol(f_data[*,*,i_f_nb],Log)
            H_Hdata = convol(h_redata,Log)
          endif
          tempf = H_fdata
          tempm = H_Hdata
          meanf = mean(tempf)
          meanm = mean(tempm)
          minus_f = tempf-meanf
          minus_m = tempm-meanm
          C = total(minus_f*minus_m)/sqrt(float(total(minus_f^2))*total(minus_m^2))
          temp='   Band'+strtrim(string(i_f_nb+1),2)
          printf,lun,'Correlate Coefficient',temp,C
        endfor
        ENVI_REPORT_STAT,BASE,80,100
      ENDIF
      IF QuaArr[10] EQ 'TRUE' THEN BEGIN
        printf,lun,'-----------------------Spatial ERGAS-----------------------------';Quality of high resolution synthesised images is there a simple criterion
        H=30
        L=150
        MiArr = fltarr(f_nb)
        RMSEArr = fltarr(f_nb)
        for i_m_nb=0,f_nb-1 do begin
          MiArr[i_m_nb]=Mean(h_redata[*,*])
          RMSEArr[i_m_nb]=sqrt(total((h_redata[*,*]-f_data[*,*,i_m_nb])^2.0))/(f_ns*f_nl)
        endfor
      ENDIF
      ERGAS = 100.0*H/L*SQRT(TOTAL(RMSEArr^2/MiArr^2)/f_NB)
      printf,lun,'ERGAS',ERGAS
      free_lun,lun
      ENVI_REPORT_STAT,BASE,100,100
      ENVI_REPORT_INIT,BASE=BASE,/FINISH
    endif
  endfor 
  ENVI_BATCH_EXIT
  message=''
end

function fusion_function_getpandata,band,h_ns,h_nl,h_nb,h_fid
  ;Description：
  ;This function is used to get pan data which wil be used to sharpen the mul. image
  ;0-All bands, only used in GIHSA
  ;
  ;Calling method：
  ;fusion_function_getpandata,band,h_ns,h_nl,h_nb,h_fid
  ;
  ;band----0: all bands
  ;        1-4: 1-4 bands
  ;        5: sum of 4 bands
  ;        6: arithmetic average of 4 bands
  ;        7: geometric average of 4 bands
  ;        8: 0.25*b1+0.25*b2+0.16*b3+0.34*b4
  ;muldata----multispectal image
  ;fusiondata----fusion image
  ;Outfilename----Quality assessment file

  compile_opt idl2
  ENVI,/RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT
  
  if band ne 0 then begin
    h_redata = make_array(h_ns,h_nl)
    tempdata = make_array(h_ns,h_nl,h_nb)
  endif
  
  
  if band eq 0 then begin
    h_redata = make_array(h_ns,h_nl,h_nb)
    tempdata = make_array(h_ns,h_nl)
    for i_band=0,3 do begin
      tempdata = envi_get_data(DIMS=[-1L,0,h_ns-1,0,h_nl-1],FID=h_fid,POS=(i_band))
      h_redata[*,*,i_band]=tempdata
    endfor
  endif else if band le 4 and band gt 0 then begin
    h_redata = envi_get_data(DIMS=[-1L,0,h_ns-1,0,h_nl-1],FID=h_fid,POS=(band-1))
  endif else if band eq 5 then begin
    for i_h_nb=0,h_nb-1 do begin
      tempdata[*,*,i_h_nb] = envi_get_data(DIMS=[-1L,0,h_ns-1,0,h_nl-1],FID=h_fid,POS=(i_h_nb))
      h_redata = h_redata+tempdata[*,*,i_h_nb]
    endfor
  endif else if band eq 6 then begin
    for i_h_nb=0,h_nb-1 do begin
      tempdata[*,*,i_h_nb] = envi_get_data(DIMS=[-1L,0,h_ns-1,0,h_nl-1],FID=h_fid,POS=(i_h_nb))
      h_redata = h_redata+tempdata[*,*,i_h_nb]
    endfor
    h_redata = h_redata/float(h_nb)
  endif else if band eq 7 then begin
    for i_h_nb=0,h_nb-1 do begin
      tempdata[*,*,i_h_nb] = envi_get_data(DIMS=[-1L,0,h_ns-1,0,h_nl-1],FID=h_fid,POS=(i_h_nb))
      h_redata = h_redata+tempdata[*,*,i_h_nb]^2
    endfor
    h_redata = sqrt(float(h_redata))/h_nb
  endif else if band eq 8 then begin;HJ1A B:0.252 G:0.273 R:0.158 NIR:0.317
    temp_h_redata = make_array(h_ns,h_nl,h_nb)
    tempdata = make_array(h_ns,h_nl)
    for i_band=0,3 do begin
      tempdata = envi_get_data(DIMS=[-1L,0,h_ns-1,0,h_nl-1],FID=h_fid,POS=(i_band))
      temp_h_redata[*,*,i_band]=tempdata
    endfor
    h_redata = 0.252*temp_h_redata[*,*,0]+0.273*temp_h_redata[*,*,1]+$
      0.158*temp_h_redata[*,*,2]+0.317*temp_h_redata[*,*,3]
  endif else if band eq 9 then begin;HJ2A B:0.216 G:0.261 R:0.207 NIR:0.316
    temp_h_redata = make_array(h_ns,h_nl,h_nb)
    tempdata = make_array(h_ns,h_nl)
    for i_band=0,3 do begin
      tempdata = envi_get_data(DIMS=[-1L,0,h_ns-1,0,h_nl-1],FID=h_fid,POS=(i_band))
      temp_h_redata[*,*,i_band]=tempdata
    endfor
    h_redata = 0.216*temp_h_redata[*,*,0]+0.261*temp_h_redata[*,*,1]+$
      0.207*temp_h_redata[*,*,2]+0.316*temp_h_redata[*,*,3]
  ENDIF else if band eq 10 then begin;HJ1B B:0.265 G:0.240 R:0.178 NIR:0.317
    temp_h_redata = make_array(h_ns,h_nl,h_nb)
    tempdata = make_array(h_ns,h_nl)
    for i_band=0,3 do begin
      tempdata = envi_get_data(DIMS=[-1L,0,h_ns-1,0,h_nl-1],FID=h_fid,POS=(i_band))
      temp_h_redata[*,*,i_band]=tempdata
    endfor
    h_redata = 0.265*temp_h_redata[*,*,0]+0.240*temp_h_redata[*,*,1]+$
      0.178*temp_h_redata[*,*,2]+0.317*temp_h_redata[*,*,3]
  ENDIF else if band eq 11 then begin;HJ2B B:0.254 G:0.229 R:0.204 NIR:0.313
    temp_h_redata = make_array(h_ns,h_nl,h_nb)
    tempdata = make_array(h_ns,h_nl)
    for i_band=0,3 do begin
      tempdata = envi_get_data(DIMS=[-1L,0,h_ns-1,0,h_nl-1],FID=h_fid,POS=(i_band))
      temp_h_redata[*,*,i_band]=tempdata
    endfor
    h_redata = 0.254*temp_h_redata[*,*,0]+0.229*temp_h_redata[*,*,1]+$
      0.204*temp_h_redata[*,*,2]+0.313*temp_h_redata[*,*,3]
  ENDIF else if band eq 12 then begin;CCD四波段主成分
    h_redata = make_array(h_ns,h_nl)
    tempdata = make_array(h_ns,h_nl)
    tempdata2 = make_array(h_ns,h_nl,h_nb)
    for i_band=0,h_nb-1 do begin
      tempdata = envi_get_data(DIMS=[-1L,0,h_ns-1,0,h_nl-1],FID=h_fid,POS=(i_band))
      tempdata2[*,*,i_band]=tempdata
    endfor
    ;单位矩阵
    d=FLTARR(h_nb,h_nb)
    for k=0,h_nb-1  do begin
      d[k,k]=1
    endfor
    ;协方差矩阵
    covMatrix = fltarr(h_nb,h_nb)
    for i_nb=0,h_nb-1 do begin
      for j_nb=i_nb,h_nb-1 do begin
        X=reform(tempdata2[*,*,i_nb],h_ns*h_nl,1)
        Y=reform(tempdata2[*,*,j_nb],h_ns*h_nl,1)
        cova=correlate(X,Y,/covariance)
        covMatrix[i_nb,j_nb] = cova
        covMatrix[j_nb,i_nb] = cova
      endfor
    endfor
    ;求特征值和特征向量
    IMSL_GENEIG, covMatrix,d, alpha, beta , Vectors = vectors
    ;得到实部
    alpha_real = real_part(alpha)
    vectors_real = real_part(vectors)
    ;按特征值从大到小排序
    sort_index = REVERSE(sort(alpha_real))
    alpha_descend = alpha_real[sort_index]
    vectors_descend = vectors_real[*,sort_index]
    ;贡献率
    Contri = fltarr(h_nb)
    AccuContri = fltarr(h_nb)
    Accum = 0.0
    for i_nb=0,h_nb-1 do begin
      Contri[i_nb] = alpha_descend[i_nb]/total(abs(alpha_descend))
      Accum = Accum+Contri[i_nb]
      AccuContri[i_nb]=Accum
    endfor
    ;求第一主成分
    F_pc = tempdata2[*,*,0]*vectors_descend[0,0]+tempdata2[*,*,1]*vectors_descend[1,0]+$
      tempdata2[*,*,2]*vectors_descend[2,0]+tempdata2[*,*,3]*vectors_descend[3,0]
    h_redata=F_pc
  ENDIF else if band eq 13 then begin;由太阳光谱模拟
    temp_h_redata = make_array(h_ns,h_nl,h_nb)
    tempdata = make_array(h_ns,h_nl)
    for i_band=0,3 do begin
      tempdata = envi_get_data(DIMS=[-1L,0,h_ns-1,0,h_nl-1],FID=h_fid,POS=(i_band))
      temp_h_redata[*,*,i_band]=tempdata
    endfor
    h_redata = 0.39*temp_h_redata[*,*,0]+0.33*temp_h_redata[*,*,1]+$
      0.11*temp_h_redata[*,*,2]+0.17*temp_h_redata[*,*,3]
  endif
  return,h_redata
end