namespace Fusion
{
    partial class TSSubForm
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(TSSubForm));
            this.btn_TSFusion = new System.Windows.Forms.Button();
            this.btn_TSQuaAss = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // btn_TSFusion
            // 
            this.btn_TSFusion.Location = new System.Drawing.Point(5, 5);
            this.btn_TSFusion.Name = "btn_TSFusion";
            this.btn_TSFusion.Size = new System.Drawing.Size(141, 23);
            this.btn_TSFusion.TabIndex = 1;
            this.btn_TSFusion.Text = "时空融合";
            this.btn_TSFusion.UseVisualStyleBackColor = true;
            this.btn_TSFusion.Click += new System.EventHandler(this.btn_TSFusion_Click);
            // 
            // btn_TSQuaAss
            // 
            this.btn_TSQuaAss.Location = new System.Drawing.Point(5, 32);
            this.btn_TSQuaAss.Name = "btn_TSQuaAss";
            this.btn_TSQuaAss.Size = new System.Drawing.Size(141, 23);
            this.btn_TSQuaAss.TabIndex = 2;
            this.btn_TSQuaAss.Text = "质量评价";
            this.btn_TSQuaAss.UseVisualStyleBackColor = true;
            this.btn_TSQuaAss.Click += new System.EventHandler(this.btn_TSQuaAss_Click);
            // 
            // TSSubForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(150, 62);
            this.Controls.Add(this.btn_TSQuaAss);
            this.Controls.Add(this.btn_TSFusion);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "TSSubForm";
            this.Text = "时空融合";
            this.Load += new System.EventHandler(this.TSSubForm_Load);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button btn_TSFusion;
        private System.Windows.Forms.Button btn_TSQuaAss;

    }
}