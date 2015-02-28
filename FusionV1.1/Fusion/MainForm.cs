﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;


namespace Fusion
{
    public partial class MainForm : Form
    {
        //记录主窗口按钮在主窗口中的位置
        public Point pDisplayBtn= new Point();
        public Point pSpecBtn = new Point();
        public Point pTSBtn=new Point();
        public Point pAboutBtn = new Point();
        public Point pDisplayBtnIDL = new Point();
        
        public MainForm()
        {
            InitializeComponent();
            //按钮的位置
            pDisplayBtnIDL = this.pDisplayBtnIDL;
            pSpecBtn = this.btn_SpecFusion.Location;
            pDisplayBtn = this.btn_Display.Location;
            pTSBtn = this.btn_TSFusion.Location;
            pAboutBtn = this.btn_AboutMe.Location;
           
        }

        private void btn_SpecFusion_Click(object sender, EventArgs e)
        {
            SpecSubForm vSpecSubForm = new SpecSubForm(this);
            vSpecSubForm.Show();
        }

        private void btn_TSFusion_Click(object sender, EventArgs e)
        {
            TSSubForm vTSFusionForm = new TSSubForm(this);
            vTSFusionForm.Show();
        }

        private void btn_QuaAss_Click(object sender, EventArgs e)
        {
            AboutMeForm vAboutMeForm = new AboutMeForm(this);
            vAboutMeForm.Show();
        }

        private void btn_Display_Click(object sender, EventArgs e)
        {
            DisplayForm vDisplayForm = new DisplayForm(this);
            vDisplayForm.Show();
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            //显示在顶部中间
            int x = (System.Windows.Forms.SystemInformation.WorkingArea.Width - this.Size.Width) / 2;
            this.StartPosition = FormStartPosition.Manual;
            this.Location = (Point)new Size(x, 5);
        }

        private void btn_DisplayIDL_Click(object sender, EventArgs e)
        {
            Point pBtn = this.pDisplayBtnIDL;
            Point pMain = this.Location;
            int HeightMainForm = this.Size.Height;
            int x = (System.Windows.Forms.SystemInformation.WorkingArea.Width - this.Size.Width) / 2;
            int y = pMain.Y + pBtn.Y + HeightMainForm + 8;
            #region 调用IDL程序
            //IDLSav的路径
            string sIDLSavPath = Application.StartupPath;
            sIDLSavPath = sIDLSavPath.Substring(0, Application.StartupPath.LastIndexOf("bin"));
            sIDLSavPath = sIDLSavPath + "IDLSav\\common_viewer.pro";
            COM_IDL_connectLib.COM_IDL_connectClass oCom = new COM_IDL_connectLib.COM_IDL_connectClass();
            try
            {
                //初始化
                oCom.CreateObject(0, 0, 0);
                //参数设置

                oCom.SetIDLVariable("w_xoffset", x);
                oCom.SetIDLVariable("w_yoffset", y);
                //编译idl功能源码
                oCom.ExecuteString(".compile -v '" + sIDLSavPath + "'");
                //oCom.ExecuteString(".compile -v '" + sIDLSavPath + "'");
                //oCom.ExecuteString("restore,\'" + sIDLSavPath + "\'");
                oCom.ExecuteString("COMMON_VIEWER,w_xoffset,w_yoffset");
                object objArr = oCom.GetIDLVariable("Message");
                ////返回错误消息
                //if (objArr != null)
                //{
                //    MessageBox.Show(objArr.ToString());
                //    oCom.DestroyObject();
                //    return;
                //}
                oCom.DestroyObject();

            }
            catch (Exception ex)
            {
               // MessageBox.Show(ex.Message);
            }
            #endregion
        }






    }
}
