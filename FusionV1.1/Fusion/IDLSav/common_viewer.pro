;影像浏览窗口，可浏览多种格式的影像，并设置RGB三通道的波段，查看影像的光谱曲线，进行放大、缩小等操作
;钮立明
;2010年3月
FUNCTION CURSORCREATE, normhand=normhand, handgrasp=handgrasp, magic=magic
  IF KEYWORD_SET(normhand) THEN BEGIN
    strArray = [ $
      '       ##       ', $
      '   ## #  ###    ', $
      '  #  ##  #  #   ', $
      '  #  ##  #  # # ', $
      '   #  #  #  ## #', $
      '   #  #  #  #  #', $
      ' ## #       #  #', $
      '#  ##          #', $
      '#   #   $     # ', $
      ' #            # ', $
      '  #           # ', $
      '  #          #  ', $
      '   ##########   ', $
      '    #########   ', $
      '     ########   ', $
      '                ']
  ENDIF
  IF KEYWORD_SET(handgrasp) THEN BEGIN
    strArray = [ $
      '                ', $
      '                ', $
      '                ', $
      '                ', $
      '                ', $
      '   ## ## ##     ', $
      '  #  #  #  ##   ', $
      '  #        # #  ', $
      '   #         #  ', $
      '  ##         #  ', $
      ' #     $     #  ', $
      ' #          #   ', $
      '  #         #   ', $
      '   #########    ', $
      '    ########    ', $
      '    ########    ']
  ENDIF
  
  IF KEYWORD_SET(magic) THEN BEGIN
    strArray = [ $
      '      #         ', $
      '  #   #   #     ', $
      '   #######      ', $
      '   #     #      ', $
      '   #     #      ', $
      ' ###     ###    ', $
      '   #     #      ', $
      '   #     #      ', $
      '   ########     ', $
      ' #    #  ###    ', $
      '          ###   ', $
      '           ###  ', $
      '            ### ', $
      '             ###', $
      '                ', $
      '                ']
      
  ENDIF
  cursor_image = CREATE_CURSOR(strArray, HOTSPOT=hotspot, MASK=mask)
  RETURN, cursor_image
END
FUNCTION PICK_FILE,event

  CATCH, Error_status
  ;This statement begins the error handler:
  IF Error_status NE 0 THEN BEGIN
    PRINT, 'Error index: ', Error_status
    PRINT, 'Error message: ', !ERROR_STATE.MSG
    ;Result = DIALOG_MESSAGE(!ERROR_STATE.MSG, /CENTER)
    help, /last_message, output=errtext
    Result = DIALOG_MESSAGE(errtext, /CENTER)
    CATCH, /CANCEL
    return,0
  ENDIF
  
  filter = ['*.tif','*.jpg','*.bmp']
  title = '打开影像'
  filename = DIALOG_PICKFILE(title=title, filter=filter,dialog_parent=event.top);envi_pickfile
  
  return,filename
  
END

PRO FULL_EXTENT,event

  Widget_Control,event.top,get_uvalue=PSTATE
  
  wBase = (*PSTATE).WID_BASE_TLB
  
  imageSize=(*PSTATE).imageSize
  
  Widget_Control,wBase,TLB_GET_SIZE=TLB_SIZE
  
  W_SIZE=[TLB_SIZE[0]-1,TLB_SIZE[1]-25]
  
  wDraw = (*PSTATE).WID_DRAW
  oView=(*PSTATE).oView
  WIDGET_CONTROL,wDraw,GET_VALUE=oWindow
  
  oWindow -> getProperty,dimensions=D_SIZE
  IMG_RATIO = float(imageSize[0])/imageSize[1]
  WIN_RATIO = float(D_SIZE[0]/D_SIZE[1])
  
  if(IMG_RATIO gt WIN_RATIO) then begin
    scale_v = float(D_SIZE[0]) / imageSize[0]
  endif else begin
    scale_v = float(D_SIZE[1]) / imageSize[1]
  endelse
  
  xoffset = (D_SIZE[0] - imageSize[0]*scale_v) / 2.0
  yoffset = (D_SIZE[1] - imageSize[1]*scale_v) / 2.0
  
  oImageModal = oView->GetByName('oModel')
  oImageModal->reset
  oImageModal->scale, scale_v, scale_v, 1
  oImageModal->Translate, xoffset, yoffset, 0
  
  oWindow -> Draw,oView
  
END

PRO SCALE_ZOOM_IMAGE,EVENT

  Widget_Control,event.top,get_uvalue=PSTATE
  
  oView = (*PSTATE).oView
  scale_v = (*PSTATE).scale
  DRAW_ID = (*PSTATE).WID_DRAW
  
  WIDGET_CONTROL,Draw_ID,GET_VALUE=oWindow
  
  oImageModal = oView->GetByName('oModel')
  oImageModal->scale, scale_v, scale_v, 1
  
  GEOMETRY = WIDGET_INFO(DRAW_ID, /GEOMETRY)
  xsize = GEOMETRY.SCR_XSIZE
  ysize = GEOMETRY.SCR_YSIZE
  
  xoffset = -xsize/2 * (scale_v-1)
  yoffset = -ysize/2 * (scale_v-1)
  
  oImageModal->Translate, xoffset, yoffset, 0
  
  oWindow->Draw,oView
  
END

PRO RECT_ZOOM_IMAGE,event

  Widget_Control,event.top,get_uvalue=PSTATE
  
  oRectline = (*PSTATE).oView->GetByName('oRectModal/oRectline')
  
  DRAW_ID = (*PSTATE).WID_DRAW
  
  WIDGET_CONTROL,Draw_ID,GET_VALUE=oWindow
  
  oRectline -> SetProperty,hide=1
  oRectline -> GetProperty, DATA=rect
  xsize=abs(rect[0,2]-rect[0,0])
  ysize=abs(rect[1,2]-rect[1,0])
  
  if xsize eq 0 or ysize eq 0 then begin
    POINT_ZOOM_IMAGE,event
    return
  endif
  oImageModal = (*PSTATE).oView->GetByName('oModel')
  oImage = (*PSTATE).oImage
  oImage -> GetProperty, DIMENSIONS=image_size
  oImageModal->GetProperty, TRANSFORM=image_matrix_old
  GEOMETRY = WIDGET_INFO(draw_id, /GEOMETRY)
  xsize_d = GEOMETRY.SCR_XSIZE
  ysize_d = GEOMETRY.SCR_YSIZE
  wh_ratio_rect = xsize * 1.0 / ysize
  wh_ratio_draw = xsize_d * 1.0 / ysize_d
  if(wh_ratio_rect gt wh_ratio_draw) then begin
    scale_v = xsize_d * 1.0 / xsize
  endif else begin
    scale_v = ysize_d * 1.0 / ysize
  endelse
  if (*PSTATE).cursor_state eq 2 then begin
    scale_v = 1.0 / (-1.0 / scale_v + 2.0)
  endif
  image_matrix_new = image_matrix_old
  image_matrix_new[0:1,0:1] *= scale_v
  xoffset = min(rect[0,*])
  yoffset = min(rect[1,*])
  if (*PSTATE).cursor_state eq 1 then begin
    image_matrix_new[3,0:1] -= [xoffset,yoffset]
    image_matrix_new[3,0:1] *= scale_v
  endif else if (*PSTATE).cursor_state eq 2 then begin
    image_matrix_new[3,0:1] += [xoffset,yoffset]
    image_matrix_new[3,0:1] *= scale_v
  endif
  
  oImageModal->SetProperty, TRANSFORM=image_matrix_new
  
  oWindow->Draw, (*PSTATE).oView
END

PRO POINT_ZOOM_IMAGE,event

  Widget_Control,event.top,get_uvalue=PSTATE
  
  DRAW_ID = (*PSTATE).WID_DRAW
  
  WIDGET_CONTROL,Draw_ID,GET_VALUE=oWindow
  
  if (*PSTATE).cursor_state eq 1 then begin
    scale_v = 1.15
  endif else begin
    scale_v = 0.85
  endelse
  
  oImageModal = (*PSTATE).oView->GetByName('oModel')
  oImageModal->scale, scale_v, scale_v, 1
  xoffset = -event.x * (scale_v-1)
  yoffset = -event.y * (scale_v-1)
  oImageModal->Translate, xoffset, yoffset, 0
  
  oWindow->Draw, (*PSTATE).oView
  
END

PRO REFRESH_TABLE,EVENT

  WIDGET_CONTROL,event.top,get_uvalue=PSTATE
  
  SPECTRAL=*((*PSTATE).SPECTRAL)
  x=(*PSTATE).xlabel
  y=(*PSTATE).ylabel
  
  qText=(*PSTATE).qText
  qTable=(*PSTATE).qTable
  
  cr='x: '+strtrim(string(x),2)+' y: '+strtrim(string(y),2)
  
  Widget_Control,qText,set_value=cr
  
  bandnum = transpose(strtrim(string(indgen((*PSTATE).CHANNEL)+1),2))
  table=[bandnum,transpose(strtrim(string(SPECTRAL),2))]
  
  Widget_Control,qTable,set_value=table
END

PRO QUERY_INFO,EVENT

  WIDGET_CONTROL,event.top,get_uvalue=PSTATE
  
  if ptr_valid((*PSTATE).SPECTRAL) eq 0 then begin
    SPECTRAL=FLTARR((*PSTATE).CHANNEL)
  endif else begin
    SPECTRAL=*((*PSTATE).SPECTRAL)
  endelse
  
  x=(*PSTATE).xlabel
  y=(*PSTATE).ylabel
  
  scr_dims = GET_SCREEN_SIZE()
  w_xoffset=(scr_dims[0]-350)/2
  w_yoffset=(scr_dims[1]-270)/2
  
  qBase = widget_base(GROUP_LEADER=(*PSTATE).WID_BASE_TLB,/COLUMN, $
    xoffset=w_xoffset,yoffset=w_yoffset,XPAD=0,YPAD=0,title='像元信息' $
    ,NOTIFY_REALIZE ='')
    
  text='x: '+strtrim(string(x),2)+' y: '+strtrim(string(y),2)
  qText = widget_text(qBase,UNAME='qText',XSIZE=20,YSIZE=1,VALUE=text)
  
  COLUMN_NAME=['波段号','像元值']
  bandnum = transpose(strtrim(string(indgen((*PSTATE).CHANNEL)+1),2))
  table=[bandnum,transpose(strtrim(string(SPECTRAL),2))]
  qTable = widget_Table(qBase,UNAME='QTABLE',COLUMN_LABELS=COLUMN_NAME, $
    XSIZE=2,YSIZE=(*PSTATE).CHANNEL,value=table,/SCROLL,X_SCROLL_SIZE=3,Y_SCROLL_SIZE=8)
    
  WIDGET_CONTROL,qBase,/REALIZE
  
  (*PSTATE).qText=qText
  (*PSTATE).qTable=qTable
  Widget_Control,event.top,set_uvalue=PSTATE
  
END

PRO REFRESH_SPECTRAL,event

  WIDGET_CONTROL,event.top,get_uvalue=PSTATE
  
  SPECTRAL=*((*PSTATE).SPECTRAL)
  x=(*PSTATE).xlabel
  y=(*PSTATE).ylabel
  sDrawID=(*PSTATE).sDrawID
  sLabelID=(*PSTATE).sLabelID
  
  cr='x: '+strtrim(string(x),2)+' y: '+strtrim(string(y),2)
  
  WIDGET_CONTROL,sLabelID,SET_VALUE=cr
  
  WIDGET_CONTROL,sDrawID,GET_VALUE=sWindow
  
  S_PLOT=obj_new('idlgrplot',SPECTRAL)
  
  ; print,SPECTRAL[1]
  xaxis=obj_new('idlgraxis',0)
  yaxis=obj_new('idlgraxis',1)
  
  S_PLOT -> getproperty,xrange=xr,yrange=yr
  if yr[0] eq yr[1] then yr[1]=yr[0]+1
  if yr[0] gt 0 then yr[0]=0
  if yr[1] lt 0 then yr[1]=0
  xaxis -> setproperty,range = xr
  yaxis -> setproperty,range = yr
  
  xtl = 0.01
  ytl = 0.01
  
  xaxis -> setproperty,ticklen = xtl
  yaxis -> setproperty,ticklen = ytl
  
  smodel = obj_new('idlgrmodel')
  sview = obj_new('idlgrview')
  
  smodel -> add,S_PLOT
  smodel -> add,xaxis
  smodel -> add,yaxis
  sview -> add,smodel
  set_view,sview,swindow
  swindow -> draw,sview
  
  obj_destroy,sview
END

PRO VIEW_SPECTRAL_PLOT,event

  WIDGET_CONTROL,event.top,get_uvalue=PSTATE
  
  SPECTRAL=*((*PSTATE).SPECTRAL)
  x=(*PSTATE).xlabel
  y=(*PSTATE).ylabel
  
  scr_dims = GET_SCREEN_SIZE()
  w_xoffset=(scr_dims[0])/1.38
  w_yoffset=(scr_dims[1]-350)/2
  
  sBase = widget_base(GROUP_LEADER=(*PSTATE).WID_BASE_TLB,/COLUMN, $
    xoffset=w_xoffset,yoffset=w_yoffset,XPAD=0,YPAD=0,title='光谱曲线' $
    ,NOTIFY_REALIZE ='')
    
  cr='x: '+strtrim(string(x),2)+' y: '+strtrim(string(y),2)
  sLabel = widget_label(sBase,value=cr,SCR_XSIZE=100)
  sDraw = widget_draw(sBase,xsize=350,ysize=270,uname='sDraw',retain=2, $
    /EXPOSE_EVENTS,/BUTTON_EVENTS,GRAPHICS_LEVEL=2)
    
  WIDGET_CONTROL,sBase,/REALIZE
  WIDGET_CONTROL,sDraw,GET_VALUE=sWindow
  
  (*PSTATE).sDrawID=sDraw
  (*PSTATE).sLabelID=sLabel
  WIDGET_CONTROL,event.top,set_uvalue=PSTATE
  
  S_PLOT=obj_new('idlgrplot',SPECTRAL)
  
  print,SPECTRAL[1]
  xaxis=obj_new('idlgraxis',0)
  yaxis=obj_new('idlgraxis',1)
  
  S_PLOT -> getproperty,xrange=xr,yrange=yr
  if yr[0] eq yr[1] then yr[1]=yr[0]+1
  if yr[0] gt 0 then yr[0]=0
  if yr[1] lt 0 then yr[1]=0
  xaxis -> setproperty,range = xr
  yaxis -> setproperty,range = yr
  
  xtl = 0.01
  ytl = 0.01
  
  xaxis -> setproperty,ticklen = xtl
  yaxis -> setproperty,ticklen = ytl
  
  smodel = obj_new('idlgrmodel')
  sview = obj_new('idlgrview')
  
  smodel -> add,S_PLOT
  smodel -> add,xaxis
  smodel -> add,yaxis
  sview -> add,smodel
  set_view,sview,swindow
  swindow -> draw,sview
  
  obj_destroy,sview
END

PRO BAND_SET_EVENT,Event

  CATCH, Error_status
  ;This statement begins the error handler:
  IF Error_status NE 0 THEN BEGIN
    PRINT, 'Error index: ', Error_status
    PRINT, 'Error message: ', !ERROR_STATE.MSG
    ;Result = DIALOG_MESSAGE(!ERROR_STATE.MSG, /CENTER)
    help, /last_message, output=errtext
    Result = DIALOG_MESSAGE(errtext, /CENTER)
    CATCH, /CANCEL
    return
  ENDIF
  
  Widget_Control,event.top,get_uvalue=PSTATE
  wTarget = (widget_info(Event.id,/NAME) eq 'TREE' ?  $
    widget_info(Event.id, /tree_root) : event.id)
    
    
  Widget_Control,(*PSTATE).WID_BASE_TLB,TLB_GET_SIZE=TLB_SIZE
  
  W_SIZE = [TLB_SIZE[0]-1,TLB_SIZE[1]-25]
  
  wWidget =  Event.top
  
  case wTarget of
  
    Widget_Info(wWidget, FIND_BY_UNAME='CONFIRM_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        red_band=widget_info((*PSTATE).RED_SELECT,/COMBOBOX_GETTEXT)
      green_band=widget_info((*PSTATE).GREEN_SELECT,/COMBOBOX_GETTEXT)
      blue_band=widget_info((*PSTATE).BLUE_SELECT,/COMBOBOX_GETTEXT)
      
      wBase = (*PSTATE).WID_BASE_TLB
      wDraw = (*PSTATE).WID_DRAW
      
      red = FIX(red_band)-1
      green = FIX(green_band)-1
      blue = FIX(blue_band)-1
      
      (*PSTATE).RED=red
      (*PSTATE).GREEN=green
      (*PSTATE).BLUE=blue
      
      IMG_FILE = (*PSTATE).imagefile
      
      PTR_IMG=(*PSTATE).PTR_IMG
      
      ;       queryStatus = query_image(IMG_FILE,imageinfo)
      
      imageSize = (*PSTATE).imageSize
      imageChannel = (*PSTATE).Channel
      
      image=fltarr(imageChannel,imageSize[0],imageSize[1],/nozero)
      
      image[*,*,*] = (*PTR_IMG)
      
      imageDims = size(image,/dimensions)
      
      if imageChannel ge 3 then begin
        band=3
        color_ramp=[red,green,blue]
      endif else begin
        band=1
        color_ramp=[0]
      endelse
      
      outimage=fltarr(band,imageSize[0],imageSize[1],/nozero)
      
      for i=0,band-1,1 do begin
        outimage[i,*,*]=255*(image[color_ramp[i],*,*]-min(image[color_ramp[i],*,*]))/ $
          (max(image[color_ramp[i],*,*])-min(image[color_ramp[i],*,*]))
      endfor
      
      interleaving = where((imageDims ne imageSize[0]) and (imageDims ne imageSize[1]))
      
      case 1 of
        imageSize[0] le 300 : begin
          w_xsize=300
        end
        imageSize[0] ge TLB_SIZE[0] : begin
          w_xsize=TLB_SIZE[0]
        end
      else : begin
        w_xsize=imageSize[0]
      end
    endcase
    
    if imageSize[1] ge TLB_SIZE[1] then begin
      w_ysize=TLB_SIZE[1]
    endif else begin
      w_ysize=imageSize[1]
    endelse
    
    ;       WIDGET_CONTROL,wBase,xsize=w_xsize
    ;       WIDGET_CONTROL,wBase,ysize=w_ysize
    
    WIDGET_CONTROL,wDraw,draw_xsize=W_SIZE[0]
    WIDGET_CONTROL,wDraw,draw_ysize=W_SIZE[1]
    ;       WIDGET_CONTROL,wDraw,draw_xsize=imageSize[0]
    ;       WIDGET_CONTROL,wDraw,draw_ysize=imageSize[1]
    
    WIDGET_CONTROL,wDraw,GET_VALUE=oWindow
    
    oWindow -> setProperty,dimensions=W_SIZE
    oView=(*PSTATE).oView
    (*PSTATE).oImage->setProperty,Data=outimage
    oImage=(*PSTATE).oImage
    
    oWindow -> Draw,oView
    
    (*PSTATE).oView=oView
    Widget_Control,event.top,set_uvalue=PSTATE
  ;       obj_destroy,oView
    
  end
  
  Widget_Info(wWidget, FIND_BY_UNAME='WID_CLOSE_BUTTON'): begin
    if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
      widget_control,event.top,/DESTROY
  end
  else:
endcase
END

PRO BAND_SET,Event

  CATCH, Error_status
  ;This statement begins the error handler:
  IF Error_status NE 0 THEN BEGIN
    PRINT, 'Error index: ', Error_status
    PRINT, 'Error message: ', !ERROR_STATE.MSG
    ;Result = DIALOG_MESSAGE(!ERROR_STATE.MSG, /CENTER)
    help, /last_message, output=errtext
    Result = DIALOG_MESSAGE(errtext, /CENTER)
    CATCH, /CANCEL
    return
  ENDIF
  
  Widget_control,event.top,get_uvalue = PSTATE
  
  CHANNEL=(*PSTATE).CHANNEL
  
  BAND = STRTRIM(string(INDGEN(CHANNEL)+1),2)
  
  scr_dims = GET_SCREEN_SIZE()
  w_xoffset=(scr_dims[0])/1.38
  w_yoffset=(scr_dims[1]-350)/2
  
  BANDSET_BASE = Widget_Base(GROUP_LEADER=(*PSTATE).WID_BASE_TLB,/COLUMN,Title='波段设置' ,TLB_FRAME_ATTR=1 $
    ,SCR_XSIZE=170,SCR_YSIZE=220,XPAD=2,YPAD=2,XOFFSET=w_xoffset,YOFFSET=w_yoffset)
    
  (*PSTATE).BANDSET_BASE=BANDSET_BASE
  
  BANDSELECT_BASE = Widget_Base(BANDSET_BASE,XOFFSET=5,YOFFSET=5,/COLUMN,/FRAME)
  
  BN_VALUE='波段数：'+STRTRIM(STRING(CHANNEL),2)
  BAND_NUM = Widget_Label(BANDSELECT_BASE,VALUE=BN_VALUE,FONT='15')
  RED_BASE = Widget_base(BANDSELECT_BASE,/ROW,XOFFSET=5)
  RED_LABEL=Widget_Label(RED_BASE,value='红波段：',SCR_XSIZE=70,FONT='15')
  RED_SELECT=Widget_Combobox(RED_BASE,value=BAND,SCR_XSIZE=50,FONT='15')
  
  Widget_Control,RED_SELECT,SET_COMBOBOX_SELECT=strtrim(string((*PSTATE).RED),2)
  
  GREEN_BASE = Widget_base(BANDSELECT_BASE,/ROW,XOFFSET=5)
  GREEN_LABEL=Widget_Label(GREEN_BASE,value='绿波段：',SCR_XSIZE=70,FONT='15')
  GREEN_SELECT=Widget_Combobox(GREEN_BASE,value=BAND,SCR_XSIZE=50,FONT='15')
  
  Widget_Control,GREEN_SELECT,SET_COMBOBOX_SELECT=strtrim(string((*PSTATE).GREEN),2)
  
  BLUE_BASE = Widget_base(BANDSELECT_BASE,/ROW,XOFFSET=5)
  BLUE_LABEL=Widget_Label(BLUE_BASE,value='蓝波段：',SCR_XSIZE=70,FONT='15')
  BLUE_SELECT=Widget_Combobox(BLUE_BASE,value=BAND,SCR_XSIZE=50,FONT='15')
  
  Widget_Control,BLUE_SELECT,SET_COMBOBOX_SELECT=strtrim(string((*PSTATE).BLUE),2)
  
  BANDCMD_BASE = Widget_Base(BANDSET_BASE,XOFFSET=5,SCR_XSIZE=154,SCR_YSIZE=30,/ROW,/FRAME,XPAD=15)
  CONFIRM_BUTTON = Widget_Button(BANDCMD_BASE,UNAME='CONFIRM_BUTTON',VALUE='确定',font='15')
  WID_CLOSE_BUTTON = Widget_Button(BANDCMD_BASE,UNAME='WID_CLOSE_BUTTON',VALUE='关闭',font='15')
  
  
  (*PSTATE).RED_SELECT=RED_SELECT
  (*PSTATE).GREEN_SELECT=GREEN_SELECT
  (*PSTATE).BLUE_SELECT=BLUE_SELECT
  
  Widget_Control,BANDSET_BASE,set_uvalue = PSTATE
  
  Widget_Control,BANDSET_BASE,get_uvalue = PSTATE
  
  Widget_Control,EVENT.TOP,SET_UVALUE=PSTATE
  Widget_Control, /REALIZE, BANDSET_BASE
  
  XManager, 'BAND_SET', BANDSET_BASE, /NO_BLOCK,EVENT_HANDLER='BAND_SET_EVENT'
  
END

FUNCTION OPEN_IMG,Event

  CATCH, Error_status
  ;This statement begins the error handler:
  IF Error_status NE 0 THEN BEGIN
    PRINT, 'Error index: ', Error_status
    PRINT, 'Error message: ', !ERROR_STATE.MSG
    ;Result = DIALOG_MESSAGE(!ERROR_STATE.MSG, /CENTER)
    help, /last_message, output=errtext
    Result = DIALOG_MESSAGE(errtext, /CENTER)
    CATCH, /CANCEL
    return,0
  ENDIF
  
  widget_control,event.top,get_uvalue=PSTATE
  
  (*PSTATE).RED=2
  (*PSTATE).GREEN=1
  (*PSTATE).BLUE=0
  widget_control,event.top,set_uvalue=PSTATE
  
  widget_control,event.top,get_uvalue=PSTATE
  
  Widget_Control,(*PSTATE).WID_BASE_TLB,TLB_GET_SIZE=TLB_SIZE
  
  W_SIZE = [TLB_SIZE[0]-1,TLB_SIZE[1]-25]
  
  wBase = (*PSTATE).WID_BASE_TLB
  wDraw = (*PSTATE).WID_DRAW
  
  IMG_FILE = PICK_FILE(event)
  if (IMG_FILE eq '') then $
    return,(*PSTATE).VIEW_STATUS
  if (file_test(IMG_FILE) EQ 0) then begin
    CAUTION = DIALOG_MESSAGE('所选择的影像不存在！',TITLE='提示',/INFORMATION)
    return,(*PSTATE).VIEW_STATUS
  endif
  
  queryStatus = query_image(IMG_FILE,imageinfo)
  
  
  if queryStatus eq 0 then begin
    CAUTION = dialog_message('输入文件不正确!',title='警告')
    return,0
  endif
  
  imageSize = imageInfo.dimensions
  imageChannel = imageInfo.channels
  
  (*PSTATE).imageSize = imageSize
  (*PSTATE).CHANNEL = imageChannel
  
  IF imageChannel GE 3 THEN BEGIN
    red = (*PSTATE).RED
    green = (*PSTATE).GREEN
    blue = (*PSTATE).BLUE
  ENDIF ELSE BEGIN
    red = 0
    green = 0
    blue = 0
    (*PSTATE).RED=0
    (*PSTATE).GREEN=0
    (*PSTATE).BLUE=0
  ENDELSE
  
  Widget_control,event.top,set_uvalue=PSTATE
  
  image=fltarr(imageChannel,imageSize[0],imageSize[1],/nozero)
  
  image[*,*,*] = read_image(IMG_FILE)
  
  if imageinfo.type eq 'TIFF'then $
    image = reverse(image,3,/overwrite)
    
  PTR_IMG = PTR_NEW(image)
  
  (*PSTATE).imagefile = IMG_FILE
  (*PSTATE).PTR_IMG=PTR_IMG
  Widget_control,event.top,set_uvalue=PSTATE
  
  imageDims = size(image,/dimensions)
  
  if imageChannel ge 3 then begin
    band=3
    color_ramp=[red,green,blue]
  endif else begin
    band=1
    color_ramp=[0]
  endelse
  
  outimage=fltarr(band,imageSize[0],imageSize[1],/nozero)
  
  for i=0,band-1,1 do begin
    outimage[i,*,*]=255*(image[color_ramp[i],*,*]-min(image[color_ramp[i],*,*]))/ $
      (max(image[color_ramp[i],*,*])-min(image[color_ramp[i],*,*]))
  endfor
  
  interleaving = where((imageDims ne imageSize[0]) and (imageDims ne imageSize[1]))
  
  case 1 of
    imageSize[0] le 300 : begin
      w_xsize=300
    end
    imageSize[0] ge TLB_SIZE[0] : begin
      w_xsize=TLB_SIZE[0]
    end
  else : begin
    w_xsize=imageSize[0]
  end
endcase

if imageSize[1] ge TLB_SIZE[1] then begin
  w_ysize=TLB_SIZE[1]
endif else begin
  w_ysize=imageSize[1]
endelse

WIDGET_CONTROL,wDraw,draw_xsize=W_SIZE[0]
WIDGET_CONTROL,wDraw,draw_ysize=W_SIZE[1]

WIDGET_CONTROL,wDraw,GET_VALUE=oWindow

oWindow -> setProperty,dimensions=W_SIZE

oView = obj_new('idlgrview',viewplane_rect=[0.,0.,W_SIZE],color=[255,255,255]);设置显示图背景色
oModel = obj_new('idlgrmodel',name='oModel')
oImage = obj_new('idlgrimage',outimage,interleave=interleaving[0])

oRectModal = obj_new('IDLgrModel',name='oRectModal', SELECT_TARGET=1)
oRectline = OBJ_NEW('IDLgrPolygon',[0,0,0,0],[0,0,0,0],STYLE=1, $
  color=[0,0,0],THICK=1,LINESTYLE=0,name='oRectline',HIDE=1);设置缩放影像线框的颜色
oRectModal -> add,oRectline

oModel -> add,oImage
oView -> add,oModel
oView -> add,oRectModal
oWindow -> Draw,oView

(*PSTATE).oView=oView
(*PSTATE).oImage=oImage
Widget_Control,event.top,set_uvalue=PSTATE

; obj_destroy,oView

return,1

END

FUNCTION CLEAR_IMG,EVENT

  CATCH, Error_status
  ;This statement begins the error handler:
  IF Error_status NE 0 THEN BEGIN
    PRINT, 'Error index: ', Error_status
    PRINT, 'Error message: ', !ERROR_STATE.MSG
    ;Result = DIALOG_MESSAGE(!ERROR_STATE.MSG, /CENTER)
    help, /last_message, output=errtext
    Result = DIALOG_MESSAGE(errtext, /CENTER)
    CATCH, /CANCEL
    return,0
  ENDIF
  
  WIDGET_CONTROL,event.top,get_uvalue=PSTATE
  Widget_Control,(*PSTATE).WID_BASE_TLB,TLB_GET_SIZE=TLB_SIZE
  
  W_SIZE = [TLB_SIZE[0]-1,TLB_SIZE[1]-25]
  
  wDraw = (*PSTATE).WID_DRAW
  WIDGET_CONTROL,wDraw,GET_VALUE=oWindow
  oView = obj_new('idlgrview',viewplane_rect=[0.,0.,W_SIZE],color=[255,255,255]);设置显示图背景色
  
  oWindow -> Draw,oView
  
END

PRO COMMON_VIEWER_EVENT,Event

  CATCH, Error_status
  ;This statement begins the error handler:
  IF Error_status NE 0 THEN BEGIN
    PRINT, 'Error index: ', Error_status
    PRINT, 'Error message: ', !ERROR_STATE.MSG
    ;Result = DIALOG_MESSAGE(!ERROR_STATE.MSG, /CENTER)
    help, /last_message, output=errtext
    Result = DIALOG_MESSAGE(errtext, /CENTER)
    CATCH, /CANCEL
    return
  ENDIF
  
  WIDGET_CONTROL,event.top,get_uvalue=PSTATE
  
  wTarget = (widget_info(Event.id,/NAME) eq 'TREE' ?  $
    widget_info(Event.id, /tree_root) : event.id)
    
  wWidget =  Event.top
  
  Widget_Control,(*PSTATE).WID_BASE_TLB,TLB_GET_SIZE=TLB_SIZE
  
  if (TLB_SIZE[0] le 64) or TLB_SIZE[1] le 64 then $
    return
    
  W_SIZE = [TLB_SIZE[0]-1,TLB_SIZE[1]-25]
  
  Draw_ID = (*PSTATE).WID_DRAW
  Widget_Control,(*PSTATE).WID_BASE_DRAW,XSIZE=W_SIZE[0]
  Widget_Control,(*PSTATE).WID_BASE_DRAW,XSIZE=W_SIZE[1]
  
  WIDGET_CONTROL,Draw_ID,GET_VALUE=oWindow
  oWindow -> setProperty,dimensions=W_SIZE
  
  if  (*PSTATE).VIEW_STATUS eq 0 then begin
    Widget_Control,Draw_ID,XSIZE=W_SIZE[0]
    Widget_Control,Draw_ID,YSIZE=W_SIZE[1]
  endif else begin
    (*PSTATE).oView -> setProperty,viewplane_rect=[0.,0.,W_SIZE]
    oWindow -> Draw,(*PSTATE).oView
  endelse
  
  case wTarget of
  
    Widget_Info(wWidget, FIND_BY_UNAME='OpenIMG'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
      
        VIEW_STATUS = OPEN_IMG(Event)
      (*PSTATE).VIEW_STATUS=VIEW_STATUS
      
      WIDGET_CONTROL,EVENT.TOP,SET_UVALUE=PSTATE
      common_log,'打开影像'
    end
    Widget_Info(wWidget, FIND_BY_UNAME='add_btn'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        if widget_info((*PSTATE).BANDSET_BASE,/valid_id) eq 1 then $
        widget_control,(*PSTATE).BANDSET_BASE,/DESTROY
        
      VIEW_STATUS = OPEN_IMG(Event)
      (*PSTATE).VIEW_STATUS=VIEW_STATUS
      
      WIDGET_CONTROL,EVENT.TOP,SET_UVALUE=PSTATE
      common_log,'打开影像'
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='clear_btn'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        if widget_info((*PSTATE).BANDSET_BASE,/valid_id) eq 1 then $
        widget_control,(*PSTATE).BANDSET_BASE,/DESTROY
        
      VIEW_STATUS = CLEAR_IMG(Event)
      (*PSTATE).VIEW_STATUS=VIEW_STATUS
      
      WIDGET_CONTROL,EVENT.TOP,SET_UVALUE=PSTATE
      common_log,'清除影像'
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='reset_btn'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        if ((*PSTATE).VIEW_STATUS eq 1) then begin
        FULL_EXTENT,event
        common_log,'查看全景影像'
      endif
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='Band_Setting'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        if (*PSTATE).VIEW_STATUS eq 0 then begin
        CAUTION = DIALOG_MESSAGE('请先打开一幅影像！',TITLE='提示',/INFORMATION)
      endif else begin
        if widget_info((*PSTATE).BANDSET_BASE,/valid_id) eq 0 then begin
          BAND_SET,Event
          common_log,'进行影像显示的波段设置'
        endif
      endelse
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='arrow_btn'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        oWindow->SetCurrentCursor, 'CROSSHAIR'
      (*PSTATE).CURSOR_STATE=0
      Widget_Control,EVENT.TOP,set_uvalue=PSTATE
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='ZOOM_IN_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        oWindow->SetCurrentCursor, 'ZoomIn'
        ;oWindow->SetCurrentCursor, 'ORIGINAL'
      (*PSTATE).CURSOR_STATE=1
      button_id=Widget_Info(wWidget, FIND_BY_UNAME='zin_btn')
      Widget_Control,button_id,set_button=1
      Widget_Control,EVENT.TOP,set_uvalue=PSTATE
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='zin_btn'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        oWindow->SetCurrentCursor, 'ZoomIn'
        ;oWindow->SetCurrentCursor, 'UP_ARROW'
      (*PSTATE).CURSOR_STATE=1
      Widget_Control,EVENT.TOP,set_uvalue=PSTATE
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='ZOOM_OUT_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        oWindow->SetCurrentCursor, 'ZoomOut'
      (*PSTATE).CURSOR_STATE=2
      button_id=Widget_Info(wWidget, FIND_BY_UNAME='zout_btn')
      Widget_Control,button_id,set_button=1
      Widget_Control,EVENT.TOP,set_uvalue=PSTATE
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='zout_btn'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        oWindow->SetCurrentCursor, 'ZoomOut'
      (*PSTATE).CURSOR_STATE=2
      Widget_Control,EVENT.TOP,set_uvalue=PSTATE
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='ROAM_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        oWindow->SetCurrentCursor, 'Hand'
      (*PSTATE).CURSOR_STATE=3
      button_id=Widget_Info(wWidget, FIND_BY_UNAME='roam_btn')
      Widget_Control,button_id,set_button=1
      Widget_Control,EVENT.TOP,set_uvalue=PSTATE
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='roam_btn'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        oWindow->SetCurrentCursor, 'Hand'
      (*PSTATE).CURSOR_STATE=3
      Widget_Control,EVENT.TOP,set_uvalue=PSTATE
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='zoomin_btn'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        (*PSTATE).scale=1.2
      Widget_Control,EVENT.TOP,set_uvalue=PSTATE
      if ((*PSTATE).VIEW_STATUS eq 1) then begin
        SCALE_ZOOM_IMAGE,EVENT
      endif
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='zoomout_btn'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        (*PSTATE).scale=0.8
      Widget_Control,EVENT.TOP,set_uvalue=PSTATE
      if ((*PSTATE).VIEW_STATUS eq 1) then begin
        SCALE_ZOOM_IMAGE,EVENT
      endif
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='query_btn'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        if ((*PSTATE).VIEW_STATUS eq 1) then begin
        if widget_info((*PSTATE).qTable,/valid_id) eq 0 then begin
          QUERY_INFO,EVENT
        endif
      endif
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='WID_DRAW'): begin ;绘图区操作
    
      ;     GEOMETRY = WIDGET_INFO((*PSTATE).WID_DRAW, /GEOMETRY)
    
      if ((*PSTATE).VIEW_STATUS eq 1) then begin
        ;获取显示影像所对应实际坐标
        oView=(*PSTATE).oView
        oImageModal = oView->GetByName('oModel')
        oImageModal -> GetProperty, TRANSFORM=matrix
        xlabel = (event.x - matrix[3,0]) / matrix[0,0]
        ylabel = (event.y - matrix[3,1]) / matrix[1,1]
        
        oRectline = (*PSTATE).oView->GetByName('oRectModal/oRectline')
        
      ;       image_x_cor = xlabel - (*PSTATE).start_x
      ;       image_y_cor = ylabel - (*PSTATE).start_y
        
      ;       PRINT,xlabel,ylabel,image_x_cor,image_y_cor,(*PSTATE).start_x,(*PSTATE).start_y
      endif
      
      if( event.press gt 0 ) and ((*PSTATE).VIEW_STATUS eq 1) then begin
        widget_control,event.id,draw_motion_events=1
        (*PSTATE).moveable=1
        (*PSTATE).x=event.x
        (*PSTATE).y=event.y
        
        if (PTR_VALID((*PSTATE).PTR_IMG) eq 1) then begin
          if (xlabel ge 0) and (xlabel lt (*PSTATE).imageSize[0]) and (ylabel ge 0) and (ylabel lt (*PSTATE).imageSize[1]) then begin
            (*PSTATE).SPECTRAL=PTR_NEW((*(*PSTATE).PTR_IMG)[*,xlabel,ylabel])
          endif else begin
            (*PSTATE).SPECTRAL=PTR_NEW(fltarr((*PSTATE).CHANNEL))
          endelse
        endif
        
        (*PSTATE).xlabel=xlabel
        (*PSTATE).ylabel=ylabel
        widget_control,event.top,set_uvalue=PSTATE
        
        if widget_info((*PSTATE).sDrawID,/valid_id) eq 1 then begin
          REFRESH_SPECTRAL,event
        endif
        
        if widget_info((*PSTATE).qTable,/valid_id) eq 1 then begin
          REFRESH_TABLE,event
        endif
        
        if ((*PSTATE).CURSOR_STATE eq 1) or ((*PSTATE).CURSOR_STATE eq 2) then begin
          (*PSTATE).moveable = 1
          oRectline -> SetProperty,hide=0
          rect=[[0,0,0,0], [0,0,0,0]]
          rect = transpose(rect)
          oRectline -> SetProperty, DATA=rect
          (*PSTATE).x = event.x
          (*PSTATE).y = event.y
          widget_control, event.top, set_uvalue = PSTATE
        endif
        
      endif
      
      if ((*PSTATE).CURSOR_STATE eq 3) and ((*PSTATE).moveable eq 1) and $
        ((*PSTATE).VIEW_STATUS eq 1)then begin
        
        xoffset = event.x - (*PSTATE).x
        yoffset = event.y - (*PSTATE).y
        (*PSTATE).start_x += xoffset
        (*PSTATE).start_y += yoffset
        
        oView=(*PSTATE).oView
        oImageModal = oView->GetByName('oModel')
        oImageModal->Translate, xoffset, yoffset, 0
        oWindow -> Draw,oView
        (*PSTATE).x = event.x
        (*PSTATE).y = event.y
        
        Widget_Control,event.top,set_uvalue=PSTATE
        
      endif
      
      if (((*PSTATE).CURSOR_STATE eq 1) or ((*PSTATE).CURSOR_STATE eq 2)) and $
        ((*PSTATE).moveable eq 1)and ((*PSTATE).VIEW_STATUS eq 1)then begin
        
        rect = [[(*PSTATE).x, (*PSTATE).x, event.x, event.x], $
          [(*PSTATE).y, event.y, event.y,(*PSTATE).y]]
        rect = transpose(rect)
        oRectline -> SetProperty, DATA=rect
        
        oWindow->Draw, (*PSTATE).oView
        
      endif
      
      if( event.press eq 4 )then begin
        widget_control,event.id,draw_motion_events=0
        
        contextBase=widget_info(event.top,find_by_uname='CONTEXT_BASE')
        widget_displaycontextmenu,event.id,event.x,event.y,contextBase
        
      endif
      
      if( event.release eq 1 )and ((*PSTATE).VIEW_STATUS eq 1)then begin
      
        widget_control,event.id,draw_motion_events=0
        
        if (((*PSTATE).cursor_state eq 1) or ((*PSTATE).cursor_state eq 2)) then begin
          RECT_ZOOM_IMAGE,event
          POINT_ZOOM_IMAGE,event
        endif
        
        (*PSTATE).x=0
        (*PSTATE).y=0
        (*PSTATE).moveable=0
        
        Widget_control,event.top,set_uvalue=PSTATE
      endif
      
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='VIEW_SPECTRAL'): begin
      if widget_info((*PSTATE).sDrawID,/valid_id) eq 0 then begin
        if (*PSTATE).VIEW_STATUS ne 0 then begin
          if (*PSTATE).CHANNEL gt 1 then begin
            VIEW_SPECTRAL_PLOT,event
            common_log,'显示影像的光谱曲线'
          endif else begin
            CAUTION = DIALOG_MESSAGE('所选影像少于两个波段！',TITLE='提示',/INFORMATION)
          endelse
        endif else begin
          CAUTION = DIALOG_MESSAGE('窗口中无影像！',TITLE='提示',/INFORMATION)
        endelse
      endif
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='HELP_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then begin
        common_log,'打开帮助文档'
        if file_test('HELP\HELP.chm') then begin
          ONLINE_HELP,'图像显示',BOOK='HELP\HELP.chm', /FULL_PATH
        endif else begin
          info_help=dialog_message('找不到帮助文档',title='警告')
        endelse
      endif
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='ExitProgram'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        common_log,'关闭影像显示窗口'
      PTR_FREE,PSTATE
      HEAP_GC, /VERBOSE
      widget_control,event.top,/DESTROY
    end
    else:
  endcase
  
  IF TAG_NAMES(event, /STRUCTURE_NAME) EQ 'WIDGET_KILL_REQUEST' THEN BEGIN
    common_log,'关闭影像显示窗口'
    PTR_FREE,PSTATE
    HEAP_GC, /VERBOSE
    widget_control,event.top,/DESTROY
  ENDIF
  
END

PRO COMMON_VIEWER,w_xoffset,w_yoffset,Message=Message;窗口显示位置
  common_log,'启动影像显示窗口'
  ;程序路径
  apppath = routine_filepath('COMMON_VIEWER')
  apppath = file_dirname(apppath)
  ;设置程序初始位置
;  scr_dims = GET_SCREEN_SIZE()
;  w_xoffset=(scr_dims[0]-350)/2
;  w_yoffset=(scr_dims[1]-350)/2
  
  WID_BASE_TLB = Widget_Base( /COLUMN,UNAME='WID_BASE_TLB' ,XOFFSET=w_xoffset ,YOFFSET=w_yoffset $
    ,TITLE='图像显示',XPAD=0,YPAD=0,xsize=500,ysize=400,MBAR=SYSTEMMENUBAR,/TLB_KILL_REQUEST_EVENTS,/TLB_SIZE_EVENTS)
    
  ;文件菜单
  WID_BUTTON_FILE = Widget_Button(SYSTEMMENUBAR,UNAME='WID_BUTTON_FILE' ,SCR_XSIZE=45 ,SCR_YSIZE=25  $
    ,/ALIGN_CENTER ,VALUE='文件(&F)')
  OpenIMG = widget_button(WID_BUTTON_FILE,value = '打开(&O)',uname='OpenIMG')
  
  ExitProgram = widget_button(WID_BUTTON_FILE,value = '关闭(&C)',uname='ExitProgram')
  
  ;查看菜单
  WID_BUTTON_VIEW = Widget_Button(SYSTEMMENUBAR,UNAME='WID_BUTTON_VIEW' ,SCR_XSIZE=45 ,SCR_YSIZE=25  $
    ,/ALIGN_CENTER ,VALUE='查看(&V)')
  Band_Setting = widget_button(WID_BUTTON_VIEW,value = '波段设置(&B)',uname='Band_Setting')
  
  ;工具菜单
  WID_BUTTON_TOOLS = Widget_Button(SYSTEMMENUBAR,UNAME='WID_BUTTON_TOOLS' ,SCR_XSIZE=45 ,SCR_YSIZE=25  $
    ,/ALIGN_CENTER ,VALUE='工具(&T)')
  ZOOM_IN_BUTTON = widget_button(WID_BUTTON_TOOLS,value = '放大(&I)',uname='ZOOM_IN_BUTTON')
  ZOOM_OUT_BUTTON = widget_button(WID_BUTTON_TOOLS,value = '缩小(&O)',uname='ZOOM_OUT_BUTTON')
  ROAM_BUTTON = widget_button(WID_BUTTON_TOOLS,value = '漫游(&P)',uname='ROAM_BUTTON')
  
  ;帮助菜单
  ; WID_BUTTON_HELP = Widget_Button(SYSTEMMENUBAR,UNAME='WID_BUTTON_HELP' ,SCR_XSIZE=45 ,SCR_YSIZE=25  $
  ;      ,/ALIGN_CENTER ,VALUE='帮助(&H)')
  ;      HELP_BUTTON = widget_button(WID_BUTTON_HELP,value = '显示窗口帮助(&H)',uname='HELP_BUTTON')
  
  ;工具栏
  WID_BASE_TOOLS = Widget_Base(WID_BASE_TLB,/ROW,/TOOLBAR,XPAD=3,YPAD=0,SPACE=0)
  add_btn = widget_button(WID_BASE_TOOLS, TOOLTIP='打开影像', uname='add_btn',VALUE='打开')
  clear_btn = widget_button(WID_BASE_TOOLS, TOOLTIP='清除', uname='clear_btn', VALUE='清除')
  reset_btn = widget_button(WID_BASE_TOOLS, TOOLTIP='全景', uname='reset_btn', VALUE='全景')
  zoomin_btn = widget_button(WID_BASE_TOOLS, TOOLTIP='固定放大', uname='zoomin_btn', VALUE='放大')
  zoomout_btn = widget_button(WID_BASE_TOOLS, TOOLTIP='固定缩小', uname='zoomout_btn',  VALUE='缩小')
  query_btn = widget_button(WID_BASE_TOOLS, TOOLTIP='查看', uname='query_btn',  VALUE='查看')
  
  WID_BASE_Ratio = Widget_Base(WID_BASE_TOOLS,/ROW,/TOOLBAR,/Exclusive,XPAD=0,YPAD=0)
  arrow_btn = widget_button(WID_BASE_Ratio, TOOLTIP='指针', uname='arrow_btn',  VALUE='指针')
  roam_btn = widget_button(WID_BASE_Ratio, TOOLTIP='漫游', uname='roam_btn', VALUE='漫游')
  zin_btn = widget_button(WID_BASE_Ratio, TOOLTIP='放大', uname='zin_btn',  VALUE='放大')
  zout_btn = widget_button(WID_BASE_Ratio, TOOLTIP='缩小', uname='zout_btn',  VALUE='缩小')
  
  WID_BASE_DRAW = Widget_Base(WID_BASE_TLB,/COLUMN,XPAD=0,YPAD=0)
  
  WID_DRAW = widget_draw(WID_BASE_DRAW,xsize=500,ysize=400,uname='WID_DRAW',retain=2, $
    /EXPOSE_EVENTS,/BUTTON_EVENTS,GRAPHICS_LEVEL=2)
    
  CONTEXT_BASE = widget_base(WID_BASE_Draw,/context_menu,uname='CONTEXT_BASE')
  VIEW_SPECTRAL = widget_button(CONTEXT_BASE,value='显示光谱曲线',uname='VIEW_SPECTRAL')
  
  WINFO = {   WID_BASE_TLB  : WID_BASE_TLB , $
    WID_BASE_DRAW : WID_BASE_DRAW , $
    WID_DRAW  : WID_DRAW , $
    VIEW_STATUS : 0 , $
    imageSize : [0,0] , $
    CHANNEL : 0 , $
    RED_BAND  : 0, $
    GREEN_BAND  : 0,  $
    BLUE_BAND : 0,  $
    BANDSET_BASE  : 0, $
    CONFIRM_BUTTON  : 0 , $
    WID_CLOSE_BUTTON  : 0 , $
    RED : 2 , $
    GREEN : 1 , $
    BLUE  : 0 , $
    imagefile : '' , $
    PTR_IMG : PTR_NEW(/NO_COPY) , $
    SPECTRAL  : PTR_NEW(/NO_COPY) , $
    RED_SELECT  : 0 , $
    GREEN_SELECT  :  0 , $
    BLUE_SELECT : 0 , $
    x : 0 , $
    y : 0 , $
    sDrawID : 0 , $
    sLabelID  : 0 , $
    qTable  : 0 , $
    qText : 0 , $
    CURSOR_STATE  : 0 , $
    oView : obj_new() , $
    oImage  : obj_new() , $
    moveable  : 0 , $
    start_x : 0 , $
    start_y : 0 , $
    xlabel  : 0 , $
    ylabel  : 0 , $
    scale : 1.0 $
    }
  PSTATE = PTR_NEW(WINFO,/NO_COPY)
  
 ;注册鼠标文件
  cursor_hand = CURSORCREATE(/normhand)
  REGISTER_CURSOR, 'Hand', cursor_hand, HOTSPOT=hotspot, MASK=mask
  cursor_ZoomIn = CURSORCREATE(/magic)
  REGISTER_CURSOR, 'ZoomIn', cursor_ZoomIn, HOTSPOT=hotspot, MASK=mask
  cursor_ZoomOut = CURSORCREATE(/magic)
  REGISTER_CURSOR, 'ZoomOut', cursor_ZoomOut, HOTSPOT=hotspot, MASK=mask
  
  WIDGET_CONTROL, WID_BASE_TLB,SET_UVALUE=PSTATE

  Widget_Control,/REALIZE,WID_BASE_TLB
  
  ; Widget_Control,(*PSTATE).WID_BASE_TLB,TLB_GET_SIZE=TLB_SIZE
  ; W_SIZE = [TLB_SIZE[0]-1,TLB_SIZE[1]-25]
  ; WIDGET_CONTROL,WID_DRAW,GET_VALUE=oWindow
  ; oView = obj_new('idlgrview',viewplane_rect=[0.,0.,W_SIZE],color=[255,255,255]);设置显示图背景色
  ; oWindow -> Draw,oView
  ; (*PSTATE).oView=oView
  ; Widget_Control,WID_BASE_TLB,set_uvalue=PSTATE
    ;Message='a'
  XManager, 'COMMON_VIEWER', WID_BASE_TLB, /NO_BLOCK
  
END
pro Common_log,operation_text

  log_text=string(systime())+' '+operation_text
  log_file='.\common_log.txt'
  
  openw,lun,log_file,/get_lun,/append
  printf,lun,log_text
  free_lun,lun
  
end
