using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;

namespace Fusion
{
    public partial class TSFusionForm : Form
    {
        private MainForm fMai;
        List<string> lowFiles = new List<string>();
        List<string> HighFiles = new List<string>();

        public TSFusionForm()
        {
            InitializeComponent();
        }
        public TSFusionForm(MainForm fMai)
            : this()
        {
            this.fMai = fMai;
            //禁用高分辨率文件打开按钮
            this.btn_InPutFile_High.Visible = false;
            //禁用打开文件路径按钮
            this.btn_OpenOutputPath.Visible = false;
            //初始化窗口大小下拉菜单
            //融合方法
            List<string> cbxString = new List<string>();
            cbxString.Add(string.Format("STARFM"));
            cbxString.Add(string.Format("ESTARFM"));
            cbxString.Add(string.Format("STAVFM"));
            this.cbx_Method.DataSource = cbxString;
            this.cbx_Method.SelectedIndex = 0;
            //初始化窗口大小下拉菜单
            List<string> cbxString1 = new List<string>();
            for (int i = 0; i < 8; i++)
            {
                int WinSize = i * 2 + 3;
                cbxString1.Add(string.Format("{0}", WinSize));
            }
            this.cbx_WinSize.DataSource = cbxString1;
            this.cbx_WinSize.SelectedIndex = 0;
            //初始化基准影像搜索窗口
            traBar_TWinSize.Minimum = 1;
            traBar_TWinSize.Maximum = 48;
            traBar_TWinSize.TickFrequency = 5;
            traBar_TWinSize.SmallChange = 1;
            traBar_TWinSize.LargeChange = 4;
            txt_TWinSize.Text = "48";
        }

        private void btn_InPutFile_Low_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog folderBrowserDialog1 = new FolderBrowserDialog();
            if (folderBrowserDialog1.ShowDialog() == DialogResult.OK)
            {
                this.TextBox_LowPath.Text = folderBrowserDialog1.SelectedPath;
                //高分辨率文件打开按钮可用
                this.btn_InPutFile_High.Visible = true;
            }

        }

        private void btn_InPutFile_High_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog folderBrowserDialog1 = new FolderBrowserDialog();
            if (folderBrowserDialog1.ShowDialog() == DialogResult.OK)
            {
                this.TextBox_HighPath.Text = folderBrowserDialog1.SelectedPath;
            }
            //先清空
            this.dataGridView.Rows.Clear();
            //获取低……影像文件
            string[] LowFileList = System.IO.Directory.GetFiles(this.TextBox_LowPath.Text.ToString(), "*.tif");
            int nLow = LowFileList.Count();
            for (int i = 0; i < nLow; i++)
            {
                //得到低……文件名
                string LowFilename = Path.GetFileNameWithoutExtension(LowFileList[i]);
                //得到低……获取时间并转为年月日
                string sDate = LowFilename.Substring(LowFilename.IndexOf(".")+1);
                sDate = sDate.Substring(1, sDate.IndexOf("."));
                string syeartemp = sDate.Substring(0,4);
                string sjuliaday = sDate.Substring(4, 3);
                int iyear = Convert.ToInt16(syeartemp);
                int ijuliaday = Convert.ToInt16(sjuliaday);
                int[] Date = new int[3];
                DateJuliaConvert vDateJuliaConvert = new DateJuliaConvert();
                Date=vDateJuliaConvert._JuliaDay(iyear, ijuliaday);
                //判断高……是否存在并显示

                string syear = Date[0].ToString();
                string sday = Date[2].ToString();
                string smonth = Date[1].ToString();
                if (Date[1]<=9)
                {
                    smonth = "0" + smonth;
                }
                if (Date[2] <= 9)
                {
                    sday = "0" + sday;
                }
                string mark = "*"+syear + smonth + sday+"*.tif";
                string[] HighFileList = System.IO.Directory.GetFiles(this.TextBox_HighPath.Text.ToString(), mark);
                string[] row = new string[3];
                if (HighFileList.Count() != 0)
                {
                    row[0] = syear + smonth + sday;
                    row[1] = "√";
                    row[2]= "√";

                }
                else
                {
                    row[0] = syear + smonth + sday;
                    row[1] = "√";
                    row[2]= "";
                }
                this.dataGridView.Rows.Add(row);
            }
        }

        private void btn_OutputPath_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog folderBrowserDialog1 = new FolderBrowserDialog();
            if (folderBrowserDialog1.ShowDialog() == DialogResult.OK)
            {
                string strtemp = folderBrowserDialog1.SelectedPath;
                string strtemp2 = strtemp.Substring(strtemp.Length - 1);
                if (strtemp2 != "\\")
                {
                    strtemp = strtemp + '\\';
                }
                this.TextBox_OutputPath.Text = strtemp;
            }
        }

        private void btn_Cancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btn_OpenOutputPath_Click(object sender, EventArgs e)
        {
            string sFilename = this.TextBox_OutputPath.Text.Trim();
            //string sPath = Path.GetDirectoryName(sFilename);
            System.Diagnostics.Process.Start("explorer.exe", sFilename);
        }

        private void cbx_Method_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void TSFusionForm_Load(object sender, EventArgs e)
        {
            Point pBtn = fMai.pTSBtn;
            Point pMain = fMai.Location;
            int HeightMainForm = fMai.Size.Height;
            int x = (System.Windows.Forms.SystemInformation.WorkingArea.Width - this.Size.Width) / 2;
            this.Location = new Point(x, pMain.Y + pBtn.Y + HeightMainForm + 8);
        }

        private void btn_OK_Click(object sender, EventArgs e)
        {
            #region 输入与输出路径条件判断
            if (this.TextBox_LowPath.Text.Equals(""))
            {
                MessageBox.Show("请选择输入低空间分辨率影像！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            if (this.TextBox_HighPath.Text.Equals(""))
            {
                MessageBox.Show("请选择输入低空间分辨率影像！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            if (this.TextBox_OutputPath.Text.Equals(""))
            {
                MessageBox.Show("请选择输出影像路径！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            #endregion
            #region 界面参数获取
            //低空间分辨率影像路径
            string sFilename_LowPath = this.TextBox_LowPath.Text.Trim()+Path.DirectorySeparatorChar;
            //高空间分辨率影像路径
            string sFilename_HighPath = this.TextBox_HighPath.Text.Trim()+Path.DirectorySeparatorChar;
            //输出路径
            string sFilename_Output = this.TextBox_OutputPath.Text.Trim();
            //融合方法
            string sMethod = this.cbx_Method.SelectedValue.ToString();
            //相似像元窗口大小
            string sWinSize = this.cbx_WinSize.SelectedValue.ToString();
            //基准影像窗口大小
            string sTWinSize = this.txt_TWinSize.Text.Trim();
            #endregion
            #region 调用IDL程序
            //IDLSav的路径
            string sIDLSavPath = Application.StartupPath;
            sIDLSavPath = sIDLSavPath.Substring(0, Application.StartupPath.LastIndexOf("bin"));
            sIDLSavPath = sIDLSavPath + "IDLSav\\TSFusion.pro";
            COM_IDL_connectLib.COM_IDL_connectClass oCom = new COM_IDL_connectLib.COM_IDL_connectClass();
            try
            {
                //初始化
                oCom.CreateObject(0, 0, 0);
                //参数设置
                oCom.SetIDLVariable("CFileDir", sFilename_LowPath);
                oCom.SetIDLVariable("FFileDir", sFilename_HighPath);
                oCom.SetIDLVariable("OutputPath", sFilename_Output);
                oCom.SetIDLVariable("Method", sMethod);
                oCom.SetIDLVariable("WinSize", sWinSize);
                oCom.SetIDLVariable("TWinSize", sTWinSize);
                //编译idl功能源码
                oCom.ExecuteString(".compile -v '" + sIDLSavPath + "'");
                //oCom.ExecuteString("restore,\'" + sIDLSavPath + "\'");
                oCom.ExecuteString("TSFusion,CFileDir,FFileDir,OutputPath,Method,WinSize,TWinSize,Message=Message");
                object objArr = oCom.GetIDLVariable("Message");
                //返回错误消息
                if (objArr != null)
                {
                    MessageBox.Show(objArr.ToString());
                    oCom.DestroyObject();
                    this.btn_OK.Enabled = true;
                    return;
                }
                oCom.DestroyObject();
                MessageBox.Show("时空融合完毕", "提示", MessageBoxButtons.OK, MessageBoxIcon.Information);
                this.btn_OK.Enabled = true;
                this.btn_OpenOutputPath.Visible = true;

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            #endregion
        }

        private void traBar_TWinSize_Scroll(object sender, EventArgs e)
        {
            txt_TWinSize.Text = traBar_TWinSize.Value.ToString();
        }



    }
}
