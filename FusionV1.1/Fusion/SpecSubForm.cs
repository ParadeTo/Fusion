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
    public partial class SpecSubForm : Form
    {
        private MainForm fMai;

        public SpecSubForm()
        {
            InitializeComponent();

        }
        public SpecSubForm(MainForm fMai): this()
        {
            this.fMai = fMai;
        }

        private void SpecSubForm_Load(object sender, EventArgs e)
        {
            Point pBtn = fMai.pSpecBtn;
            Point pMain = fMai.Location;
            int HeightMainForm = fMai.Size.Height;
            this.Location = new Point(pMain.X + pBtn.X + 5, pMain.Y + pBtn.Y + HeightMainForm+3);
        }

        private void btn_SpecFusion_Click(object sender, EventArgs e)
        {
            SpecFusionForm vSpecFusionForm = new SpecFusionForm(fMai);
            vSpecFusionForm.Show();
        }

        private void btn_SpecQuaAss_Click(object sender, EventArgs e)
        {
            SpecQuaAssForm vSpecQuaAssForm = new SpecQuaAssForm(fMai);
            vSpecQuaAssForm.Show();
        }
    }
}
