namespace Fusion
{
    partial class TSQuaAssForm
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(TSQuaAssForm));
            this.btn_Down_Ref = new System.Windows.Forms.Button();
            this.btn_Up_Ref = new System.Windows.Forms.Button();
            this.btn_Down_Ass = new System.Windows.Forms.Button();
            this.btn_Up_Ass = new System.Windows.Forms.Button();
            this.btn_delete_Ref = new System.Windows.Forms.Button();
            this.btn_delete_Ass = new System.Windows.Forms.Button();
            this.listView_Ref = new System.Windows.Forms.ListView();
            this.columnHeaderHigh = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.listView_Ass = new System.Windows.Forms.ListView();
            this.columnHeaderLow = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.TextBox_RefImg = new System.Windows.Forms.TextBox();
            this.btn_InPutFile_RefImg = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.TextBox_AssImg = new System.Windows.Forms.TextBox();
            this.Label1 = new System.Windows.Forms.Label();
            this.btn_InPutFile_AssImg = new System.Windows.Forms.Button();
            this.btn_OpenOutputPath = new System.Windows.Forms.Button();
            this.btn_Cancel = new System.Windows.Forms.Button();
            this.btn_OK = new System.Windows.Forms.Button();
            this.btn_OutPutPath = new System.Windows.Forms.Button();
            this.TextBox_OutputPath = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.panel_Spec = new System.Windows.Forms.Panel();
            this.cbx_LinearFit_4 = new System.Windows.Forms.CheckBox();
            this.cbx_Bias_3 = new System.Windows.Forms.CheckBox();
            this.cbx_EA_2 = new System.Windows.Forms.CheckBox();
            this.cbx_AbsDiffAve_1 = new System.Windows.Forms.CheckBox();
            this.label3 = new System.Windows.Forms.Label();
            this.panel_Spec.SuspendLayout();
            this.SuspendLayout();
            // 
            // btn_Down_Ref
            // 
            this.btn_Down_Ref.Image = ((System.Drawing.Image)(resources.GetObject("btn_Down_Ref.Image")));
            this.btn_Down_Ref.Location = new System.Drawing.Point(662, 116);
            this.btn_Down_Ref.Name = "btn_Down_Ref";
            this.btn_Down_Ref.Size = new System.Drawing.Size(26, 24);
            this.btn_Down_Ref.TabIndex = 73;
            this.btn_Down_Ref.UseVisualStyleBackColor = true;
            this.btn_Down_Ref.Click += new System.EventHandler(this.btn_Down_Ref_Click);
            // 
            // btn_Up_Ref
            // 
            this.btn_Up_Ref.Image = ((System.Drawing.Image)(resources.GetObject("btn_Up_Ref.Image")));
            this.btn_Up_Ref.Location = new System.Drawing.Point(662, 86);
            this.btn_Up_Ref.Name = "btn_Up_Ref";
            this.btn_Up_Ref.Size = new System.Drawing.Size(26, 24);
            this.btn_Up_Ref.TabIndex = 72;
            this.btn_Up_Ref.UseVisualStyleBackColor = true;
            this.btn_Up_Ref.Click += new System.EventHandler(this.btn_Up_Ref_Click);
            // 
            // btn_Down_Ass
            // 
            this.btn_Down_Ass.Image = ((System.Drawing.Image)(resources.GetObject("btn_Down_Ass.Image")));
            this.btn_Down_Ass.Location = new System.Drawing.Point(319, 116);
            this.btn_Down_Ass.Name = "btn_Down_Ass";
            this.btn_Down_Ass.Size = new System.Drawing.Size(26, 24);
            this.btn_Down_Ass.TabIndex = 71;
            this.btn_Down_Ass.UseVisualStyleBackColor = true;
            this.btn_Down_Ass.Click += new System.EventHandler(this.btn_Down_Ass_Click);
            // 
            // btn_Up_Ass
            // 
            this.btn_Up_Ass.Image = ((System.Drawing.Image)(resources.GetObject("btn_Up_Ass.Image")));
            this.btn_Up_Ass.Location = new System.Drawing.Point(319, 86);
            this.btn_Up_Ass.Name = "btn_Up_Ass";
            this.btn_Up_Ass.Size = new System.Drawing.Size(26, 24);
            this.btn_Up_Ass.TabIndex = 70;
            this.btn_Up_Ass.UseVisualStyleBackColor = true;
            this.btn_Up_Ass.Click += new System.EventHandler(this.btn_Up_Ass_Click);
            // 
            // btn_delete_Ref
            // 
            this.btn_delete_Ref.Image = ((System.Drawing.Image)(resources.GetObject("btn_delete_Ref.Image")));
            this.btn_delete_Ref.Location = new System.Drawing.Point(662, 56);
            this.btn_delete_Ref.Name = "btn_delete_Ref";
            this.btn_delete_Ref.Size = new System.Drawing.Size(26, 24);
            this.btn_delete_Ref.TabIndex = 69;
            this.btn_delete_Ref.UseVisualStyleBackColor = true;
            this.btn_delete_Ref.Click += new System.EventHandler(this.btn_delete_Ref_Click);
            // 
            // btn_delete_Ass
            // 
            this.btn_delete_Ass.Image = ((System.Drawing.Image)(resources.GetObject("btn_delete_Ass.Image")));
            this.btn_delete_Ass.Location = new System.Drawing.Point(318, 56);
            this.btn_delete_Ass.Name = "btn_delete_Ass";
            this.btn_delete_Ass.Size = new System.Drawing.Size(26, 24);
            this.btn_delete_Ass.TabIndex = 60;
            this.btn_delete_Ass.UseVisualStyleBackColor = true;
            this.btn_delete_Ass.Click += new System.EventHandler(this.btn_delete_Ass_Click);
            // 
            // listView_Ref
            // 
            this.listView_Ref.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeaderHigh});
            this.listView_Ref.FullRowSelect = true;
            this.listView_Ref.GridLines = true;
            this.listView_Ref.Location = new System.Drawing.Point(356, 56);
            this.listView_Ref.Name = "listView_Ref";
            this.listView_Ref.Size = new System.Drawing.Size(300, 145);
            this.listView_Ref.TabIndex = 68;
            this.listView_Ref.UseCompatibleStateImageBehavior = false;
            this.listView_Ref.View = System.Windows.Forms.View.Details;
            // 
            // columnHeaderHigh
            // 
            this.columnHeaderHigh.Text = "                  已添加文件";
            this.columnHeaderHigh.Width = 634;
            // 
            // listView_Ass
            // 
            this.listView_Ass.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeaderLow});
            this.listView_Ass.FullRowSelect = true;
            this.listView_Ass.GridLines = true;
            this.listView_Ass.Location = new System.Drawing.Point(12, 56);
            this.listView_Ass.Name = "listView_Ass";
            this.listView_Ass.Size = new System.Drawing.Size(300, 145);
            this.listView_Ass.TabIndex = 67;
            this.listView_Ass.UseCompatibleStateImageBehavior = false;
            this.listView_Ass.View = System.Windows.Forms.View.Details;
            // 
            // columnHeaderLow
            // 
            this.columnHeaderLow.Text = "                  已添加文件";
            this.columnHeaderLow.Width = 634;
            // 
            // TextBox_RefImg
            // 
            this.TextBox_RefImg.Location = new System.Drawing.Point(356, 28);
            this.TextBox_RefImg.Name = "TextBox_RefImg";
            this.TextBox_RefImg.Size = new System.Drawing.Size(268, 21);
            this.TextBox_RefImg.TabIndex = 66;
            // 
            // btn_InPutFile_RefImg
            // 
            this.btn_InPutFile_RefImg.Image = ((System.Drawing.Image)(resources.GetObject("btn_InPutFile_RefImg.Image")));
            this.btn_InPutFile_RefImg.Location = new System.Drawing.Point(630, 26);
            this.btn_InPutFile_RefImg.Name = "btn_InPutFile_RefImg";
            this.btn_InPutFile_RefImg.Size = new System.Drawing.Size(26, 24);
            this.btn_InPutFile_RefImg.TabIndex = 65;
            this.btn_InPutFile_RefImg.UseVisualStyleBackColor = true;
            this.btn_InPutFile_RefImg.Click += new System.EventHandler(this.btn_InPutFile_RefImg_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(364, 9);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(53, 12);
            this.label2.TabIndex = 64;
            this.label2.Text = "参考影像";
            // 
            // TextBox_AssImg
            // 
            this.TextBox_AssImg.Location = new System.Drawing.Point(11, 28);
            this.TextBox_AssImg.Name = "TextBox_AssImg";
            this.TextBox_AssImg.Size = new System.Drawing.Size(268, 21);
            this.TextBox_AssImg.TabIndex = 63;
            // 
            // Label1
            // 
            this.Label1.AutoSize = true;
            this.Label1.Location = new System.Drawing.Point(11, 9);
            this.Label1.Name = "Label1";
            this.Label1.Size = new System.Drawing.Size(65, 12);
            this.Label1.TabIndex = 62;
            this.Label1.Text = "待评价影像";
            // 
            // btn_InPutFile_AssImg
            // 
            this.btn_InPutFile_AssImg.Image = ((System.Drawing.Image)(resources.GetObject("btn_InPutFile_AssImg.Image")));
            this.btn_InPutFile_AssImg.Location = new System.Drawing.Point(285, 26);
            this.btn_InPutFile_AssImg.Name = "btn_InPutFile_AssImg";
            this.btn_InPutFile_AssImg.Size = new System.Drawing.Size(26, 24);
            this.btn_InPutFile_AssImg.TabIndex = 61;
            this.btn_InPutFile_AssImg.UseVisualStyleBackColor = true;
            this.btn_InPutFile_AssImg.Click += new System.EventHandler(this.btn_InPutFile_AssImg_Click);
            // 
            // btn_OpenOutputPath
            // 
            this.btn_OpenOutputPath.Location = new System.Drawing.Point(557, 347);
            this.btn_OpenOutputPath.Name = "btn_OpenOutputPath";
            this.btn_OpenOutputPath.Size = new System.Drawing.Size(99, 23);
            this.btn_OpenOutputPath.TabIndex = 80;
            this.btn_OpenOutputPath.Text = "打开输出路径";
            this.btn_OpenOutputPath.UseVisualStyleBackColor = true;
            this.btn_OpenOutputPath.Click += new System.EventHandler(this.btn_OpenOutputPath_Click);
            // 
            // btn_Cancel
            // 
            this.btn_Cancel.Location = new System.Drawing.Point(460, 347);
            this.btn_Cancel.Name = "btn_Cancel";
            this.btn_Cancel.Size = new System.Drawing.Size(58, 23);
            this.btn_Cancel.TabIndex = 79;
            this.btn_Cancel.Text = "取消";
            this.btn_Cancel.UseVisualStyleBackColor = true;
            this.btn_Cancel.Click += new System.EventHandler(this.btn_Cancel_Click);
            // 
            // btn_OK
            // 
            this.btn_OK.Location = new System.Drawing.Point(363, 347);
            this.btn_OK.Name = "btn_OK";
            this.btn_OK.Size = new System.Drawing.Size(58, 23);
            this.btn_OK.TabIndex = 78;
            this.btn_OK.Text = "确定";
            this.btn_OK.UseVisualStyleBackColor = true;
            this.btn_OK.Click += new System.EventHandler(this.btn_OK_Click);
            // 
            // btn_OutPutPath
            // 
            this.btn_OutPutPath.Image = ((System.Drawing.Image)(resources.GetObject("btn_OutPutPath.Image")));
            this.btn_OutPutPath.Location = new System.Drawing.Point(630, 304);
            this.btn_OutPutPath.Name = "btn_OutPutPath";
            this.btn_OutPutPath.Size = new System.Drawing.Size(26, 24);
            this.btn_OutPutPath.TabIndex = 77;
            this.btn_OutPutPath.UseVisualStyleBackColor = true;
            this.btn_OutPutPath.Click += new System.EventHandler(this.btn_OutPutPath_Click);
            // 
            // TextBox_OutputPath
            // 
            this.TextBox_OutputPath.Location = new System.Drawing.Point(11, 307);
            this.TextBox_OutputPath.Name = "TextBox_OutputPath";
            this.TextBox_OutputPath.Size = new System.Drawing.Size(613, 21);
            this.TextBox_OutputPath.TabIndex = 76;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(11, 285);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(53, 12);
            this.label6.TabIndex = 75;
            this.label6.Text = "输出文件";
            // 
            // panel_Spec
            // 
            this.panel_Spec.Controls.Add(this.cbx_LinearFit_4);
            this.panel_Spec.Controls.Add(this.cbx_Bias_3);
            this.panel_Spec.Controls.Add(this.cbx_EA_2);
            this.panel_Spec.Controls.Add(this.cbx_AbsDiffAve_1);
            this.panel_Spec.Location = new System.Drawing.Point(71, 228);
            this.panel_Spec.Name = "panel_Spec";
            this.panel_Spec.Size = new System.Drawing.Size(455, 37);
            this.panel_Spec.TabIndex = 81;
            // 
            // cbx_LinearFit_4
            // 
            this.cbx_LinearFit_4.AutoSize = true;
            this.cbx_LinearFit_4.Location = new System.Drawing.Point(314, 17);
            this.cbx_LinearFit_4.Name = "cbx_LinearFit_4";
            this.cbx_LinearFit_4.Size = new System.Drawing.Size(72, 16);
            this.cbx_LinearFit_4.TabIndex = 68;
            this.cbx_LinearFit_4.Text = "线性拟合";
            this.cbx_LinearFit_4.UseVisualStyleBackColor = true;
            // 
            // cbx_Bias_3
            // 
            this.cbx_Bias_3.AutoSize = true;
            this.cbx_Bias_3.Location = new System.Drawing.Point(221, 17);
            this.cbx_Bias_3.Name = "cbx_Bias_3";
            this.cbx_Bias_3.Size = new System.Drawing.Size(84, 16);
            this.cbx_Bias_3.TabIndex = 67;
            this.cbx_Bias_3.Text = "Bias(偏差)";
            this.cbx_Bias_3.UseVisualStyleBackColor = true;
            // 
            // cbx_EA_2
            // 
            this.cbx_EA_2.AutoSize = true;
            this.cbx_EA_2.Location = new System.Drawing.Point(114, 17);
            this.cbx_EA_2.Name = "cbx_EA_2";
            this.cbx_EA_2.Size = new System.Drawing.Size(96, 16);
            this.cbx_EA_2.TabIndex = 66;
            this.cbx_EA_2.Text = "EA(估算精度)";
            this.cbx_EA_2.UseVisualStyleBackColor = true;
            // 
            // cbx_AbsDiffAve_1
            // 
            this.cbx_AbsDiffAve_1.AutoSize = true;
            this.cbx_AbsDiffAve_1.Location = new System.Drawing.Point(16, 17);
            this.cbx_AbsDiffAve_1.Name = "cbx_AbsDiffAve_1";
            this.cbx_AbsDiffAve_1.Size = new System.Drawing.Size(84, 16);
            this.cbx_AbsDiffAve_1.TabIndex = 65;
            this.cbx_AbsDiffAve_1.Text = "绝对差均值";
            this.cbx_AbsDiffAve_1.UseVisualStyleBackColor = true;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(11, 246);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(53, 12);
            this.label3.TabIndex = 82;
            this.label3.Text = "评价指标";
            // 
            // TSQuaAssForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(698, 381);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.panel_Spec);
            this.Controls.Add(this.btn_OpenOutputPath);
            this.Controls.Add(this.btn_Cancel);
            this.Controls.Add(this.btn_OK);
            this.Controls.Add(this.btn_OutPutPath);
            this.Controls.Add(this.TextBox_OutputPath);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.btn_Down_Ref);
            this.Controls.Add(this.btn_Up_Ref);
            this.Controls.Add(this.btn_Down_Ass);
            this.Controls.Add(this.btn_Up_Ass);
            this.Controls.Add(this.btn_delete_Ref);
            this.Controls.Add(this.btn_delete_Ass);
            this.Controls.Add(this.listView_Ref);
            this.Controls.Add(this.listView_Ass);
            this.Controls.Add(this.TextBox_RefImg);
            this.Controls.Add(this.btn_InPutFile_RefImg);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.TextBox_AssImg);
            this.Controls.Add(this.Label1);
            this.Controls.Add(this.btn_InPutFile_AssImg);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "TSQuaAssForm";
            this.Text = "时空融合质量评价";
            this.Load += new System.EventHandler(this.TSQuaAssForm_Load);
            this.panel_Spec.ResumeLayout(false);
            this.panel_Spec.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btn_Down_Ref;
        private System.Windows.Forms.Button btn_Up_Ref;
        private System.Windows.Forms.Button btn_Down_Ass;
        private System.Windows.Forms.Button btn_Up_Ass;
        private System.Windows.Forms.Button btn_delete_Ref;
        private System.Windows.Forms.Button btn_delete_Ass;
        private System.Windows.Forms.ListView listView_Ref;
        private System.Windows.Forms.ColumnHeader columnHeaderHigh;
        private System.Windows.Forms.ListView listView_Ass;
        private System.Windows.Forms.ColumnHeader columnHeaderLow;
        private System.Windows.Forms.TextBox TextBox_RefImg;
        private System.Windows.Forms.Button btn_InPutFile_RefImg;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox TextBox_AssImg;
        private System.Windows.Forms.Label Label1;
        private System.Windows.Forms.Button btn_InPutFile_AssImg;
        private System.Windows.Forms.Button btn_OpenOutputPath;
        private System.Windows.Forms.Button btn_Cancel;
        private System.Windows.Forms.Button btn_OK;
        private System.Windows.Forms.Button btn_OutPutPath;
        private System.Windows.Forms.TextBox TextBox_OutputPath;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Panel panel_Spec;
        private System.Windows.Forms.CheckBox cbx_Bias_3;
        private System.Windows.Forms.CheckBox cbx_EA_2;
        private System.Windows.Forms.CheckBox cbx_AbsDiffAve_1;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.CheckBox cbx_LinearFit_4;
    }
}