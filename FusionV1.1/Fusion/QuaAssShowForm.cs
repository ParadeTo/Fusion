using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Collections;

namespace Fusion
{
    public partial class QuaAssShowForm : Form
    {
        private SpecQuaAssForm vSpecQuaAssForm;
        private TSQuaAssForm vTSQuaAssForm;
        public QuaAssShowForm()
        {
            InitializeComponent();
        }
        //光谱融合初始化函数重载
        public QuaAssShowForm(SpecQuaAssForm vSpecQuaAssForm): this()
        {
            this.vSpecQuaAssForm = vSpecQuaAssForm;
            //初始化评价影像下拉菜单
            List<string> cbxString = new List<string>();
            int nFiles = vSpecQuaAssForm.sGlobal_Filename_Ass.Count();
            for (int i = 0; i < nFiles ;i++ )
            {
                string tempstr = Path.GetFileNameWithoutExtension(vSpecQuaAssForm.sGlobal_Filename_Ass[i]);
                string tempstr2 = vSpecQuaAssForm.sGlobal_OutDir+tempstr+"_"+vSpecQuaAssForm.sGlobal_QuaKindEn+".txt";
                cbxString.Add(tempstr2);
            }
            this.comboBox.DataSource = cbxString;
            this.comboBox.SelectedIndex = 0;
            //初始化listBox
            this.listBox.Items.Clear();
            StreamReader objReader = new StreamReader(cbxString[0]);
            string sLine = string.Empty;
            int n;
            ArrayList linlist = new ArrayList();
            while (sLine != null)
            {
                sLine = objReader.ReadLine();
                if (!string.IsNullOrEmpty(sLine))
                {
                    linlist.Add(sLine);
                }
            }
            objReader.Close();
            n = linlist.Count;
            for (int i = 0; i < n; i++)
            {
                string str = linlist[i].ToString();
                listBox.Items.Add(str);
            }
        }
        //光谱融合初始化函数重载
        public QuaAssShowForm(TSQuaAssForm vTSQuaAssForm): this()
        {
            this.vTSQuaAssForm = vTSQuaAssForm;
            //初始化评价影像下拉菜单
            List<string> cbxString = new List<string>();
            int nFiles = vTSQuaAssForm.sGlobal_Filename_Ass.Count();
            for (int i = 0; i < nFiles; i++)
            {
                string tempstr = Path.GetFileNameWithoutExtension(vTSQuaAssForm.sGlobal_Filename_Ass[i]);
                string tempstr2 = vTSQuaAssForm.sGlobal_OutDir + tempstr + "_Qua.txt";
                cbxString.Add(tempstr2);
            }
            this.comboBox.DataSource = cbxString;
            this.comboBox.SelectedIndex = 0;
            //初始化listBox
            this.listBox.Items.Clear();
            StreamReader objReader = new StreamReader(cbxString[0]);
            string sLine = string.Empty;
            int n;
            ArrayList linlist = new ArrayList();
            while (sLine != null)
            {
                sLine = objReader.ReadLine();
                if (!string.IsNullOrEmpty(sLine))
                {
                    linlist.Add(sLine);
                }
            }
            objReader.Close();
            n = linlist.Count;
            for (int i = 0; i < n; i++)
            {
                string str = linlist[i].ToString();
                listBox.Items.Add(str);
            }
        }
        private void SpecQuaAssShowForm_Load(object sender, EventArgs e)
        {
            if (this.vSpecQuaAssForm != null)
            {
                Point pvSpecQuaAssForm = this.vSpecQuaAssForm.Location;
                int x = (System.Windows.Forms.SystemInformation.WorkingArea.Width - this.Size.Width) / 2;
                this.Location = new Point(x, pvSpecQuaAssForm.Y);
            }
            else if(this.vTSQuaAssForm!=null)
            {
                Point pvTSQuaAssForm = this.vTSQuaAssForm.Location;
                int x = (System.Windows.Forms.SystemInformation.WorkingArea.Width - this.Size.Width) / 2;
                this.Location = new Point(x, pvTSQuaAssForm.Y);
            }
        }

        private void comboBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (this.vSpecQuaAssForm != null)
            {
                string sQuaAssFilename = this.comboBox.SelectedValue.ToString();
                this.listBox.Items.Clear();
                StreamReader objReader = new StreamReader(sQuaAssFilename);
                string sLine = string.Empty;
                int n;
                ArrayList linlist = new ArrayList();
                while (sLine != null)
                {
                    sLine = objReader.ReadLine();
                    if (!string.IsNullOrEmpty(sLine))
                    {
                        linlist.Add(sLine);
                    }
                }
                objReader.Close();
                n = linlist.Count;
                for (int i = 0; i < n; i++)
                {
                    string str = linlist[i].ToString();
                    listBox.Items.Add(str);
                }
            }
            else if (this.vTSQuaAssForm != null)
            {
                string sQuaAssFilename = this.comboBox.SelectedValue.ToString();
                this.listBox.Items.Clear();
                StreamReader objReader = new StreamReader(sQuaAssFilename);
                string sLine = string.Empty;
                int n;
                ArrayList linlist = new ArrayList();
                while (sLine != null)
                {
                    sLine = objReader.ReadLine();
                    if (!string.IsNullOrEmpty(sLine))
                    {
                        linlist.Add(sLine);
                    }
                }
                objReader.Close();
                n = linlist.Count;
                for (int i = 0; i < n; i++)
                {
                    string str = linlist[i].ToString();
                    listBox.Items.Add(str);
                }
            }
            

        }

    }
}
