using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace Fusion
{
    public partial class AboutMeForm : Form
    {
        private MainForm fMai;
        public AboutMeForm()
        {
           // this.StartPosition = FormStartPosition.CenterScreen;
            InitializeComponent();
        }
        public AboutMeForm(MainForm fMai)
            : this()
        {
            this.fMai = fMai;
        }
        private void AboutMeForm_Load(object sender, EventArgs e)
        {
            Point pBtn = fMai.pAboutBtn;
            Point pMain = fMai.Location;
            int HeightMainForm = fMai.Size.Height;
            int x = (System.Windows.Forms.SystemInformation.WorkingArea.Width - this.Size.Width) / 2;
            this.Location = new Point(x, pMain.Y + pBtn.Y + HeightMainForm + 8);
        }
    }
}
