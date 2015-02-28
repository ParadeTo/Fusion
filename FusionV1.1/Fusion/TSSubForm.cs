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
    public partial class TSSubForm : Form
    {
        private MainForm fMai;
        public TSSubForm()
        {
            InitializeComponent();
        }
        public TSSubForm(MainForm fMai)
            : this()
        {
            this.fMai = fMai;
        }
        private void TSSubForm_Load(object sender, EventArgs e)
        {
            Point pBtn = fMai.pTSBtn;
            Point pMain = fMai.Location;
            int HeightMainForm = fMai.Size.Height;
            this.Location = new Point(pMain.X + pBtn.X + 5, pMain.Y + pBtn.Y + HeightMainForm + 3);
        }

        private void btn_TSFusion_Click(object sender, EventArgs e)
        {
            TSFusionForm vTSFusionForm = new TSFusionForm(fMai);
            vTSFusionForm.Show();
        }

        private void btn_TSQuaAss_Click(object sender, EventArgs e)
        {
            TSQuaAssForm vTSQuaAssForm = new TSQuaAssForm(fMai);
            vTSQuaAssForm.Show();
        }
    }
}
