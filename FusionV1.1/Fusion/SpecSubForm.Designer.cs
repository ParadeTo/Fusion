namespace Fusion
{
    partial class SpecSubForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(SpecSubForm));
            this.btn_SpecFusion = new System.Windows.Forms.Button();
            this.btn_SpecQuaAss = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // btn_SpecFusion
            // 
            this.btn_SpecFusion.Location = new System.Drawing.Point(5, 5);
            this.btn_SpecFusion.Name = "btn_SpecFusion";
            this.btn_SpecFusion.Size = new System.Drawing.Size(141, 23);
            this.btn_SpecFusion.TabIndex = 0;
            this.btn_SpecFusion.Text = "光谱融合";
            this.btn_SpecFusion.UseVisualStyleBackColor = true;
            this.btn_SpecFusion.Click += new System.EventHandler(this.btn_SpecFusion_Click);
            // 
            // btn_SpecQuaAss
            // 
            this.btn_SpecQuaAss.Location = new System.Drawing.Point(5, 32);
            this.btn_SpecQuaAss.Name = "btn_SpecQuaAss";
            this.btn_SpecQuaAss.Size = new System.Drawing.Size(141, 23);
            this.btn_SpecQuaAss.TabIndex = 1;
            this.btn_SpecQuaAss.Text = "质量评价";
            this.btn_SpecQuaAss.UseVisualStyleBackColor = true;
            this.btn_SpecQuaAss.Click += new System.EventHandler(this.btn_SpecQuaAss_Click);
            // 
            // SpecSubForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(150, 62);
            this.Controls.Add(this.btn_SpecQuaAss);
            this.Controls.Add(this.btn_SpecFusion);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "SpecSubForm";
            this.Text = "光谱融合";
            this.Load += new System.EventHandler(this.SpecSubForm_Load);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button btn_SpecFusion;
        private System.Windows.Forms.Button btn_SpecQuaAss;
    }
}