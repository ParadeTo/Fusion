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
    public partial class TSQuaAssForm : Form
    {
        private MainForm fMai;
        //全局变量
        public string[] sGlobal_Filename_Ass;//待评价影像
        public string sGlobal_OutDir;//输出路径
        public string sQua = "TSFusionQuaAss";
        public TSQuaAssForm()
        {
            InitializeComponent();
        }
        public TSQuaAssForm(MainForm fMai)
            : this()
        {
            this.fMai = fMai;
            //禁用打开文件路径按钮
            this.btn_OpenOutputPath.Visible = false;
        }
        private void btn_InPutFile_AssImg_Click(object sender, EventArgs e)
        {
            OpenFileDialog dlg = new OpenFileDialog();　//创建一个OpenFileDialog 
            dlg.Filter = "(*.tif)|*.tif|(*.*)|*.*";
            dlg.Multiselect = true;//设置属性为多选
            if (dlg.ShowDialog() == DialogResult.OK)
            {
                this.TextBox_AssImg.Text = Path.GetDirectoryName(dlg.FileName);
                string str = " ";
                for (int i = 0; i < dlg.FileNames.Length; i++)//根据数组长度定义循环次数
                {
                    str = Path.GetFileName(dlg.FileNames.GetValue(i).ToString());//获取文件文件名
                    ListViewItem item = new ListViewItem() { Text = str };
                    this.listView_Ass.Items.Add(item);
                }
            }
        }

        private void btn_InPutFile_RefImg_Click(object sender, EventArgs e)
        {
            OpenFileDialog dlg = new OpenFileDialog();　//创建一个OpenFileDialog 
            dlg.Filter = "(*.tif)|*.tif|(*.*)|*.*";
            dlg.Multiselect = true;//设置属性为多选
            if (dlg.ShowDialog() == DialogResult.OK)
            {
                this.TextBox_RefImg.Text = Path.GetDirectoryName(dlg.FileName);
                string str = " ";
                for (int i = 0; i < dlg.FileNames.Length; i++)//根据数组长度定义循环次数
                {
                    str = Path.GetFileName(dlg.FileNames.GetValue(i).ToString());//获取文件文件名
                    ListViewItem item = new ListViewItem() { Text = str };
                    this.listView_Ref.Items.Add(item);
                }
            }
        }

        private void btn_delete_Ass_Click(object sender, EventArgs e)
        {
            foreach (ListViewItem item in listView_Ass.SelectedItems)
            {
                listView_Ass.Items.Remove(item);
            }
        }

        private void btn_Up_Ass_Click(object sender, EventArgs e)
        {
            //可选择多个项目同时上移
            //未选择任何项目
            if (listView_Ass.SelectedItems.Count == 0)
            {
                return;
            }
            listView_Ass.BeginUpdate();
            //选中的第一个项目不是第一个项目时才能进行上移操作
            if (listView_Ass.SelectedItems[0].Index > 0)
            {
                foreach (ListViewItem item in listView_Ass.SelectedItems)
                {
                    ListViewItem itemSelected = item;
                    int indexSexlectedItem = item.Index;
                    listView_Ass.Items.RemoveAt(indexSexlectedItem);
                    listView_Ass.Items.Insert(indexSexlectedItem - 1, itemSelected);
                }
            }
            listView_Ass.EndUpdate();
            if (listView_Ass.Items.Count > 0 && listView_Ass.SelectedItems.Count > 0)
            {
                listView_Ass.Focus();
                listView_Ass.SelectedItems[0].Focused = true;
                listView_Ass.SelectedItems[0].EnsureVisible();
            }
        }

        private void btn_Down_Ass_Click(object sender, EventArgs e)
        {
            //可选择多个项目同时下移
            //未选择任何项目
            if (listView_Ass.SelectedItems.Count == 0)
            {
                return;
            }
            listView_Ass.BeginUpdate();
            //选中的第一个项目不是最后一个项目时才能进行上移操作
            int indexMaxSelectedItem = listView_Ass.SelectedItems[listView_Ass.SelectedItems.Count - 1].Index;//选中的最后一个项目索引
            if (indexMaxSelectedItem < listView_Ass.Items.Count - 1)
            {
                for (int i = listView_Ass.SelectedItems.Count - 1; i >= 0; i--)
                {
                    ListViewItem itemSelected = listView_Ass.SelectedItems[i];
                    int indexSelected = itemSelected.Index;
                    listView_Ass.Items.RemoveAt(indexSelected);
                    listView_Ass.Items.Insert(indexSelected + 1, itemSelected);
                }
            }
            listView_Ass.EndUpdate();
            if (listView_Ass.Items.Count > 0 && listView_Ass.SelectedItems.Count > 0)
            {
                listView_Ass.Focus();
                listView_Ass.SelectedItems[listView_Ass.SelectedItems.Count - 1].Focused = true;
                listView_Ass.SelectedItems[listView_Ass.SelectedItems.Count - 1].EnsureVisible();
            }
        }

        private void btn_delete_Ref_Click(object sender, EventArgs e)
        {
            foreach (ListViewItem item in listView_Ref.SelectedItems)
            {
                listView_Ref.Items.Remove(item);
            }
        }

        private void btn_Up_Ref_Click(object sender, EventArgs e)
        {
            //可选择多个项目同时上移
            //未选择任何项目
            if (listView_Ref.SelectedItems.Count == 0)
            {
                return;
            }
            listView_Ref.BeginUpdate();
            //选中的第一个项目不是第一个项目时才能进行上移操作
            if (listView_Ref.SelectedItems[0].Index > 0)
            {
                foreach (ListViewItem item in listView_Ref.SelectedItems)
                {
                    ListViewItem itemSelected = item;
                    int indexSexlectedItem = item.Index;
                    listView_Ref.Items.RemoveAt(indexSexlectedItem);
                    listView_Ref.Items.Insert(indexSexlectedItem - 1, itemSelected);
                }
            }
            listView_Ref.EndUpdate();
            if (listView_Ref.Items.Count > 0 && listView_Ref.SelectedItems.Count > 0)
            {
                listView_Ref.Focus();
                listView_Ref.SelectedItems[0].Focused = true;
                listView_Ref.SelectedItems[0].EnsureVisible();
            }
        }

        private void btn_Down_Ref_Click(object sender, EventArgs e)
        {
            //可选择多个项目同时下移
            //未选择任何项目
            if (listView_Ref.SelectedItems.Count == 0)
            {
                return;
            }
            listView_Ref.BeginUpdate();
            //选中的第一个项目不是最后一个项目时才能进行上移操作
            int indexMaxSelectedItem = listView_Ref.SelectedItems[listView_Ref.SelectedItems.Count - 1].Index;//选中的最后一个项目索引
            if (indexMaxSelectedItem < listView_Ref.Items.Count - 1)
            {
                for (int i = listView_Ref.SelectedItems.Count - 1; i >= 0; i--)
                {
                    ListViewItem itemSelected = listView_Ref.SelectedItems[i];
                    int indexSelected = itemSelected.Index;
                    listView_Ref.Items.RemoveAt(indexSelected);
                    listView_Ref.Items.Insert(indexSelected + 1, itemSelected);
                }
            }
            listView_Ref.EndUpdate();
            if (listView_Ref.Items.Count > 0 && listView_Ref.SelectedItems.Count > 0)
            {
                listView_Ref.Focus();
                listView_Ref.SelectedItems[listView_Ref.SelectedItems.Count - 1].Focused = true;
                listView_Ref.SelectedItems[listView_Ref.SelectedItems.Count - 1].EnsureVisible();
            }
        }

        private void btn_OpenOutputPath_Click(object sender, EventArgs e)
        {
            string sFilename = this.TextBox_OutputPath.Text.Trim();
            //string sPath = Path.GetDirectoryName(sFilename);
            System.Diagnostics.Process.Start("explorer.exe", sFilename);
        }

        private void btn_Cancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btn_OK_Click(object sender, EventArgs e)
        {
            #region 输入与输出路径条件判断
            if (this.TextBox_AssImg.Text.Equals(""))
            {
                MessageBox.Show("请选择输入待评价影像！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            if (this.TextBox_RefImg.Text.Equals(""))
            {
                MessageBox.Show("请选择输入参考影像！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            if (this.TextBox_OutputPath.Text.Equals(""))
            {
                MessageBox.Show("请选择输出影像路径！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            if (this.listView_Ass.Items.Count != this.listView_Ref.Items.Count)
            {
                MessageBox.Show("输入的待评价影像和参考影像文件数不一致！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            if (!this.cbx_AbsDiffAve_1.Checked && !this.cbx_EA_2.Checked && !this.cbx_Bias_3.Checked)
            {
                MessageBox.Show("请至少选择一项评价指标！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            #endregion
            this.btn_OK.Enabled = false;
            #region 界面参数获取
            //待评价影像
            List<string> list_Ass = new List<string>();
            foreach (ListViewItem item in this.listView_Ass.Items)
            {
                string s = this.TextBox_AssImg.Text + "\\" + item.SubItems[0].Text.Trim();
                list_Ass.Add(s);
            }
            string[] sFilename_Ass = (string[])list_Ass.ToArray();
            this.sGlobal_Filename_Ass = sFilename_Ass;
            //参考影像
            List<string> list_Ref = new List<string>();
            foreach (ListViewItem item in this.listView_Ref.Items)
            {
                string s = this.TextBox_RefImg.Text + "\\" + item.SubItems[0].Text.Trim();
                list_Ref.Add(s);
            }
            string[] sFilename_Ref = (string[])list_Ref.ToArray();
            //输出路径
            string sFilename_Output = this.TextBox_OutputPath.Text.Trim();
            sGlobal_OutDir = sFilename_Output;
            //评价指标
            string[] sQuaArr = new string[] { "", "", "" ,""};
            if (this.cbx_AbsDiffAve_1.Checked)
            {
                sQuaArr[0] = "TRUE";
            }
            if (this.cbx_EA_2.Checked)
            {
                sQuaArr[1] = "TRUE";
            }
            if (this.cbx_Bias_3.Checked)
            {
                sQuaArr[2] = "TRUE";
            }
            if(this.cbx_LinearFit_4.Checked)
            {
                sQuaArr[3] = "TRUE";
            }
            #endregion
            #region 调用IDL程序
            //IDLSav的路径
            string sIDLSavPath = Application.StartupPath;
            sIDLSavPath = sIDLSavPath.Substring(0, Application.StartupPath.LastIndexOf("bin"));
            sIDLSavPath = sIDLSavPath + "IDLSav\\TSFusionAss.pro";
            COM_IDL_connectLib.COM_IDL_connectClass oCom = new COM_IDL_connectLib.COM_IDL_connectClass();
            try
            {
                //初始化
                oCom.CreateObject(0, 0, 0);
                //参数设置
                oCom.SetIDLVariable("F_files", sFilename_Ass);
                oCom.SetIDLVariable("Ref_files", sFilename_Ref);
                oCom.SetIDLVariable("OutPutPath", sFilename_Output);
                oCom.SetIDLVariable("QuaArr", sQuaArr);
                //编译2次idl功能源码（奇怪啊，非得编译两次才能运行，无法理解）
                oCom.ExecuteString(".compile -v '" + sIDLSavPath + "'");
                oCom.ExecuteString(".compile -v '" + sIDLSavPath + "'");
                //oCom.ExecuteString("restore,\'" + sIDLSavPath + "\'");
                //执行
                oCom.ExecuteString("TSFusionAss,Ref_files,F_files,OutPutPath,QuaArr,Message=Message");
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
                MessageBox.Show("时空融合质量评价完毕", "提示", MessageBoxButtons.OK, MessageBoxIcon.Information);
                this.btn_OK.Enabled = true;
                this.btn_OpenOutputPath.Visible = true;
                QuaAssShowForm vQuaAssShowForm = new QuaAssShowForm(this);
                vQuaAssShowForm.Show();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            #endregion
            this.btn_OK.Enabled = true;
        }

        private void btn_OutPutPath_Click(object sender, EventArgs e)
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
        private void TSQuaAssForm_Load(object sender, EventArgs e)
        {
            Point pBtn = fMai.pTSBtn;
            Point pMain = fMai.Location;
            int HeightMainForm = fMai.Size.Height;
            int x = (System.Windows.Forms.SystemInformation.WorkingArea.Width - this.Size.Width) / 2;
            this.Location = new Point(x, pMain.Y + pBtn.Y + HeightMainForm + 8);
        }
    }
}
