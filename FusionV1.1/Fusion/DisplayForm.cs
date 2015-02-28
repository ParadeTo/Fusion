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
namespace Fusion
{
    public partial class DisplayForm : Form
    {
        private MainForm fMai;
        public DisplayForm()
        {
            InitializeComponent();
        }
        public DisplayForm(MainForm fMai)
            : this()
        {
            this.fMai = fMai;
        }
        private void DisplayForm_Load(object sender, EventArgs e)
        {
            System.Drawing.Point pBtn = fMai.pDisplayBtn;
            System.Drawing.Point pMain = fMai.Location;
            int HeightMainForm = fMai.Size.Height;
            int x = (System.Windows.Forms.SystemInformation.WorkingArea.Width - this.Size.Width) / 2;
            this.Location = new System.Drawing.Point(x, pMain.Y + pBtn.Y + HeightMainForm + 8);
        }

        //图层操作
        public ILayer TOCRightLayer;
        esriTOCControlItem itemType = esriTOCControlItem.esriTOCControlItemNone;
        IBasicMap basicMap = null;
        ILayer layer = null;
        object unk = null;
        object data = null;
        private void ToolStripMenuItemRemove_Click(object sender, EventArgs e)
        {
            this.axMapControl1.Map.DeleteLayer(this.TOCRightLayer);
            this.axTOCControl1.Update();
        }

        private void axTOCControl1_OnMouseDown(object sender, ITOCControlEvents_OnMouseDownEvent e)
        {
            this.axTOCControl1.HitTest(e.x, e.y, ref itemType, ref basicMap, ref layer, ref unk, ref data);
            if (e.button == 2)//单击右键
            {
                switch (itemType)
                {
                    case esriTOCControlItem.esriTOCControlItemLayer://右键为内容框的图层
                        this.TOCRightLayer = layer;//记下所单击的layer
                        this.contextMenuStrip1.Show(this.axTOCControl1, e.x, e.y);
                        break;
                    //case esriTOCControlItem.esriTOCControlItemMap:
                    //    this.contextMenuTOCMap.Show(this.axTOCControl1, e.x, e.y);
                    //    break;

                }
            }
        }

        private void ToolStripMenuItemDisplay_Click(object sender, EventArgs e)
        {
            if (this.TOCRightLayer is IRasterLayer)
            {
                DisplayBandComForm vDisplayBandComFrom = new DisplayBandComForm(this.axTOCControl1,
                this.axMapControl1,this.TOCRightLayer as IRasterLayer);
                vDisplayBandComFrom.Show();
            }

        }
    }
}
