namespace Fusion
{
    partial class DisplayBandComForm
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(DisplayBandComForm));
            this.label1 = new System.Windows.Forms.Label();
            this.comBox_R = new System.Windows.Forms.ComboBox();
            this.panel_multi = new System.Windows.Forms.Panel();
            this.comBox_B = new System.Windows.Forms.ComboBox();
            this.label3 = new System.Windows.Forms.Label();
            this.comBox_G = new System.Windows.Forms.ComboBox();
            this.label2 = new System.Windows.Forms.Label();
            this.btn_Display = new System.Windows.Forms.Button();
            this.label4 = new System.Windows.Forms.Label();
            this.panel_single = new System.Windows.Forms.Panel();
            this.label5 = new System.Windows.Forms.Label();
            this.comBox_StretchType = new System.Windows.Forms.ComboBox();
            this.userControl_Color1 = new Fusion.UserControl_Color();
            this.panel_multi.SuspendLayout();
            this.panel_single.SuspendLayout();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(23, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(11, 12);
            this.label1.TabIndex = 5;
            this.label1.Text = "R";
            this.label1.Click += new System.EventHandler(this.label1_Click_1);
            // 
            // comBox_R
            // 
            this.comBox_R.FormattingEnabled = true;
            this.comBox_R.Location = new System.Drawing.Point(40, 5);
            this.comBox_R.Name = "comBox_R";
            this.comBox_R.Size = new System.Drawing.Size(121, 20);
            this.comBox_R.TabIndex = 6;
            // 
            // panel_multi
            // 
            this.panel_multi.Controls.Add(this.comBox_B);
            this.panel_multi.Controls.Add(this.label3);
            this.panel_multi.Controls.Add(this.comBox_G);
            this.panel_multi.Controls.Add(this.label2);
            this.panel_multi.Controls.Add(this.comBox_R);
            this.panel_multi.Controls.Add(this.label1);
            this.panel_multi.Location = new System.Drawing.Point(61, 12);
            this.panel_multi.Name = "panel_multi";
            this.panel_multi.Size = new System.Drawing.Size(200, 131);
            this.panel_multi.TabIndex = 7;
            // 
            // comBox_B
            // 
            this.comBox_B.FormattingEnabled = true;
            this.comBox_B.Location = new System.Drawing.Point(40, 89);
            this.comBox_B.Name = "comBox_B";
            this.comBox_B.Size = new System.Drawing.Size(121, 20);
            this.comBox_B.TabIndex = 10;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(23, 93);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(11, 12);
            this.label3.TabIndex = 9;
            this.label3.Text = "B";
            // 
            // comBox_G
            // 
            this.comBox_G.FormattingEnabled = true;
            this.comBox_G.Location = new System.Drawing.Point(40, 47);
            this.comBox_G.Name = "comBox_G";
            this.comBox_G.Size = new System.Drawing.Size(121, 20);
            this.comBox_G.TabIndex = 8;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(23, 51);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(11, 12);
            this.label2.TabIndex = 7;
            this.label2.Text = "G";
            // 
            // btn_Display
            // 
            this.btn_Display.Location = new System.Drawing.Point(117, 221);
            this.btn_Display.Name = "btn_Display";
            this.btn_Display.Size = new System.Drawing.Size(75, 23);
            this.btn_Display.TabIndex = 8;
            this.btn_Display.Text = "显示";
            this.btn_Display.UseVisualStyleBackColor = true;
            this.btn_Display.Click += new System.EventHandler(this.btn_Display_Click);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(15, 66);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(53, 12);
            this.label4.TabIndex = 9;
            this.label4.Text = "选择颜色";
            // 
            // panel_single
            // 
            this.panel_single.Controls.Add(this.userControl_Color1);
            this.panel_single.Location = new System.Drawing.Point(74, 52);
            this.panel_single.Name = "panel_single";
            this.panel_single.Size = new System.Drawing.Size(226, 62);
            this.panel_single.TabIndex = 4;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(15, 172);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(53, 12);
            this.label5.TabIndex = 10;
            this.label5.Text = "拉伸方式";
            // 
            // comBox_StretchType
            // 
            this.comBox_StretchType.FormattingEnabled = true;
            this.comBox_StretchType.Location = new System.Drawing.Point(77, 170);
            this.comBox_StretchType.Name = "comBox_StretchType";
            this.comBox_StretchType.Size = new System.Drawing.Size(219, 20);
            this.comBox_StretchType.TabIndex = 11;
            // 
            // userControl_Color1
            // 
            this.userControl_Color1.FromColor = System.Drawing.Color.Empty;
            this.userControl_Color1.Location = new System.Drawing.Point(3, 12);
            this.userControl_Color1.Name = "userControl_Color1";
            this.userControl_Color1.Size = new System.Drawing.Size(220, 20);
            this.userControl_Color1.TabIndex = 0;
            this.userControl_Color1.ToColor = System.Drawing.Color.Empty;
            // 
            // DisplayBandComForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(312, 268);
            this.Controls.Add(this.comBox_StretchType);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.btn_Display);
            this.Controls.Add(this.panel_multi);
            this.Controls.Add(this.panel_single);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "DisplayBandComForm";
            this.Text = "符号系统";
            this.Load += new System.EventHandler(this.DisplayBandComForm_Load);
            this.panel_multi.ResumeLayout(false);
            this.panel_multi.PerformLayout();
            this.panel_single.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Panel panel_multi;
        private System.Windows.Forms.ComboBox comBox_R;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox comBox_B;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.ComboBox comBox_G;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button btn_Display;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Panel panel_single;
        private UserControl_Color userControl_Color1;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.ComboBox comBox_StretchType;
    }
}