using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using ESRI.ArcGIS.Controls;
using ESRI.ArcGIS.SystemUI;
using ESRI.ArcGIS.Carto;
using ESRI.ArcGIS.esriSystem;
using ESRI.ArcGIS.Geodatabase;
using ESRI.ArcGIS.Geometry;
using ESRI.ArcGIS.DataSourcesRaster;
using RenderColor;
using ESRI.ArcGIS.Display;
namespace Fusion
{

    public partial class DisplayBandComForm : Form
    {
        private IRasterLayer TOCRightLayer;//鼠标点击的图层
        private AxTOCControl axTOCControl;//主显示窗口的map控件
        private AxMapControl axMapControl;//主显示窗口的toc控件
        private int nBand;//波段数
        private int grayPos = 0; //进行灰度显示的波段索引
        private int[] rgbPos = new int[3] { 0, 1, 2 };//RGB合成时候选中的波段数POS
        private esriRasterStretchTypesEnum stretchType;
        public DisplayBandComForm()
        {
            InitializeComponent();
        }
        public DisplayBandComForm(AxTOCControl axTOCControl, AxMapControl axMapControl, IRasterLayer TOCRightLayer)
            : this()
        {
            this.TOCRightLayer = TOCRightLayer;
            this.axMapControl = axMapControl;
            this.axTOCControl = axTOCControl;
        }
        private void radioButton1_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void radioButton2_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void label1_Click_1(object sender, EventArgs e)
        {

        }

        private void DisplayBandComForm_Load(object sender, EventArgs e)
        {
            //初始化拉伸方法
            List<string> temp = new List<string>();
            temp.Add("直方图均衡化");
            temp.Add("标准差");
            temp.Add("最大最小值");
            temp.Add("百分比截断");
            this.comBox_StretchType.DataSource = temp;
            this.comBox_StretchType.SelectedIndex = 0;
            this.stretchType = esriRasterStretchTypesEnum.esriRasterStretch_NONE;
            //根据波段数显示不同界面
            this.nBand = TOCRightLayer.BandCount;
            if (this.nBand == 1)
            {
                this.panel_multi.Visible = false;
                this.panel_single.Visible = true;
            }
            else
            {
                List<string> bandnames = new List<string>();
                bandnames = getBandName(TOCRightLayer);
                addToCombox(this.comBox_B, bandnames);
                addToCombox(this.comBox_G, bandnames);
                addToCombox(this.comBox_R, bandnames);
                this.panel_single.Visible = false;
                this.panel_multi.Visible = true;
            }

        }
        private List<string> getBandName(IRasterLayer pRLayer)
        {
            try
            {
                string fullPath = pRLayer.FilePath;
                IRasterDataset rasterDataset = OpenFileRasterDataset(fullPath);
                IRasterBandCollection pRBCollection = rasterDataset as IRasterBandCollection;
                List<string> lstring = new List<string>();
                for (int i = 0; i < pRLayer.BandCount; i++)
                {
                    IRasterBand pRBand = pRBCollection.Item(i);
                    lstring.Add(pRBand.Bandname);
                }
                return lstring;
            }
            catch
            {
                return null;
            }
        }
        private static IRasterDataset OpenFileRasterDataset(string fullpath)
        {
            try
            {
                IWorkspaceFactory WorkspaceFactory = new RasterWorkspaceFactoryClass();
                string filePath = System.IO.Path.GetDirectoryName(fullpath);
                string fileName = System.IO.Path.GetFileName(fullpath);
                IWorkspace Workspace = WorkspaceFactory.OpenFromFile(filePath, 0);
                IRasterWorkspace rasterWorkspace = (IRasterWorkspace)Workspace;
                IRasterDataset rasterSet = (IRasterDataset)rasterWorkspace.OpenRasterDataset(fileName);
                return rasterSet;
            }
            catch
            {
                return null;
            }
        }
        private void addToCombox(ComboBox cb, List<string> bandName)
        {
            cb.Text = "";
            cb.Items.Clear();
            foreach (string name in bandName)
            {
                cb.Items.Add(name);
            }
        }

        private void btn_Display_Click(object sender, EventArgs e)
        {
            switch (this.comBox_StretchType.SelectedValue.ToString())
            {
                case "直方图均衡化":
                    this.stretchType = esriRasterStretchTypesEnum.esriRasterStretch_HistogramEqualize;
                    break;
                case "标准差":
                    this.stretchType = esriRasterStretchTypesEnum.esriRasterStretch_StandardDeviations;
                    break;
                case "最大最小值":
                    this.stretchType = esriRasterStretchTypesEnum.esriRasterStretch_MinimumMaximum;
                    break;
                case "百分比截断":
                    this.stretchType = esriRasterStretchTypesEnum.esriRasterStretch_PercentMinimumMaximum;
                    break;
            }

            if (this.nBand == 1)//单波段拉伸显示
            {
                drawImage(this.TOCRightLayer.Name.ToString(), this.axMapControl.Extent);
                this.axMapControl.Refresh();
                this.axTOCControl.Refresh();
            }
            else
            {
                //如果选择的不够三个波段，无法进行彩色合成
                if (this.comBox_B.Text.Length == 0 || this.comBox_G.Text.Length == 0 || this.comBox_R.Text.Length == 0)
                {
                    MessageBox.Show("请选择进行彩色合成的波段！", "错误", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }
                this.rgbPos[0] = this.comBox_R.SelectedIndex;
                this.rgbPos[1] = this.comBox_G.SelectedIndex;
                this.rgbPos[2] = this.comBox_B.SelectedIndex;

                drawImage(this.TOCRightLayer.Name.ToString(), this.axMapControl.Extent);
                this.axMapControl.Refresh();
                this.axTOCControl.Refresh();
            }
        }     
        //波段合成影像
        private void drawImage(string file, IEnvelope extent)
        {
            ILayer pLayer;
            if (nBand > 1)//多波段
            {
                pLayer = RasterRenderedLayer(this.TOCRightLayer, true, 0, rgbPos);

            }
            else//单波段
            {
                pLayer = RasterRenderedLayer(this.TOCRightLayer, false, 0, null);
            }
            //更新显示
            if (axMapControl.LayerCount == 0)
            {
                this.axMapControl.AddLayer(pLayer);
            }
            else
            {
                bool flag = false;
                for (int i = 0; i < axMapControl.LayerCount; i++)
                {
                    if (pLayer.Name.ToString() == axMapControl.get_Layer(i).Name.ToString())
                    {
                        flag = true;
                        break;
                    }
                }
                if (!flag)
                {
                    this.axMapControl.AddLayer(pLayer);
                }
                else
                {
                    for (int i = 0; i < axMapControl.LayerCount; i++)
                    {
                        if (pLayer.Name == axMapControl.get_Layer(i).Name)
                        {
                            this.axMapControl.DeleteLayer(i);
                            this.axMapControl.AddLayer(pLayer);
                        }
                    }
                }
            }
            this.axMapControl.Extent = ((pLayer as IRasterLayer).Raster as IGeoDataset).Extent;
        }
        public IRasterLayer RasterRenderedLayer(IRasterLayer pRL, bool renderType, int grayBandIndex, int[] rgbBandIndex)
        {
            //实例新的栅格图层
            IRasterLayer rlayer = new RasterLayerClass();
            string fullPath = pRL.FilePath;
            IRasterDataset rasterDataset = OpenFileRasterDataset(fullPath);
            //单波段
            if (rgbBandIndex == null)
            {
                //如果grayBandIndex=-1
                try
                {
                    //定义拉伸颜色条
                    IRgbColor pFromColor = new RgbColorClass();
                    pFromColor.Red = this.userControl_Color1.FromColor.R;
                    pFromColor.Green = this.userControl_Color1.FromColor.G;
                    pFromColor.Blue = this.userControl_Color1.FromColor.B;
                    IRgbColor pToColor = new RgbColorClass();
                    pToColor.Red = this.userControl_Color1.ToColor.R;
                    pToColor.Green = this.userControl_Color1.ToColor.G;
                    pToColor.Blue = this.userControl_Color1.ToColor.B;
                    IRasterRenderer render = null;
                    render = BandCombinationShow.StretchRenderer(rasterDataset, grayBandIndex,this.stretchType,pFromColor,pToColor);
                    rlayer.CreateFromDataset(rasterDataset);
                    rlayer.Renderer = render as IRasterRenderer;
                    return rlayer;
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.ToString());
                    return null;
                }
            }
            else//多波段显示
            {

                try
                {
                    //设置彩色合成顺序 生成新的渲染模式
                    IRasterRGBRenderer render = new RasterRGBRendererClass();
                    render.RedBandIndex = rgbBandIndex[0];
                    render.GreenBandIndex = rgbBandIndex[1];
                    render.BlueBandIndex = rgbBandIndex[2];

                    IRasterStretch stretchType = (IRasterStretch)render;
                    stretchType.StretchType = this.stretchType;
                    stretchType.StandardDeviationsParam = 2;


                    rlayer.CreateFromDataset(rasterDataset);
                    rlayer.Renderer = render as IRasterRenderer;
                    return rlayer;

                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.ToString());
                    return null;
                }
            }
        }
    }
}
