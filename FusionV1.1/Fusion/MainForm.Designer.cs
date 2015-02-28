﻿namespace Fusion
{
    partial class MainForm
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows 窗体设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.btn_DisplayIDL = new System.Windows.Forms.Button();
            this.btn_Display = new System.Windows.Forms.Button();
            this.btn_AboutMe = new System.Windows.Forms.Button();
            this.btn_TSFusion = new System.Windows.Forms.Button();
            this.btn_SpecFusion = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(198, 86);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(53, 12);
            this.label1.TabIndex = 2;
            this.label1.Text = "光谱融合";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(286, 86);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(53, 12);
            this.label2.TabIndex = 3;
            this.label2.Text = "时空融合";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(374, 86);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(53, 12);
            this.label3.TabIndex = 5;
            this.label3.Text = "关于作者";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(22, 86);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(53, 12);
            this.label4.TabIndex = 7;
            this.label4.Text = "数据显示";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(110, 86);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(53, 12);
            this.label5.TabIndex = 9;
            this.label5.Text = "数据显示";
            // 
            // btn_DisplayIDL
            // 
            this.btn_DisplayIDL.BackgroundImage = global::Fusion.Properties.Resources._2;
            this.btn_DisplayIDL.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.btn_DisplayIDL.Location = new System.Drawing.Point(95, 2);
            this.btn_DisplayIDL.Name = "btn_DisplayIDL";
            this.btn_DisplayIDL.Size = new System.Drawing.Size(82, 82);
            this.btn_DisplayIDL.TabIndex = 8;
            this.btn_DisplayIDL.UseVisualStyleBackColor = true;
            this.btn_DisplayIDL.Click += new System.EventHandler(this.btn_DisplayIDL_Click);
            // 
            // btn_Display
            // 
            this.btn_Display.BackgroundImage = global::Fusion.Properties.Resources._12;
            this.btn_Display.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.btn_Display.Location = new System.Drawing.Point(7, 2);
            this.btn_Display.Name = "btn_Display";
            this.btn_Display.Size = new System.Drawing.Size(82, 82);
            this.btn_Display.TabIndex = 6;
            this.btn_Display.UseVisualStyleBackColor = true;
            this.btn_Display.Click += new System.EventHandler(this.btn_Display_Click);
            // 
            // btn_AboutMe
            // 
            this.btn_AboutMe.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("btn_AboutMe.BackgroundImage")));
            this.btn_AboutMe.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.btn_AboutMe.Location = new System.Drawing.Point(359, 2);
            this.btn_AboutMe.Name = "btn_AboutMe";
            this.btn_AboutMe.Size = new System.Drawing.Size(82, 82);
            this.btn_AboutMe.TabIndex = 4;
            this.btn_AboutMe.UseVisualStyleBackColor = true;
            this.btn_AboutMe.Click += new System.EventHandler(this.btn_QuaAss_Click);
            // 
            // btn_TSFusion
            // 
            this.btn_TSFusion.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("btn_TSFusion.BackgroundImage")));
            this.btn_TSFusion.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.btn_TSFusion.Location = new System.Drawing.Point(271, 2);
            this.btn_TSFusion.Name = "btn_TSFusion";
            this.btn_TSFusion.Size = new System.Drawing.Size(82, 82);
            this.btn_TSFusion.TabIndex = 1;
            this.btn_TSFusion.UseVisualStyleBackColor = true;
            this.btn_TSFusion.Click += new System.EventHandler(this.btn_TSFusion_Click);
            // 
            // btn_SpecFusion
            // 
            this.btn_SpecFusion.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("btn_SpecFusion.BackgroundImage")));
            this.btn_SpecFusion.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.btn_SpecFusion.Location = new System.Drawing.Point(183, 2);
            this.btn_SpecFusion.Name = "btn_SpecFusion";
            this.btn_SpecFusion.Size = new System.Drawing.Size(82, 82);
            this.btn_SpecFusion.TabIndex = 0;
            this.btn_SpecFusion.UseVisualStyleBackColor = true;
            this.btn_SpecFusion.Click += new System.EventHandler(this.btn_SpecFusion_Click);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(448, 106);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.btn_DisplayIDL);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.btn_Display);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.btn_AboutMe);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.btn_TSFusion);
            this.Controls.Add(this.btn_SpecFusion);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.Name = "MainForm";
            this.Text = "融合";
            this.Load += new System.EventHandler(this.MainForm_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btn_SpecFusion;
        private System.Windows.Forms.Button btn_TSFusion;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button btn_AboutMe;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button btn_Display;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button btn_DisplayIDL;
        private System.Windows.Forms.Label label5;
    }
}

