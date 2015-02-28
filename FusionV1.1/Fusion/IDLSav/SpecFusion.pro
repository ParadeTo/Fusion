pro SpecFusion,FilenameLow,FilenameHigh,OutputPath,Method,OutQuaFile,para,Message=Message
  ;����������
  ;�����ںϳ���������
  ;����˵��:
  ;FilenameLow----�Ϳռ�ֱ���Ӱ���ļ�������
  ;FilenameHigh----�߿ռ�ֱ���Ӱ���ļ�������
  ;OutputPath----Ӱ�����·��
  ;method----�ںϷ���
  ;Message----������Ϣ
  ;para----�ںϷ����Ĳ���
  ; para[0]----PBIM�����е�scale
  ; para[1]----HPF�����е�kernel
  ; para[2]----С���任�е�С����
  ; para[3]----С���任�еĸ�Ƶ�ںϷ���
  ; para[4]----С���任�еĵ�Ƶ�ںϷ���
  ; para[5]----С���任�еĲ���
  ;
  ;����
  ;    FilenameHigh = 'D:\Fusion\Data\HXFusion\CCD\�½��ļ���\'+['1-hj1b-ccd1-451-56-20110705.tif','2-hj1b-ccd1-447-56-20110805.tif']
  ;    filenamelow = 'D:\Fusion\Data\HXFusion\IRS\�½��ļ���\'+['1-hj1b-irs-454-56-20110705.tif','2-hj1b-irs-449-56-20110805.tif']
  ;    OutputPath = 'D:\'
  ;    method = 'Weighted Average'
  ;    para = ['5','Laplacian1','Haar','Replace','Replace','2']
  ;    OutQuaFile = 'true'


  compile_opt idl2
  ENVI,/RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT
  
  ;�߿ռ�ֱ���Ӱ��������ε�ƽ����ΪȫɫӰ��
  band = 6
  ;Ĭ�ϵĸ�ͨ�˲�����
  kernel_default = 'Laplacian1'
  
  if strmid(OutputPath,strlen(OutputPath)-1,1) ne '\' then begin
    OutputPath = OutputPath+'\'
  endif
  test_file = file_test(OutputPath,/directory)
  if test_file eq 0 then begin
    file_mkdir,OutputPath
  endif
  
  countlow = n_elements(FilenameLow)
  counthigh = n_elements(FilenameHigh)
  count = countlow<counthigh
  
  Str = '�ں���������...'
  ENVI_REPORT_INIT,Str,title="�����ں�",base=base,/interrupt
  ENVI_REPORT_INC,BASE,1
  Message = 'aaaa'
  for i_count=0,count-1 do begin
    ;����ļ�
    Outfilename = OutputPath+strmid(file_basename(FilenameLow[i_count]),0,strlen(file_basename(FilenameLow[i_count]))-4)+$
      '_'+method
    ;�����ںϷ���
    if method eq 'Brovey' then begin
      Message = fusion_method_brovey(FilenameHigh[i_count],FilenameLow[i_count],Outfilename,band,kernel_default,OutQuaFile)
    endif else if method eq 'FIHS' then begin
      Message = fusion_method_FIHS(FilenameHigh[i_count],FilenameLow[i_count],Outfilename,band,kernel_default,OutQuaFile)
    endif else if method eq 'GIHSA' then begin
      Message = fusion_method_gihsa(FilenameHigh[i_count],FilenameLow[i_count],Outfilename,band,kernel_default,OutQuaFile)
    endif else if method eq 'GS' then begin
      Message = fusion_Method_ENVI(FilenameHigh[i_count],FilenameLow[i_count],Outfilename,4,'GS',kernel_default,OutQuaFile)
    endif else if method eq 'PCA' then begin
      Message = fusion_Method_ENVI(FilenameHigh[i_count],FilenameLow[i_count],Outfilename,4,'PCA',kernel_default,OutQuaFile)
    endif else if method eq 'High Pass Filter' then begin
      Outfilename2=Outfilename+'_'+para[1]
      Message = fusion_method_HPF(FilenameHigh[i_count],FilenameLow[i_count],Outfilename2,band,para[1],OutQuaFile)
    endif else if method eq 'PBIM' then begin
      scale=fix(para[0])
      Message = fusion_method_PBIM(FilenameHigh[i_count],FilenameLow[i_count],Outfilename,band,kernel_default,scale,OutQuaFile)
    endif else if method eq 'SFIM' then begin
      Message = fusion_method_SFIM(FilenameHigh[i_count],FilenameLow[i_count],Outfilename,band,kernel_default,OutQuaFile)
    ENDIF else if method eq 'SVR' then begin
      Message = fusion_method_SVR(FilenameHigh[i_count],FilenameLow[i_count],Outfilename,band,kernel_default,OutQuaFile)
    endif else if method eq 'Weighted Average' then begin
      Message = fusion_method_wa(FilenameHigh[i_count],FilenameLow[i_count],Outfilename,band,kernel_default,OutQuaFile)
    endif else if method eq 'Wavelet Transform' then begin
      parawavelet=[para[2],para[3],para[4],'0',para[5]]
      Outfilename2=Outfilename+'_'+parawavelet[0]+'_'+parawavelet[1]+'_'+parawavelet[2]+'_'+ parawavelet[4]
      Message = fusion_method_simpwavelet(FilenameHigh[i_count],FilenameLow[i_count],Outfilename2,band,kernel_default,parawavelet,OutQuaFile)
    ENDif
    p=(i_count+1)*1.0/count*100.
    ENVI_REPORT_STAT,BASE,p,100.,cancel=cancelvar
  endfor
  ENVI_REPORT_INIT,base=base,/finish
  ENVI_BATCH_EXIT
end

function fusion_method_Brovey,filename1,filename2,filename3,band,kernel,OutQuaFile
  ;����:
  ;Brovey����
  ;
  ;����˵��:
  ;filename1----�߷ֱ���Ӱ���ļ���
  ;filename2----�����Ӱ���ļ���
  ;filename3----����ļ���
  ;band----�ĸ����λ����ǲ��������ΪȫɫӰ��
  ;kernel_default----��������ʱ����
  ;OutQuaFile----�Ƿ�������������ļ�

  compile_opt idl2
  ENVI,/RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT
  
  ;�򿪸߿ռ�ֱ���Ӱ��
  ENVI_OPEN_FILE,filename1,r_fid=h_fid
  if (h_fid eq -1) then begin
    envi_batch_exit
    return,'�޷��򿪸߿ռ�ֱ���Ӱ��'
  endif
  ;�õ��߿ռ�ֱ���Ӱ�����
  envi_file_query,h_fid,ns=h_ns,nl=h_nl,dims=h_dims,nb=h_nb
  ;�õ��߿ռ�ֱ���Ӱ������
  h_redata = fusion_function_getpandata(band,h_ns,h_nl,h_nb,h_fid)
  
  ;�򿪵Ϳռ�ֱ���Ӱ��
  ENVI_OPEN_FILE,filename2,r_fid=m_fid
  if (m_fid eq -1) then begin
    envi_batch_exit
    return,'�޷��򿪵Ϳռ�ֱ���Ӱ��'
  endif
  ;�õ��Ϳռ�ֱ���Ӱ�����
  envi_file_query,m_fid,ns=m_ns,nl=m_nl,dims=m_dims,nb=m_nb,data_type=m_type
  ;�õ��Ϳռ�ֱ���Ӱ������
  muldata = make_array(m_ns,m_nl,m_nb)
  for i_m_nb=0,m_nb-1 do begin
    temp = envi_get_data(DIMS=[-1L,0,m_ns-1,0,m_nl-1],FID=m_fid,POS=(i_m_nb))
    muldata[*,*,i_m_nb] = temp
  endfor
  mapinfo=ENVI_GET_MAP_INFO(fid=m_fid)
  
  ;�ںϺ�Ӱ������
  F_image=make_array(m_ns,m_nl,m_nb)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Brovey;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  SumArr = 0.0
  for i_m_nb=0,m_nb-1 do begin
    SumArr = SumArr + muldata[*,*,i_m_nb]
  endfor
  for i_m_nb=0,m_nb-1 do begin
    F_IMAGE[*,*,i_m_nb] = m_nb*muldata[*,*,i_m_nb]/(SumArr[*,*]+0.0000001)/3.*h_redata[*,*]
  endfor
  
  ;д�ļ�
  result = fusion_function_write_tiff(filename3,F_IMAGE,m_fid,m_ns,m_nl,m_nb,m_type)
  ;��������
  if OutQuaFile eq 'true' then begin
    Outfilename = (filename3)+'.txt'
    temp=fusion_function_quality(h_redata,muldata,F_IMAGE,Outfilename,kernel)
  endif
  ;�ͷſռ�
  f_image=!null
  return,''
END

function fusion_method_FIHS,filename1,filename2,filename3,band,kernel,OutQuaFile
  ;����:
  ;�㷨������� ���ؼ���������ң��ͼ���ںϷ����о���Ӧ��  by ҦΪ
  ;
  ;����˵��:
  ;filename1----�߷ֱ���Ӱ���ļ���
  ;filename2----�����Ӱ���ļ���
  ;filename3----����ļ���
  ;band----�ĸ����λ����ǲ��������ΪȫɫӰ��
  ;kernel----��������ʱ����
  ;OutQuaFile----�Ƿ�������������ļ�
  compile_opt idl2
  ENVI,/RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT
  ;�򿪸߿ռ�ֱ���Ӱ��
  ENVI_OPEN_FILE,filename1,r_fid=h_fid
  if (h_fid eq -1) then begin
    envi_batch_exit
    return,'�޷��򿪸߿ռ�ֱ���Ӱ��'
  endif
  ;�õ��߿ռ�ֱ���Ӱ�����
  envi_file_query,h_fid,ns=h_ns,nl=h_nl,dims=h_dims,nb=h_nb
  ;�õ��߿ռ�ֱ���Ӱ������
  h_redata = fusion_function_getpandata(band,h_ns,h_nl,h_nb,h_fid)
  
  ;�򿪵Ϳռ�ֱ���Ӱ��
  ENVI_OPEN_FILE,filename2,r_fid=m_fid
  if (m_fid eq -1) then begin
    envi_batch_exit
    return,'�޷��򿪵Ϳռ�ֱ���Ӱ��'
  endif
  ;�õ��Ϳռ�ֱ���Ӱ�����
  envi_file_query,m_fid,ns=m_ns,nl=m_nl,dims=m_dims,nb=m_nb,data_type=m_type
  ;�õ��Ϳռ�ֱ���Ӱ������
  muldata = make_array(m_ns,m_nl,m_nb)
  for i_m_nb=0,m_nb-1 do begin
    temp = envi_get_data(DIMS=[-1L,0,m_ns-1,0,m_nl-1],FID=m_fid,POS=(i_m_nb))
    muldata[*,*,i_m_nb] = temp
  endfor
  mapinfo=ENVI_GET_MAP_INFO(fid=m_fid)
  
  ;�ںϺ�Ӱ������
  F_image=make_array(m_ns,m_nl,m_nb)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;FIHS;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;����
  Idata=FLTARR(m_ns,m_nl)
  for i_ns=0,m_ns-1 do begin
    for i_nl=0,m_nl-1 do begin
      Idata[i_ns,i_nl] = MEAN(muldata[i_ns,i_nl,*])
    endfor
  endfor
  ;ϸ��
  Ddata = h_redata-Idata
  ;�����ںϺ�Ӱ������
  for i_m_nb=0,m_nb-1 do begin
    F_image[*,*,i_m_nb] = muldata[*,*,i_m_nb]+Ddata[*,*]
  endfor
  
  ;д�ļ�
  result = fusion_function_write_tiff(filename3,F_IMAGE,m_fid,m_ns,m_nl,m_nb,m_type)
  ;��������
  if OutQuaFile eq 'true' then begin
    Outfilename = (filename3)+'.txt'
    temp=fusion_function_quality(h_redata,muldata,F_IMAGE,Outfilename,kernel)
  endif
  f_image=!null
  return,''
END

function fusion_method_GIHSA,filename1,filename2,filename3,band,kernel,OutQuaFile
  ;����:
  ;�㷨��� Improving component substitution pansharpening through multivariate regression of MS+Pan data
  ;
  ;����˵��:
  ;filename1----�߷ֱ���Ӱ���ļ���
  ;filename2----�����Ӱ���ļ���
  ;filename3----����ļ���
  ;band----�ĸ����λ����ǲ��������ΪȫɫӰ��
  ;kernel_default----��������ʱ����
  ;OutQuaFile----�Ƿ�������������ļ�
  compile_opt idl2
  ENVI,/RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT
  ;�򿪸߿ռ�ֱ���Ӱ��
  ENVI_OPEN_FILE,filename1,r_fid=h_fid
  if (h_fid eq -1) then begin
    envi_batch_exit
    return,'�޷��򿪸߿ռ�ֱ���Ӱ��'
  endif
  ;�õ��߿ռ�ֱ���Ӱ�����
  envi_file_query,h_fid,ns=h_ns,nl=h_nl,dims=h_dims,nb=h_nb
  ;�õ��߿ռ�ֱ���Ӱ������
  h_redata = fusion_function_getpandata(band,h_ns,h_nl,h_nb,h_fid)
  
  ;�򿪵Ϳռ�ֱ���Ӱ��
  ENVI_OPEN_FILE,filename2,r_fid=m_fid
  if (m_fid eq -1) then begin
    envi_batch_exit
    return,'�޷��򿪵Ϳռ�ֱ���Ӱ��'
  endif
  ;�õ��Ϳռ�ֱ���Ӱ�����
  envi_file_query,m_fid,ns=m_ns,nl=m_nl,dims=m_dims,nb=m_nb,data_type=m_type
  ;�õ��Ϳռ�ֱ���Ӱ������
  muldata = make_array(m_ns,m_nl,m_nb)
  for i_m_nb=0,m_nb-1 do begin
    temp = envi_get_data(DIMS=[-1L,0,m_ns-1,0,m_nl-1],FID=m_fid,POS=(i_m_nb))
    muldata[*,*,i_m_nb] = temp
  endfor
  mapinfo=ENVI_GET_MAP_INFO(fid=m_fid)
  
  ;�ںϺ�Ӱ������
  F_image=make_array(m_ns,m_nl,m_nb)
  
  ;ȫɫӰ������
  Sim_Pan = h_redata
  v_Sim_Pan = reform(sim_pan,h_ns*h_nl,1)
  ;�����Ӱ������
  v_Mul = reform(muldata,M_NB,m_ns*m_nl)
  ;�ع������任ϵ��
  result = REGRESS(v_Mul, v_Sim_Pan, SIGMA=sigma, CONST=const,FTEST=ftest,CHISQ=chisq, $
    MEASURE_ERRORS=measure_errors)
  ;�����Ӱ��ģ������
  I = result[0]*muldata[*,*,0]+result[1]*muldata[*,*,1]+const
  v_I = reform(I,1,m_ns*m_nl)
  ;ϸ��
  V_Det = v_Sim_Pan-I
  Det = reform(V_Det,m_ns,m_nl)
  g=make_array(m_nb)
  ;������任ϵ��
  for i_m_nb=0,m_nb-1 do begin
    temp_v_i=reform(V_I,m_ns*m_nl,1)
    result=moment(temp_v_i)
    g[i_m_nb]=C_CORRELATE(v_Mul[i_m_nb,*], V_I, 0 , /COVARIANCE, /DOUBLE)/result[1]
  endfor
  ;�����ںϺ�Ӱ��ϵ��
  for i_m_nb=0,m_nb-1 do begin
    F_image[*,*,i_m_nb] = muldata[*,*,i_m_nb]+g[i_m_nb]*Det
  endfor
  ;д�ļ�
  result = fusion_function_write_tiff(filename3,F_IMAGE,m_fid,m_ns,m_nl,m_nb,m_type)
  ;��������
  if OutQuaFile eq 'true' then begin
    Outfilename = (filename3)+'.txt'
    temp=fusion_function_quality(h_redata,muldata,F_IMAGE,Outfilename,kernel)
  endif
  ;�ͷſռ�
  f_image=!null
  return,''
END


function fusion_Method_ENVI,filename1,filename2,filename3,band,method,kernel,OutQuaFile
  ;Description��
  ;ENVI�Դ����ں��㷨
  ;
  ;����������
  ;filename1----�߷ֱ���Ӱ���ļ���
  ;filename2----�����Ӱ���ļ���
  ;filename3----����ļ���
  ;band----�ĸ����λ����ǲ��������ΪȫɫӰ��
  ;method----�ںϷ���pca����gs
  ;kernel----��������ʱ����
  ;OutQuaFile----�Ƿ�������������ļ�
  compile_opt idl2
  ENVI,/RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT
  ;�򿪸߿ռ�ֱ���Ӱ��
  ENVI_OPEN_FILE,filename1,r_fid=h_fid
  if (h_fid eq -1) then begin
    envi_batch_exit
    return,'�޷��򿪸߿ռ�ֱ���Ӱ��'
  endif
  ;�õ��߿ռ�ֱ���Ӱ�����
  envi_file_query,h_fid,ns=h_ns,nl=h_nl,dims=h_dims,nb=h_nb
  ;�õ��߿ռ�ֱ���Ӱ������
  h_redata = fusion_function_getpandata(band,h_ns,h_nl,h_nb,h_fid)
  
  ;�򿪵Ϳռ�ֱ���Ӱ��
  ENVI_OPEN_FILE,filename2,r_fid=m_fid
  if (m_fid eq -1) then begin
    envi_batch_exit
    return,'�޷��򿪵Ϳռ�ֱ���Ӱ��'
  endif
  ;�õ��Ϳռ�ֱ���Ӱ�����
  envi_file_query,m_fid,ns=m_ns,nl=m_nl,dims=m_dims,nb=m_nb
  ;�õ��Ϳռ�ֱ���Ӱ������
  muldata = make_array(m_ns,m_nl,m_nb)
  for i_m_nb=0,m_nb-1 do begin
    temp = envi_get_data(DIMS=[-1L,0,m_ns-1,0,m_nl-1],FID=m_fid,POS=(i_m_nb))
    muldata[*,*,i_m_nb] = temp
  endfor
  mapinfo=ENVI_GET_MAP_INFO(fid=m_fid)
  
  case method of
    'GS':Begin
    out_bname = 'GS_Sharpen_band_'+STRTRIM(LINDGEN(m_nb),2)
    ENVI_DOIT,'ENVI_GS_SHARPEN_DOIT',$
      DIMS= m_dims, $
      fID = m_fid, $
      HIRES_DIMS = h_dims, $
      HIRES_FID = h_fid,$
      HIRES_POS = band-1,$;The band of h-re image used to fuse
      LORES_POS = LINDGEN(m_nb),$
      INTERP = 2,$
      OUT_NAME = filename3,$
      POS =LINDGEN(m_nb)
  END
  'PCA':Begin
  out_bname = 'PC_Sharpen_band_'+STRTRIM(LINDGEN(m_nb),2)
  ENVI_DOIT,'ENVI_PC_SHARPEN_DOIT',$
    DIMS= m_dims, $
    fID = m_fid, $
    HIRES_DIMS = h_dims, $
    HIRES_FID = h_fid,$
    HIRES_POS = band-1,$;The band of h-re image used to fuse
    LORES_POS = LINDGEN(m_nb),$
    INTERP = 2,$
    OUT_BNAME = out_bname , $
    OUT_NAME = filename3,$
    POS =LINDGEN(m_nb)
end
endcase

ENVI_OPEN_FILE,filename3,r_fid=outFid
ENVI_FILE_QUERY,outFid,ns=ns,nl=nl,nb=nb,dims=dims
ENVI_OUTPUT_TO_EXTERNAL_FORMAT,fid=outFid,dims=dims,pos=INDGEN(nb),$
  out_name=filename3+'.tif',/TIFF
f_image = make_array(m_ns,m_nl,m_nb)
for i_m_nb=0,m_nb-1 do begin
  temp = envi_get_data(DIMS=[-1L,0,m_ns-1,0,m_nl-1],FID=outfid,POS=(i_m_nb))
  f_image[*,*,i_m_nb] = temp
endfor
;��������
if OutQuaFile eq 'true' then begin
  Outfilename = (filename3)+'.txt'
  temp=fusion_function_quality(h_redata,muldata,F_IMAGE,Outfilename,kernel)
endif
;�ͷſռ�
f_image=!null
return,''
end

function fusion_method_HPF,filename1,filename2,filename3,band,kernel,OutQuaFile
  ;����:
  ;��ͨ�˲��ںϷ�
  ;
  ;����˵��:
  ;filename1----�߷ֱ���Ӱ���ļ���
  ;filename2----�����Ӱ���ļ���
  ;filename3----����ļ���
  ;band----�ĸ����λ����ǲ��������ΪȫɫӰ��
  ;kernel----��������ʱ����
  ;OutQuaFile----�Ƿ�������������ļ�
  compile_opt idl2
  ENVI,/RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT
  ;�򿪸߿ռ�ֱ���Ӱ��
  ENVI_OPEN_FILE,filename1,r_fid=h_fid
  if (h_fid eq -1) then begin
    envi_batch_exit
    return,'�޷��򿪸߿ռ�ֱ���Ӱ��'
  endif
  ;�õ��߿ռ�ֱ���Ӱ�����
  envi_file_query,h_fid,ns=h_ns,nl=h_nl,dims=h_dims,nb=h_nb
  ;�õ��߿ռ�ֱ���Ӱ������
  h_redata = fusion_function_getpandata(band,h_ns,h_nl,h_nb,h_fid)
  
  ;�򿪵Ϳռ�ֱ���Ӱ��
  ENVI_OPEN_FILE,filename2,r_fid=m_fid
  if (m_fid eq -1) then begin
    envi_batch_exit
    return,'�޷��򿪵Ϳռ�ֱ���Ӱ��'
  endif
  ;�õ��Ϳռ�ֱ���Ӱ�����
  envi_file_query,m_fid,ns=m_ns,nl=m_nl,dims=m_dims,nb=m_nb,data_type=m_type
  ;�õ��Ϳռ�ֱ���Ӱ������
  muldata = make_array(m_ns,m_nl,m_nb)
  for i_m_nb=0,m_nb-1 do begin
    temp = envi_get_data(DIMS=[-1L,0,m_ns-1,0,m_nl-1],FID=m_fid,POS=(i_m_nb))
    muldata[*,*,i_m_nb] = temp
  endfor
  mapinfo=ENVI_GET_MAP_INFO(fid=m_fid)
  
  ;�ںϺ�Ӱ������
  F_image=make_array(m_ns,m_nl,m_nb)
  
  ;;;;;;;;;;;;;Derive Edge of Pan. image;;;;;;;;;;;;;;;;;;;;
  ;��ȡ��Ե
  EdgeData = fusion_function_edge(h_redata,Kernel)
  ;����Ե�ӵ��ں�Ӱ����
  for i_m_nb=0,m_nb-1 do begin
    F_image[*,*,i_m_nb] = MULDATA[*,*,i_m_nb]+EdgeData
  endfor
  
  ;д�ļ�
  result = fusion_function_write_tiff(filename3,F_IMAGE,m_fid,m_ns,m_nl,m_nb,m_type)
  
  ;��������
  if OutQuaFile eq 'true' then begin
    Outfilename = (filename3)+'.txt'
    temp=fusion_function_quality(h_redata,muldata,F_IMAGE,Outfilename,kernel)
  endif
  ;�ͷſռ�
  f_image=!null
  return,''
END


function fusion_method_PBIM,filename1,filename2,filename3,BAND,KERNEL,scale,OutQuaFile
  ;����:
  ;������£� Pixel block intensity modulation: Adding spatial detail to TM band 6 thermal imagery
  ;
  ;����˵����
  ;filename1----�߷ֱ���Ӱ���ļ���
  ;filename2----�����Ӱ���ļ���
  ;filename3----����ļ���
  ;band----�ĸ����λ����ǲ��������ΪȫɫӰ��
  ;kernel----��������ʱ����
  ;scale----�͸߷ֱ��ʱ���
  ;OutQuaFile----�Ƿ�������������ļ�
  compile_opt idl2
  ENVI,/RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT
  ;�򿪸߿ռ�ֱ���Ӱ��
  ENVI_OPEN_FILE,filename1,r_fid=h_fid
  if (h_fid eq -1) then begin
    envi_batch_exit
    return,'�޷��򿪸߿ռ�ֱ���Ӱ��'
  endif
  ;�õ��߿ռ�ֱ���Ӱ�����
  envi_file_query,h_fid,ns=h_ns,nl=h_nl,dims=h_dims,nb=h_nb
  ;�õ��߿ռ�ֱ���Ӱ������
  h_redata = fusion_function_getpandata(band,h_ns,h_nl,h_nb,h_fid)
  
  ;�򿪵Ϳռ�ֱ���Ӱ��
  ENVI_OPEN_FILE,filename2,r_fid=m_fid
  if (m_fid eq -1) then begin
    return,'�޷��򿪵Ϳռ�ֱ���Ӱ��'
  endif
  ;�õ��Ϳռ�ֱ���Ӱ�����
  envi_file_query,m_fid,ns=m_ns,nl=m_nl,dims=m_dims,nb=m_nb,data_type=m_type
  ;�õ��Ϳռ�ֱ���Ӱ������
  muldata = make_array(m_ns,m_nl,m_nb)
  for i_m_nb=0,m_nb-1 do begin
    temp = envi_get_data(DIMS=[-1L,0,m_ns-1,0,m_nl-1],FID=m_fid,POS=(i_m_nb))
    muldata[*,*,i_m_nb] = temp
  endfor
  mapinfo=ENVI_GET_MAP_INFO(fid=m_fid)
  
  ;�ںϺ�Ӱ������
  F_image=make_array(m_ns,m_nl,m_nb)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PBIM in (7) of the paper;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ENVI_REPORT_INIT,["Input File 1:"+filename1,"Input File 2:"+filename2,"Output File:"+filename3],$
    title="PBIM",base=base,/interrupt
  ENVI_REPORT_INC,BASE,1
  Mom = moment(h_redata)
  Std = sqrt(Mom[1])
  Cr = 0
  for i_m_nb=0,m_nb-1 do begin
    for i_m_ns=0,m_ns-1 do begin
      for i_m_nl=0,m_nl-1 do begin
        ;5*5 window
        i_ns_irs=i_m_ns/scale
        i_nl_irs=i_m_nl/scale
        ns1=i_ns_irs*scale
        ns2=(i_ns_irs*scale+4<m_ns-1)
        nl1=i_nl_irs*scale
        nl2=(i_nl_irs*scale+4<m_nl-1)
        
        ;Calculate the LC
        r_moment = moment(h_redata[ns1:ns2,nl1:nl2])
        LC = sqrt(r_moment[1])
        
        ;Calculate the local mean
        LM = mean(h_redata[ns1:ns2,nl1:nl2])
        if LC gt cr then begin
          ;Calculate TMPmb
          Temp = h_redata[ns1:ns2,nl1:nl2]
          index = where(Temp gt LM)
          TMPmb = mean(Temp[index])
          ;Calculate TMPmd
          Temp = h_redata[ns1:ns2,nl1:nl2]
          index = where(Temp le LM)
          TMPmd = mean(Temp[index])
          if h_redata[i_m_ns,i_m_nl] gt Lm then begin
            F_image[i_m_ns,i_m_nl,i_m_nb] = muldata[i_m_ns,i_m_nl,i_m_nb]*h_redata[i_m_ns,i_m_nl]/TMPmb
          endif else begin
            F_image[i_m_ns,i_m_nl,i_m_nb] = muldata[i_m_ns,i_m_nl,i_m_nb]*h_redata[i_m_ns,i_m_nl]/TMPmd
          endelse
        endif else begin
          F_image[i_m_ns,i_m_nl,i_m_nb] = muldata[i_m_ns,i_m_nl,i_m_nb]*h_redata[i_m_ns,i_m_nl]/LM
        endelse
      endfor
      p=(i_m_nb*(m_ns)+i_m_ns+1.0)/(m_ns*m_nb)*100.
      ENVI_REPORT_STAT,BASE,p,100
    endfor
  endfor
  ENVI_REPORT_INIT,BASE=BASE,/FINISH
  ;д�ļ�
  result = fusion_function_write_tiff(filename3,F_IMAGE,m_fid,m_ns,m_nl,m_nb,m_type)
  ;��������
  if OutQuaFile eq 'true' then begin
    Outfilename = (filename3)+'.txt'
    temp=fusion_function_quality(h_redata,muldata,F_IMAGE,Outfilename,kernel)
  endif
  ;�ͷſռ�
  f_image=!null
  return,''
END

function fusion_method_SFIM,filename1,filename2,filename3,band,kernel,OutQuaFile
  ;����:
  ;Detail in "���ָ߱���ң��Ӱ���ںϷ����Ƚ�"
  ;
  ;
  ;����˵����
  ;filename1----�߷ֱ���Ӱ���ļ���
  ;filename2----�����Ӱ���ļ���
  ;filename3----����ļ���
  ;band----�ĸ����λ����ǲ��������ΪȫɫӰ��
  ;kernel----��������ʱ����
  ;OutQuaFile----�Ƿ�������������ļ�
  compile_opt idl2
  ENVI,/RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT
  ;�򿪸߿ռ�ֱ���Ӱ��
  ENVI_OPEN_FILE,filename1,r_fid=h_fid
  if (h_fid eq -1) then begin
    return,'�޷��򿪸߿ռ�ֱ���Ӱ��'
  endif
  ;�õ��߿ռ�ֱ���Ӱ�����
  envi_file_query,h_fid,ns=h_ns,nl=h_nl,dims=h_dims,nb=h_nb
  ;�õ��߿ռ�ֱ���Ӱ������
  h_redata = fusion_function_getpandata(band,h_ns,h_nl,h_nb,h_fid)
  
  ;�򿪵Ϳռ�ֱ���Ӱ��
  ENVI_OPEN_FILE,filename2,r_fid=m_fid
  if (m_fid eq -1) then begin
    envi_batch_exit
    return,'�޷��򿪵Ϳռ�ֱ���Ӱ��'
  endif
  ;�õ��Ϳռ�ֱ���Ӱ�����
  envi_file_query,m_fid,ns=m_ns,nl=m_nl,dims=m_dims,nb=m_nb,data_type=m_type
  ;�õ��Ϳռ�ֱ���Ӱ������
  muldata = make_array(m_ns,m_nl,m_nb)
  for i_m_nb=0,m_nb-1 do begin
    temp = envi_get_data(DIMS=[-1L,0,m_ns-1,0,m_nl-1],FID=m_fid,POS=(i_m_nb))
    muldata[*,*,i_m_nb] = temp
  endfor
  mapinfo=ENVI_GET_MAP_INFO(fid=m_fid)
  
  ;�ںϺ�Ӱ������
  F_image=make_array(m_ns,m_nl,m_nb)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;SFIM;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;ƽ���˲���
  AF = [[1/9.,1/9.,1/9.],[1/9.,1/9.,1/9.],[1/9.,1/9.,1/9.]]
  ;����ʽ�е� DNmean
  h_redata_sti_low=convol(float(h_redata),AF)
  h_redata_sti_low[0,0]=h_redata_sti_low[1,1]
  h_redata_sti_low[h_ns-1,0]=h_redata_sti_low[h_ns-2,1]
  h_redata_sti_low[h_ns-1,h_nl-1]=h_redata_sti_low[h_ns-2,h_nl-2]
  h_redata_sti_low[0,h_nl-1]=h_redata_sti_low[1,h_nl-2]
  h_redata_sti_low[1:h_ns-2,0]=h_redata_sti_low[1:h_ns-2,1]
  h_redata_sti_low[1:h_ns-2,h_nl-1]=h_redata_sti_low[1:h_ns-2,h_nl-2]
  h_redata_sti_low[0,1:h_nl-2]= h_redata_sti_low[1,1:h_nl-2]
  h_redata_sti_low[h_ns-1,1:h_nl-2]= h_redata_sti_low[h_ns-2,1:h_nl-2]
  ;�����ںϺ�Ӱ������
  for i_m_nb=0,m_nb-1 do begin
    F_image[*,*,i_m_nb] = float(muldata[*,*,i_m_nb])*h_redata/h_redata_sti_low
  endfor
  
  ;д�ļ�
  result = fusion_function_write_tiff(filename3,F_IMAGE,m_fid,m_ns,m_nl,m_nb,m_type)
  ;��������
  if OutQuaFile eq 'true' then begin
    Outfilename = (filename3)+'.txt'
    temp=fusion_function_quality(h_redata,muldata,F_IMAGE,Outfilename,kernel)
  endif
  ;�ͷſռ�
  f_image=!null
  return,''
END

function fusion_method_SVR,filename1,filename2,filename3,band,KERNEL,OutQuaFile
  ;����:
  ;�㷨��� A new merging method and its spectral and spatial effects by Y. Zhang
  ;
  ;����˵����
  ;filename1----�߷ֱ���Ӱ���ļ���
  ;filename2----�����Ӱ���ļ���
  ;filename3----����ļ���
  ;band----�ĸ����λ����ǲ��������ΪȫɫӰ��
  ;OutQuaFile----�Ƿ�������������ļ�
  compile_opt idl2
  ENVI,/RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT
  ;�򿪸߿ռ�ֱ���Ӱ��
  ENVI_OPEN_FILE,filename1,r_fid=h_fid
  if (h_fid eq -1) then begin
    ENVI_BATCH_EXIT
    return,'�޷��򿪸߿ռ�ֱ���Ӱ��'
  endif
  ;�õ��߿ռ�ֱ���Ӱ�����
  envi_file_query,h_fid,ns=h_ns,nl=h_nl,dims=h_dims,nb=h_nb
  ;�õ��߿ռ�ֱ���Ӱ������
  h_redata = fusion_function_getpandata(band,h_ns,h_nl,h_nb,h_fid)
  
  ;�򿪵Ϳռ�ֱ���Ӱ��
  ENVI_OPEN_FILE,filename2,r_fid=m_fid
  if (m_fid eq -1) then begin
    envi_batch_exit
    return,'�޷��򿪵Ϳռ�ֱ���Ӱ��'
  endif
  ;�õ��Ϳռ�ֱ���Ӱ�����
  envi_file_query,m_fid,ns=m_ns,nl=m_nl,dims=m_dims,nb=m_nb,data_type=m_type
  ;�õ��Ϳռ�ֱ���Ӱ������
  muldata = make_array(m_ns,m_nl,m_nb)
  for i_m_nb=0,m_nb-1 do begin
    temp = envi_get_data(DIMS=[-1L,0,m_ns-1,0,m_nl-1],FID=m_fid,POS=(i_m_nb))
    muldata[*,*,i_m_nb] = temp
  endfor
  mapinfo=ENVI_GET_MAP_INFO(fid=m_fid)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;SVR;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  F_image=make_array(m_ns,m_nl,m_nb)
  X=reform(muldata,m_ns*m_nl,m_nb)
  Y=reform(h_redata,1,m_ns*m_nl)
  regress_result=regress(transpose(X),transpose(Y),SIGMA=sigma, CONST=const,MEASURE_ERRORS=measure_errors)
  sti_h_redata = muldata[*,*,0]*regress_result[0]+muldata[*,*,1]*regress_result[1]+const
  for i_m_nb=0,m_nb-1 do begin
    F_image[*,*,i_m_nb]=h_redata/sti_h_redata*muldata[*,*,i_m_nb]
  endfor
  
  ;д�ļ�
  result = fusion_function_write_tiff(filename3,F_IMAGE,m_fid,m_ns,m_nl,m_nb,m_type)
  ;��������
  if OutQuaFile eq 'true' then begin
    Outfilename = (filename3)+'.txt'
    temp=fusion_function_quality(h_redata,muldata,F_IMAGE,Outfilename,kernel)
  endif
  ;�ͷſռ�
  f_image=!null
  return,''
END

function fusion_method_WA,filename1,filename2,filename3,band,kernel,OutQuaFile
  ;Description:
  ;��Ȩƽ���㷨
  ;
  ;����˵����
  ;filename1----�߷ֱ���Ӱ���ļ���
  ;filename2----�����Ӱ���ļ���
  ;filename3----����ļ���
  ;band----�ĸ����λ����ǲ��������ΪȫɫӰ��
  ;kernel----��������ʱ����

  compile_opt idl2
  ENVI,/RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT
  ;�򿪸߿ռ�ֱ���Ӱ��
  ENVI_OPEN_FILE,filename1,r_fid=h_fid
  if (h_fid eq -1) then begin
    ENVI_BATCH_EXIT
    return,'�޷��򿪸߿ռ�ֱ���Ӱ��'
  endif
  ;�õ��߿ռ�ֱ���Ӱ�����
  envi_file_query,h_fid,ns=h_ns,nl=h_nl,dims=h_dims,nb=h_nb
  ;�õ��߿ռ�ֱ���Ӱ������
  h_redata = fusion_function_getpandata(band,h_ns,h_nl,h_nb,h_fid)
  
  ;�򿪵Ϳռ�ֱ���Ӱ��
  ENVI_OPEN_FILE,filename2,r_fid=m_fid
  if (m_fid eq -1) then begin
    envi_batch_exit
    return,'�޷��򿪵Ϳռ�ֱ���Ӱ��'
  endif
  ;�õ��Ϳռ�ֱ���Ӱ�����
  envi_file_query,m_fid,ns=m_ns,nl=m_nl,dims=m_dims,nb=m_nb,data_type=m_type
  ;�õ��Ϳռ�ֱ���Ӱ������
  muldata = make_array(m_ns,m_nl,m_nb)
  for i_m_nb=0,m_nb-1 do begin
    temp = envi_get_data(DIMS=[-1L,0,m_ns-1,0,m_nl-1],FID=m_fid,POS=(i_m_nb))
    muldata[*,*,i_m_nb] = temp
  endfor
  mapinfo=ENVI_GET_MAP_INFO(fid=m_fid)
  
  ;�ںϺ�Ӱ��
  F_image=make_array(m_ns,m_nl,m_nb)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;��Ȩƽ��;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  for i_m_nb=0,m_nb-1 do begin
    F_image[*,*,i_m_nb] = (h_redata[*,*]+muldata[*,*,i_m_nb])/2.0
  endfor
  
  ;д�ļ�
  result = fusion_function_write_tiff(filename3,F_IMAGE,m_fid,m_ns,m_nl,m_nb,m_type)
  ;��������
  if OutQuaFile eq 'true' then begin
    Outfilename = (filename3)+'.txt'
    temp=fusion_function_quality(h_redata,muldata,F_IMAGE,Outfilename,kernel)
  endif
  ;�ͷſռ�
  f_image=!null
  return,''
END

function fusion_method_simpwavelet,filename1,filename2,filename3,band,KERNEL,para,OutQuaFile
  ;������
  ;С���任�ںϷ�
  ;
  ;����˵����
  ;filename1----�߷ֱ���Ӱ���ļ���
  ;filename2----�����Ӱ���ļ���
  ;filename3----����ļ���
  ;band----�ĸ����λ����ǲ��������ΪȫɫӰ��
  ;kernel----��������ʱ����
  ;para----С���ںϲ���

  compile_opt idl2
  ENVI,/RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT
  
  ;С���任�ںϲ���
  basis=para[0]
  highrule=para[1]
  lowrule=para[2]
  ChiImg=fix(para[3])
  n_lev=fix(para[4])
  
  ;�򿪸߿ռ�ֱ���Ӱ��
  ENVI_OPEN_FILE,filename1,r_fid=h_fid
  if (h_fid eq -1) then begin
    ENVI_BATCH_EXIT
    return,'�޷��򿪸߿ռ�ֱ���Ӱ��'
  endif
  ;�õ��߿ռ�ֱ���Ӱ�����
  envi_file_query,h_fid,ns=h_ns,nl=h_nl,dims=h_dims,nb=h_nb
  ;�õ��߿ռ�ֱ���Ӱ������
  h_redata = fusion_function_getpandata(band,h_ns,h_nl,h_nb,h_fid)
  
  ;�򿪵Ϳռ�ֱ���Ӱ��
  ENVI_OPEN_FILE,filename2,r_fid=m_fid
  if (m_fid eq -1) then begin
    return,'�޷��򿪵Ϳռ�ֱ���Ӱ��'
  endif
  ;�õ��Ϳռ�ֱ���Ӱ�����
  envi_file_query,m_fid,ns=m_ns,nl=m_nl,dims=m_dims,nb=m_nb,data_type=m_type
  ;�õ��Ϳռ�ֱ���Ӱ������
  muldata = make_array(m_ns,m_nl,m_nb)
  for i_m_nb=0,m_nb-1 do begin
    temp = envi_get_data(DIMS=[-1L,0,m_ns-1,0,m_nl-1],FID=m_fid,POS=(i_m_nb))
    muldata[*,*,i_m_nb] = temp
  endfor
  mapinfo=ENVI_GET_MAP_INFO(fid=m_fid)
  
  ;�����ݴ�С����Ϊ2�ı���
  ns_pow = FLOOR((ALOG10(m_ns)*1000000)/(ALOG10(2)*1000000))
  nl_pow = FLOOR(ALOG10(m_nl)/ALOG10(2))
  ;��
  if m_ns eq 2^ns_pow then begin
    new_ns = m_ns
  end else begin
    new_ns = 2^(ns_pow+1)
  endelse
  ;��
  if m_nl eq 2^nl_pow then begin
    new_nl = m_nl
  end else begin
    new_nl = 2^(nl_pow+1)
  endelse
  newh_redata = make_array(new_ns,new_nl)
  newmuldata = make_array(new_ns,new_nl,m_nb)
  newh_redata[0:h_ns-1,0:h_nl-1]=h_redata
  newmuldata[0:m_ns-1,0:m_nl-1,*]=muldata
  newh_redata[h_ns-1:new_ns-1,h_nl-1:new_nl-1]=0
  newmuldata[m_ns-1:new_ns-1,m_nl-1:new_nl-1,*]=0
  
  ;;;;;;;;;;;;;;;;;;;;С���任;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;С����
  if basis eq 'Haar' then begin
    info=wv_fn_haar(2, wavelet, scaling,ioff, joff)
  endif else if basis eq 'Daubechies' then begin
    info=wv_fn_Daubechies(8, wavelet, scaling,ioff, joff)
  end
  ;�ںϺ�С��ϵ��
  W_F=MAKE_ARRAY(new_ns,new_nl,m_nb)
  ;�ԵͿռ�ֱ���Ӱ�����ݽ���С���ֽ�
  W_newmuldata=WV_DWT(newmuldata,wavelet,scaling,ioff,joff,n_levels=n_lev)
  ;�𲨶ν����ں�
  for i_m_nb=0,m_nb-1 do begin
    Mnewh_redata=newh_redata
    W_newh_redata=WV_DWT(Mnewh_redata,wavelet,scaling,ioff,joff,n_levels=n_lev)
    ;;;;;;;;;;;;;;;;;;��Ƶ
    ;��Ƶϵ����Χ
    l_ns = new_ns/(2^(n_lev))
    l_nl = new_nl/(2^(n_lev))
    ;1 Replace
    if lowrule eq  'Replace' then begin
      W_F[0:l_ns-1,0:l_nl-1,i_m_nb]=$
        fusion_function_wv_lfrule(W_newh_redata[0:l_ns-1,0:l_nl-1],W_newmuldata[0:l_ns-1,0:l_nl-1,i_m_nb],'Replace')
    ;2 Weighted average
    endif else if lowrule eq 'Weighted Average' then begin
      W_F[0:l_ns-1,0:l_nl-1,i_m_nb]=$
        fusion_function_wv_lfrule(W_newh_redata[0:l_ns-1,0:l_nl-1],W_newmuldata[0:l_ns-1,0:l_nl-1,i_m_nb],'Weighted average')
    ;3 Weighted average or choose
    endif else if lowrule eq 'Weighted Average or Choose' then begin
      W_F[0:l_ns-1,0:l_nl-1,i_m_nb]=$
        fusion_function_wv_lfrule(W_newh_redata[0:l_ns-1,0:l_nl-1],W_newmuldata[0:l_ns-1,0:l_nl-1,i_m_nb],'Weighted average or choose')
    endif
    ;;;;;;;;;;;;;;;;;;;;;;;;;;��Ƶ
    for i_lev=1,n_lev do begin
      s_ns = new_ns/(2^(i_lev))
      s_nl = new_nl/(2^(i_lev))
      e_ns = 2*new_ns/(2^(i_lev))-1
      e_nl = 2*new_nl/(2^(i_lev))-1
      L_Parr = WV_DWT(W_newh_redata,wavelet,scaling,ioff,joff,n_levels=i_lev)
      L_Marr = WV_DWT(W_newmuldata,wavelet,scaling,ioff,joff,n_levels=i_lev)
      ;1 Replace
      if highrule eq 'Replace' then begin
        ;Diag
        W_F[s_ns:e_ns,s_nl:e_nl,i_m_nb]=$
          fusion_function_wv_hfrule(W_newh_redata[s_ns:e_ns,s_nl:e_nl],0,W_newmuldata[s_ns:e_ns,s_nl:e_nl],0,'Replace')
        ;Horizon
        W_F[s_ns:e_ns,0:e_nl,i_m_nb]=$
          fusion_function_wv_hfrule(W_newh_redata[s_ns:e_ns,0:e_nl],0,W_newmuldata[s_ns:e_ns,0:e_nl],0,'Replace')
        ;Vertical
        W_F[0:e_ns,s_nl:e_nl,i_m_nb]=$
          fusion_function_wv_hfrule(W_newh_redata[0:e_ns,s_nl:e_nl],0,W_newmuldata[0:e_ns,s_nl:e_nl],0,'Replace')
      ;2 Maximum
      endif else if highrule eq 'Maximum' then begin
        ;Diag
        W_F[s_ns:e_ns,s_nl:e_nl,i_m_nb]=$
          fusion_function_wv_hfrule(W_newh_redata[s_ns:e_ns,s_nl:e_nl],0,W_newmuldata[s_ns:e_ns,s_nl:e_nl],0,'Maximum')
        ;Horizon
        W_F[s_ns:e_ns,0:e_nl,i_m_nb]=$
          fusion_function_wv_hfrule(W_newh_redata[s_ns:e_ns,0:e_nl],0,W_newmuldata[s_ns:e_ns,0:e_nl],0,'Maximum')
        ;Vertical
        W_F[0:e_ns,s_nl:e_nl,i_m_nb]=$
          fusion_function_wv_hfrule(W_newh_redata[0:e_ns,s_nl:e_nl],0,W_newmuldata[0:e_ns,s_nl:e_nl],0,'Maximum')
      ;3 Local intensity
      endif else if highrule eq 'Direction Contrast' then begin
        ;Diag
        W_F[s_ns:e_ns,s_nl:e_nl,i_m_nb]=$
          fusion_function_wv_hfrule(W_newh_redata[s_ns:e_ns,s_nl:e_nl],L_Parr,W_newmuldata[s_ns:e_ns,s_nl:e_nl],L_Marr,'Direction Contrast')
        ;Horizon
        W_F[s_ns:e_ns,0:e_nl,i_m_nb]=$
          fusion_function_wv_hfrule(W_newh_redata[s_ns:e_ns,0:e_nl],L_Parr,W_newmuldata[s_ns:e_ns,0:e_nl],L_Marr,'Direction Contrast')
        ;Vertical
        W_F[0:e_ns,s_nl:e_nl,i_m_nb]=$
          fusion_function_wv_hfrule(W_newh_redata[0:e_ns,s_nl:e_nl],L_Parr,W_newmuldata[0:e_ns,s_nl:e_nl],L_Marr,'Direction Contrast')
      endif else if highrule eq 'Average Gradient' then begin
        ;Diag
        W_F[s_ns:e_ns,s_nl:e_nl,i_m_nb]=$
          fusion_function_wv_hfrule(W_newh_redata[s_ns:e_ns,s_nl:e_nl],L_Parr,W_newmuldata[s_ns:e_ns,s_nl:e_nl],L_Marr,'Average Gradient')
        ;Horizon
        W_F[s_ns:e_ns,0:e_nl,i_m_nb]=$
          fusion_function_wv_hfrule(W_newh_redata[s_ns:e_ns,0:e_nl],L_Parr,W_newmuldata[s_ns:e_ns,0:e_nl],L_Marr,'Average Gradient')
        ;Vertical
        W_F[0:e_ns,s_nl:e_nl,i_m_nb]=$
          fusion_function_wv_hfrule(W_newh_redata[0:e_ns,s_nl:e_nl],L_Parr,W_newmuldata[0:e_ns,s_nl:e_nl],L_Marr,'Average Gradient')
      endif else if highrule eq 'Area Energy' then begin
        ;Diag
        W_F[s_ns:e_ns,s_nl:e_nl,i_m_nb]=$
          fusion_function_wv_hfrule(W_newh_redata[s_ns:e_ns,s_nl:e_nl],L_Parr,W_newmuldata[s_ns:e_ns,s_nl:e_nl],L_Marr,'Area Energy')
        ;Horizon
        W_F[s_ns:e_ns,0:e_nl,i_m_nb]=$
          fusion_function_wv_hfrule(W_newh_redata[s_ns:e_ns,0:e_nl],L_Parr,W_newmuldata[s_ns:e_ns,0:e_nl],L_Marr,'Area Energy')
        ;Vertical
        W_F[0:e_ns,s_nl:e_nl,i_m_nb]=$
          fusion_function_wv_hfrule(W_newh_redata[0:e_ns,s_nl:e_nl],L_Parr,W_newmuldata[0:e_ns,s_nl:e_nl],L_Marr,'Area Energy')
      endif
    endfor
  endfor
  ;��任
  W_F_IMAGE=WV_DWT(W_F,wavelet,scaling,ioff,joff,n_levels=n_lev,INVERSE=1)
  F_IMAGE = W_F_IMAGE[0:m_ns-1,0:m_nl-1,*]
  
  ;д�ļ�
  result = fusion_function_write_tiff(filename3,F_IMAGE,m_fid,m_ns,m_nl,m_nb,m_type)
  ;��������
  if OutQuaFile eq 'true' then begin
    Outfilename = (filename3)+'.txt'
    temp=fusion_function_quality(h_redata,muldata,F_IMAGE,Outfilename,kernel)
  endif
  ;�ͷſռ�
  f_image=!null
  return,''
end

function fusion_function_getpandata,band,h_ns,h_nl,h_nb,h_fid
  ;������
  ;��ȡ�߿ռ�ֱ��ʵĲ��λ��ǲ������
  ;
  ;����˵����
  ;band----0: ���в���
  ;        1-4: 1-4 ����
  ;        5: ���εĺ�
  ;        6: 4���ε�����ƽ��
  ;        7: 4���εļ���ƽ��
  ;        8: 0.25*b1+0.25*b2+0.16*b3+0.34*b4
  ;h_ns----��
  ;h_nl----��
  ;h_nb----��
  ;h_fid----Ӱ��ID


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
  ENDIF
  return,h_redata
end
function fusion_function_edge,data,Kernel
  ;������
  ;��ȡӰ���Ե
  ;
  ;����˵����
  ;data----����ȡ��Ե��Ӱ������
  ;kernel----�˲�����


  if Kernel eq 'Sobel' then begin
    ;Sobel
    S_X=[[1,2,1],[0,0,0],[-1,-2,-1]]
    S_Y=[[1,0,-1],[2,0,-2],[1,0,-1]]
    outdata = convol(data,S_X)
    outdata = convol(outdata,S_Y)
  endif else if Kernel eq 'Robert' then begin
    ;Robert
    R_135=[[1,0],[0,-1]]
    R_45=[[0,1],[-1,0]]
    outdata = convol(data,R_135)
    outdata = convol(outdata,R_45)
  endif else if Kernel eq 'Prewitt' then begin
    ;Prewitt
    P_X=[[-1,-1,-1],[0,0,0],[1,1,1]]
    P_Y=[[1,0,-1],[1,0,-1],[1,0,-1]]
    outdata = convol(data,P_X)
    outdata = convol(outdata,P_Y)
  endif else if Kernel eq 'Laplacian1' then begin
    ;Laplacian1
    L1=[[0,-1,0],[-1,4,-1],[0,-1,0]]
    outdata = convol(data,L1)
  endif else if Kernel eq 'Laplacian2' then begin
    ;Laplacian2
    L2=[[-1,-1,-1],[-1,8,-1],[-1,-1,-1]]
    outdata = convol(data,L2)
  endif else if Kernel eq 'Log' then begin
    ;Log
    Log=[[-2,-4,-4,-4,-2],$
      [-4,0,8,0,-4],$
      [-4,8,24,8,-4],$
      [-4,0,8,0,-4],$
      [-2,-4,-4,-4,-2]]
    outdata = convol(data,Log)
  endif
  return,outdata
end
function fusion_function_write_tiff,filename,data,fid,ns,nl,nb,type
  ;������
  ;д�����ļ�
  ;
  ;����˵����
  ;filename----����ļ���
  ;data----�������
  ;fid----ֻ��Ϊ�˵õ��ں�Ӱ���mapinfo
  ;ns----��
  ;nl----��
  ;nb----����
  ;type----��������

  ;Ӱ��ͶӰ��Ϣ
  mapinfo=ENVI_GET_MAP_INFO(fid=fid)
  
  ;д�ļ�
  ENVI_REPORT_INIT,'д�����ļ�...',title="�����ں�",base=base,/interrupt
  ENVI_REPORT_INC,BASE,1
  OPENW,lun,filename,/GET_LUN
  FOR i=0,nl-1 DO BEGIN
    WRITEU,lun,data[*,i,*]
    P=(i+1)/nl*100.
    ENVI_REPORT_STAT,base,p,100,CANCEL=cancelvar
  ENDFOR
  free_lun,lun
  
  
  ;תtiff
  ENVI_SETUP_HEAD,fname=filename,ns=ns,nl=nl,nb=nb,$
    DATA_TYPE=type,offset=0,INTERLEAVE=1,MAP_INFO=mapinfo, /write, /open
  ENVI_OPEN_FILE,filename,r_fid=outFid
  ENVI_FILE_QUERY,outFid,ns=ns,nl=nl,nb=nb,dims=dims
  ENVI_OUTPUT_TO_EXTERNAL_FORMAT,fid=outFid,dims=dims,pos=INDGEN(nb),$
    out_name=filename+'-tif.tif',/TIFF
  ENVI_REPORT_INIT,base=BASE,/finish
  
  ;ɾ���м���
  if outfid ne -1 then begin
    ENVI_FILE_MNG, id = outFid,/remove,/delete
    return,1
  endif else begin
    ENVI_FILE_MNG, id = outFid,/remove,/delete
    return,0
  endelse
end

function fusion_function_wv_hfrule,W_Parr,L_Parr,W_Marr,L_Marr,method
  ;������
  ;�ںϵ�Ƶ����
  ;
  ;����˵����
  ;W_Parr----�߿ռ�ֱ���Ӱ��С��ϵ����Ƶ����
  ;L_Parr----�߿ռ�ֱ���Ӱ��С��ϵ����Ƶ����
  ;W_Marr----�Ϳռ�ֱ���Ӱ��С��ϵ����Ƶ����
  ;L_Marr----�Ϳռ�ֱ���Ӱ��С��ϵ����Ƶ����
  ;method----�ںϹ���
  ;
  ;����:
  ;�ںϺ�С��ϵ��

  ;�õ�ns&nl
  size = size(W_Marr)
  ns = size[1]
  nl = size[2]
  
  ;�ںϺ�ϵ��
  W_Flow = fltarr(ns,nl)
  if method eq 'Replace' then begin
    W_Flow=W_Parr
  endif else if method eq 'Maximum' then begin
    W_Flow=(W_Parr>W_Marr)
  endif else if method eq 'Direction Contrast' then begin;paper 'һ�ֻ���С������ԱȶȵĶ�۽�ͼ���ںϷ���.�й�ͼ��ͼ��ѧ��.'
    C_Parr = W_Parr/L_Parr
    C_Marr = W_Marr/L_Marr
    indices1 = where(C_Parr ge C_Marr)
    indices2 = where(C_Parr lt C_Marr)
    W_Flow[indices1] = W_Parr[indices1]
    W_Flow[indices2] = W_Marr[indices2]
  endif else if method eq 'Average Gradient' then begin;Paper '����������˹�������任��ͼ���ں��㷨�о�.���������.'
    winsize = 5
    win_r = winsize/2
    PanGradientX = fltarr(ns,nl)
    PanGradientY = fltarr(ns,nl)
    MulGradientX = fltarr(ns,nl)
    MulGradientY = fltarr(ns,nl)
    ;x ������ݶ�
    for i_ns=0,ns-2 do begin
      PanGradientX[i_ns,*] = W_Parr[i_ns+1,*]-W_Parr[i_ns,*]
      MulGradientX[i_ns,*] = W_Marr[i_ns+1,*]-W_Marr[i_ns,*]
    endfor
    ;y �����ݶ�
    for i_nl=0,nl-2 do begin
      PanGradientY[*,i_nl] = W_Parr[*,i_nl+1]-W_Parr[*,i_nl]
      MulGradientY[*,i_nl] = W_Marr[*,i_nl+1]-W_Marr[*,i_nl]
    endfor
    ;
    for i_nl=0,nl-2 do begin
      for i_ns=0,ns-2 do begin
        s_nl = (i_nl-win_r)>0
        e_nl = (i_nl+win_r)<(nl-2)
        s_ns = (i_ns-win_r)>0
        e_ns = (i_ns+win_r)<(ns-2)
        ;ƽ���ݶ�
        Temp1 = sqrt((PanGradientX[s_ns:e_ns,s_nl:e_nl]^2+PanGradientY[s_ns:e_ns,s_nl:e_nl]^2)/2.)
        PanAveGra = mean(Temp1)
        Temp2 = sqrt((MulGradientX[s_ns:e_ns,s_nl:e_nl]^2+MulGradientY[s_ns:e_ns,s_nl:e_nl]^2)/2.)
        MulAveGra = mean(Temp2)
        if PanAveGra ge MulAveGra then begin
          W_Flow[i_ns,i_nl] = W_Parr[i_ns,i_nl]
        endif else begin
          W_Flow[i_ns,i_nl] = W_Marr[i_ns,i_nl]
        endelse
      endfor
    endfor
  endif else if method eq 'Area Energy' then begin;Paper '����������˹�������任��ͼ���ں��㷨�о�.���������.'
    PanAreEne = fltarr(ns,nl)
    MulAreEne = fltarr(ns,nl)
    w=[[1,2,1],$
      [2,4,2],$
      [1,2,1]]/16.
    PanAreEne = convol(W_Parr,w)
    MulAreEne = convol(W_Marr,w)
    indice1 = where(PanAreEne ge MulAreEne)
    indice2 = where(PanAreEne lt MulAreEne)
    W_Flow[indice1] = W_Parr[indice1]
    W_Flow[indice2] = W_Marr[indice2]
  ENDIF
  return,W_Flow
end

function fusion_function_wv_lfrule,W_Parr,W_Marr,method
  ;������
  ;�ںϵ�Ƶ����
  ;
  ;����˵����
  ;W_Parr----�߿ռ�ֱ���Ӱ��С��ϵ����Ƶ����
  ;W_Marr----�Ϳռ�ֱ���Ӱ��С��ϵ����Ƶ����
  ;method----�ںϹ���
  ;
  ;����:
  ;�ںϺ�С��ϵ��

  ;�õ� ns&nl
  size = size(W_Marr)
  l_ns = size[1]
  l_nl = size[2]
  ;�ںϺ�ϵ��
  W_Flow = fltarr(l_ns,l_nl)
  if method eq 'Replace' then begin
    W_Flow=W_Marr
  endif else if method eq 'Weighted Average' then begin
    W_Flow=0.5*W_Marr+0.5*W_Parr
  endif else if method eq 'Weighted Average or Choose' then begin;paper 'һ�ֻ���С���任��ͼ���ں��㷨.����ѧ��.'
    win_size = 3
    win_radius = 1
    ;�����
    kernel=fltarr(3,3)
    for i=0,win_size-1 do begin
      for j=0,win_size-1 do begin
        KERNEL[i,j]=1./((sqrt((j-win_radius)^2+(i-win_radius)^2))+1.0)
      endfor
    endfor
    ;��������
    Sarr_Pan = fltarr(l_ns,l_nl)
    Sarr_Mul = fltarr(l_ns,l_nl)
    Sarr_PandM = fltarr(l_ns,l_nl)
    R = fltarr(l_ns,l_nl)
    wmin = fltarr(l_ns,l_nl)
    wmax = fltarr(l_ns,l_nl)
    Sarr_PandM = convol(2*W_Parr*W_Marr,kernel)
    Sarr_Pan = convol(W_Parr^2,kernel)
    Sarr_Mul = convol(W_Marr^2,kernel)
    ;����ƥ����� R.(�� 0.000000001��ֹ��ĸΪ0)
    R = Sarr_PandM/(Sarr_Pan+Sarr_Mul+0.00000001)
    ;�㷨����
    thre = 0.6
    indice1 = where(R le thre)
    indice2 = where(R gt thre)
    wmin[indice1] = 0.
    wmax[indice1] = 1.
    wmin[indice2] = 1/2.-((1-R[indice2])/(1-thre))/2.
    wmax[indice2] = 1-wmin[indice2]
    indice3 = where(Sarr_Pan ge Sarr_Mul)
    indice4 = where(Sarr_Pan lt Sarr_Mul)
    W_Flow[indice3] = W_Parr[indice3]*wmax[indice3]+W_Marr[indice3]*wmin[indice3]
    W_Flow[indice4] = W_Parr[indice4]*wmin[indice4]+W_Marr[indice4]*wmax[indice4]
  endif
  return,W_Flow
end
function fusion_function_quality,h_redata,muldata,F_DATA,Outfilename,Kernel
  ;����:
  ;�����ںϺ���������
  ;
  ;����˵����
  ;h_redata----�߿ռ�ֱ���Ӱ������
  ;muldata----�Ϳռ�ֱ���Ӱ������
  ;F_DATA----�ںϺ�Ӱ������
  ;Outfilename----���������ļ�
  ;Kernel----�ռ�������������

  ENVI_REPORT_INIT,'�������������ļ�...',title="�����ں�",base=base,/interrupt
  ENVI_REPORT_INC,BASE,1
  dims=size(h_redata)
  dims2=size(muldata)
  dims3=size(f_data)
  h_ns=dims[1]
  h_nl=dims[2]
  m_ns=dims2[1]
  m_nl=dims2[2]
  m_nb=dims2[3]
  f_ns=dims3[1]
  f_nl=dims3[2]
  f_nb=dims3[3]
  Openw,lun,Outfilename,/get_lun
  printf,lun,'----------------------------------------------��������---------------------------------------------'
  printf,lun,'-----------------------��ֵ-----------------------------'
  ;;;;;Mean
  ;CCD
  CCD_Mean = mean(h_redata)
  printf,lun,'�߷ֱ���Ӱ��',CCD_Mean
  printf,lun,''
  ;IRS
  for i_m_nb=0,m_nb-1 do begin
    temp = muldata[*,*,i_m_nb]
    index_muldatagt0 = where(temp gt 0)
    irs_Mean = mean(temp[index_muldatagt0])
    printf,lun,'�ͷֱ���Ӱ��',i_m_nb+1,irs_mean
  endfor
  printf,lun,''
  ;Fusion
  for i_f_nb=0,f_nb-1 do begin
    temp = f_data[*,*,i_f_nb]
    index_f_datagt0 = where(temp gt 0)
    fusion_Mean = mean(temp[index_f_datagt0])
    printf,lun,'�ں�Ӱ��',i_f_nb+1,fusion_Mean
  endfor
  ENVI_REPORT_STAT,BASE,10,100
  printf,lun,'-----------------------��׼��-----------------------------'
  ;;;;;Standard Deviation
  ;CCD
  CCD_Moment = Moment(h_redata)
  CCD_SD = SQRT(CCD_Moment[1])
  printf,lun,'�߷ֱ���Ӱ��',CCD_SD
  printf,lun,''
  ;IRS
  for i_m_nb=0,m_nb-1 do begin
    temp = muldata[*,*,i_m_nb]
    index_muldatagt0 = where(temp gt 0)
    irs_Moment = Moment(temp[index_muldatagt0])
    irs_SD = SQRT(irs_Moment[1])
    printf,lun,'�ͷֱ���Ӱ��',i_m_nb+1,irs_SD
  endfor
  printf,lun,''
  ;Fusion
  for i_f_nb=0,f_nb-1 do begin
    temp = f_data[*,*,i_f_nb]
    index_f_datagt0 = where(temp gt 0)
    fusion_Moment = Moment(temp[index_f_datagt0])
    fusion_SD = SQRT(fusion_Moment[1])
    printf,lun,'�ں�Ӱ��',i_f_nb+1,fusion_SD
  endfor
  ENVI_REPORT_STAT,BASE,20,100
  printf,lun,'-----------------------����ERGAS-----------------------------';Quality of high resolution synthesised images is there a simple criterion
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
  ENVI_REPORT_STAT,BASE,30,100
  printf,lun,'-----------------------���׻���-----------------------------'
  ;;;;;Spectral Distortion
  ;Fusion
  for i_f_nb=0,f_nb-1 do begin
    tempf = f_data[*,*,i_f_nb]
    tempm = muldata[*,*,i_f_nb]
    distortion=mean(abs(tempf-tempm))
    printf,lun,'Spectral Distortion',i_f_nb+1,distortion
  endfor
  ENVI_REPORT_STAT,BASE,40,100
  printf,lun,'-----------------------���׽�ӳ��-----------------------------'
  ;;;;;Spectral Angle Map
  ;Fusion
  vMuldata=reform(muldata,m_ns*m_nl,m_nb)
  vFdata=reform(f_data,m_ns*m_nl,m_nb)
  for i_f_nb=0,f_nb-1 do begin
    ;SAM = acos(total(vMuldata[*,i_f_nb]*vMuldata[*,i_f_nb])/(sqrt(total(vMuldata[*,i_f_nb]^2.0))*sqrt(total(vMuldata[*,i_f_nb]^2.0))))
    SAM = acos(total(vMuldata[*,i_f_nb]*vFdata[*,i_f_nb])/(sqrt(total(vMuldata[*,i_f_nb]^2.0))*sqrt(total(vFdata[*,i_f_nb]^2.0))))
    printf,lun,'Spectral Angel Map',i_f_nb+1,SAM
  endfor
  ENVI_REPORT_STAT,BASE,50,100
  printf,lun,'-----------------------��ͷֱ���Ӱ�����ϵ��-----------------------------'
  ;;;;;Correlated Coefficient
  for i_f_nb=0,f_nb-1 do begin
    tempf = f_data[*,*,i_f_nb]
    tempm = muldata[*,*,i_f_nb]
    meanf = mean(tempf)
    meanm = mean(tempm)
    minus_f = tempf-meanf
    minus_m = tempm-meanm
    C = total(minus_f*minus_m)/sqrt(float(total(minus_f^2))*total(minus_m^2))
    printf,lun,'Correlate Coefficient',i_f_nb+1,C
  endfor
  ENVI_REPORT_STAT,BASE,60,100
  printf,lun,'----------------------------------------------�ռ�����---------------------------------------------'
  printf,lun,'-----------------------ƽ���ݶ�-----------------------------'
  ;;;;;Aerage Gradient
  ;CCD
  G = 0.0
  for i_h_ns=0,h_ns-2 do begin
    for i_h_nl=0,h_nl-2 do begin
      G = G + SQRT(((float(h_redata[i_h_ns,i_h_nl])-h_redata[i_h_ns+1,i_h_nl])^2+$
        (float(h_redata[i_h_ns,i_h_nl])-h_redata[i_h_ns,i_h_nl+1])^2)/2.0)
    endfor
    p=(i_h_ns+1.0)/(h_ns-1)*100.*0.1
    ENVI_REPORT_STAT,BASE,60+p,100
  endfor
  G = G/(FLOAT(h_ns-1)*(h_nl-1))
  PRINTF,LUN,'�߷ֱ���Ӱ��',G
  printf,lun,''
  ;IRS
  for i_m_nb=0,m_nb-1 do begin
    G=0.0
    temp = muldata[*,*,i_m_nb]
    for i_m_ns=0,m_ns-2 do begin
      for i_m_nl=0,m_nl-2 do begin
        G = G + SQRT(((temp[i_m_ns,i_m_nl]-temp[i_m_ns+1,i_m_nl])^2+$
          (temp[i_m_ns,i_m_nl]-temp[i_m_ns,i_m_nl+1])^2)/2.0)
      endfor
      p=(i_m_nb*(m_ns-1)+i_m_ns+1.0)/((m_ns-1)*m_nb)*100.*0.1
      ENVI_REPORT_STAT,BASE,70+p,100
    endfor
    G = G/(FLOAT(m_ns-1)*(m_nl-1))
    printf,lun,'�ͷֱ���Ӱ��',i_m_nb+1,G
  endfor
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
      ENVI_REPORT_STAT,BASE,80+p,100
    endfor
    G = G/(FLOAT(f_ns-1)*(f_nl-1))
    printf,lun,'�ں�Ӱ��',i_f_nb+1,G
  endfor
  printf,lun,'-----------------------��߷ֱ���Ӱ���Ƶ�������ϵ��-----------------------------'
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
    printf,lun,'Correlate Coefficient',i_f_nb+1,C
  endfor
  ENVI_REPORT_STAT,BASE,95,100
  printf,lun,'-----------------------�ռ�ERGAS-----------------------------';Quality of high resolution synthesised images is there a simple criterion
  H=30
  L=150
  MiArr = fltarr(m_nb)
  RMSEArr = fltarr(m_nb)
  for i_m_nb=0,m_nb-1 do begin
    MiArr[i_m_nb]=Mean(h_redata[*,*])
    RMSEArr[i_m_nb]=sqrt(total((h_redata[*,*]-f_data[*,*,i_m_nb])^2.0))/(m_ns*m_nl)
  endfor
  ERGAS = 100.0*H/L*SQRT(TOTAL(RMSEArr^2/MiArr^2)/M_NB)
  printf,lun,'ERGAS',ERGAS
  ENVI_REPORT_STAT,BASE,100,100
  ENVI_REPORT_INIT,BASE=BASE,/FINISH
  free_lun,lun
  return,1
end