namespace Fusion
{
    partial class TSFusionForm
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(TSFusionForm));
            this.TextBox_HighPath = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.TextBox_LowPath = new System.Windows.Forms.TextBox();
            this.Label1 = new System.Windows.Forms.Label();
            this.cbx_Method = new System.Windows.Forms.ComboBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.TextBox_OutputPath = new System.Windows.Forms.TextBox();
            this.btn_OpenOutputPath = new System.Windows.Forms.Button();
            this.btn_Cancel = new System.Windows.Forms.Button();
            this.btn_OK = new System.Windows.Forms.Button();
            this.cbx_WinSize = new System.Windows.Forms.ComboBox();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.traBar_TWinSize = new System.Windows.Forms.TrackBar();
            this.label6 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.txt_TWinSize = new System.Windows.Forms.TextBox();
            this.btn_OutputPath = new System.Windows.Forms.Button();
            this.btn_InPutFile_High = new System.Windows.Forms.Button();
            this.btn_InPutFile_Low = new System.Windows.Forms.Button();
            this.dataGridView = new System.Windows.Forms.DataGridView();
            this.Date = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.LowFile = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.HighFile = new System.Windows.Forms.DataGridViewTextBoxColumn();
            ((System.ComponentModel.ISupportInitialize)(this.traBar_TWinSize)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView)).BeginInit();
            this.SuspendLayout();
            // 
            // TextBox_HighPath
            // 
            this.TextBox_HighPath.Location = new System.Drawing.Point(269, 33);
            this.TextBox_HighPath.Name = "TextBox_HighPath";
            this.TextBox_HighPath.Size = new System.Drawing.Size(200, 21);
            this.TextBox_HighPath.TabIndex = 52;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(274, 14);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(77, 12);
            this.label2.TabIndex = 50;
            this.label2.Text = "高分辨率影像";
            // 
            // TextBox_LowPath
            // 
            this.TextBox_LowPath.Location = new System.Drawing.Point(19, 33);
            this.TextBox_LowPath.Name = "TextBox_LowPath";
            this.TextBox_LowPath.Size = new System.Drawing.Size(200, 21);
            this.TextBox_LowPath.TabIndex = 49;
            // 
            // Label1
            // 
            this.Label1.AutoSize = true;
            this.Label1.Location = new System.Drawing.Point(19, 14);
            this.Label1.Name = "Label1";
            this.Label1.Size = new System.Drawing.Size(77, 12);
            this.Label1.TabIndex = 48;
            this.Label1.Text = "低分辨率影像";
            // 
            // cbx_Method
            // 
            this.cbx_Method.FormattingEnabled = true;
            this.cbx_Method.Location = new System.Drawing.Point(21, 246);
            this.cbx_Method.Name = "cbx_Method";
            this.cbx_Method.Size = new System.Drawing.Size(121, 20);
            this.cbx_Method.TabIndex = 61;
            this.cbx_Method.SelectedIndexChanged += new System.EventHandler(this.cbx_Method_SelectedIndexChanged);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(19, 222);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(53, 12);
            this.label3.TabIndex = 60;
            this.label3.Text = "融合方法";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(21, 274);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(53, 12);
            this.label8.TabIndex = 64;
            this.label8.Text = "输出路径";
            // 
            // TextBox_OutputPath
            // 
            this.TextBox_OutputPath.Location = new System.Drawing.Point(21, 294);
            this.TextBox_OutputPath.Name = "TextBox_OutputPath";
            this.TextBox_OutputPath.Size = new System.Drawing.Size(448, 21);
            this.TextBox_OutputPath.TabIndex = 63;
            // 
            // btn_OpenOutputPath
            // 
            this.btn_OpenOutputPath.Location = new System.Drawing.Point(402, 327);
            this.btn_OpenOutputPath.Name = "btn_OpenOutputPath";
            this.btn_OpenOutputPath.Size = new System.Drawing.Size(99, 22);
            this.btn_OpenOutputPath.TabIndex = 67;
            this.btn_OpenOutputPath.Text = "打开输出路径";
            this.btn_OpenOutputPath.UseVisualStyleBackColor = true;
            this.btn_OpenOutputPath.Click += new System.EventHandler(this.btn_OpenOutputPath_Click);
            // 
            // btn_Cancel
            // 
            this.btn_Cancel.Location = new System.Drawing.Point(305, 327);
            this.btn_Cancel.Name = "btn_Cancel";
            this.btn_Cancel.Size = new System.Drawing.Size(58, 22);
            this.btn_Cancel.TabIndex = 66;
            this.btn_Cancel.Text = "取消";
            this.btn_Cancel.UseVisualStyleBackColor = true;
            this.btn_Cancel.Click += new System.EventHandler(this.btn_Cancel_Click);
            // 
            // btn_OK
            // 
            this.btn_OK.Location = new System.Drawing.Point(208, 327);
            this.btn_OK.Name = "btn_OK";
            this.btn_OK.Size = new System.Drawing.Size(58, 22);
            this.btn_OK.TabIndex = 65;
            this.btn_OK.Text = "确定";
            this.btn_OK.UseVisualStyleBackColor = true;
            this.btn_OK.Click += new System.EventHandler(this.btn_OK_Click);
            // 
            // cbx_WinSize
            // 
            this.cbx_WinSize.FormattingEnabled = true;
            this.cbx_WinSize.Location = new System.Drawing.Point(167, 246);
            this.cbx_WinSize.Name = "cbx_WinSize";
            this.cbx_WinSize.Size = new System.Drawing.Size(121, 20);
            this.cbx_WinSize.TabIndex = 69;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(165, 222);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(125, 12);
            this.label4.TabIndex = 68;
            this.label4.Text = "相似像元搜索窗口大小";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(333, 222);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(125, 12);
            this.label5.TabIndex = 70;
            this.label5.Text = "基准影像搜索窗口大小";
            // 
            // traBar_TWinSize
            // 
            this.traBar_TWinSize.Location = new System.Drawing.Point(330, 246);
            this.traBar_TWinSize.Name = "traBar_TWinSize";
            this.traBar_TWinSize.Size = new System.Drawing.Size(104, 45);
            this.traBar_TWinSize.TabIndex = 71;
            this.traBar_TWinSize.Scroll += new System.EventHandler(this.traBar_TWinSize_Scroll);
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(324, 249);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(11, 12);
            this.label6.TabIndex = 72;
            this.label6.Text = "1";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(427, 249);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(17, 12);
            this.label7.TabIndex = 73;
            this.label7.Text = "48";
            // 
            // txt_TWinSize
            // 
            this.txt_TWinSize.Location = new System.Drawing.Point(450, 249);
            this.txt_TWinSize.Name = "txt_TWinSize";
            this.txt_TWinSize.ReadOnly = true;
            this.txt_TWinSize.Size = new System.Drawing.Size(39, 21);
            this.txt_TWinSize.TabIndex = 74;
            // 
            // btn_OutputPath
            // 
            this.btn_OutputPath.Image = ((System.Drawing.Image)(resources.GetObject("btn_OutputPath.Image")));
            this.btn_OutputPath.Location = new System.Drawing.Point(475, 291);
            this.btn_OutputPath.Name = "btn_OutputPath";
            this.btn_OutputPath.Size = new System.Drawing.Size(26, 24);
            this.btn_OutputPath.TabIndex = 62;
            this.btn_OutputPath.UseVisualStyleBackColor = true;
            this.btn_OutputPath.Click += new System.EventHandler(this.btn_OutputPath_Click);
            // 
            // btn_InPutFile_High
            // 
            this.btn_InPutFile_High.Image = ((System.Drawing.Image)(resources.GetObject("btn_InPutFile_High.Image")));
            this.btn_InPutFile_High.Location = new System.Drawing.Point(475, 30);
            this.btn_InPutFile_High.Name = "btn_InPutFile_High";
            this.btn_InPutFile_High.Size = new System.Drawing.Size(26, 24);
            this.btn_InPutFile_High.TabIndex = 51;
            this.btn_InPutFile_High.UseVisualStyleBackColor = true;
            this.btn_InPutFile_High.Click += new System.EventHandler(this.btn_InPutFile_High_Click);
            // 
            // btn_InPutFile_Low
            // 
            this.btn_InPutFile_Low.Image = ((System.Drawing.Image)(resources.GetObject("btn_InPutFile_Low.Image")));
            this.btn_InPutFile_Low.Location = new System.Drawing.Point(225, 30);
            this.btn_InPutFile_Low.Name = "btn_InPutFile_Low";
            this.btn_InPutFile_Low.Size = new System.Drawing.Size(26, 24);
            this.btn_InPutFile_Low.TabIndex = 47;
            this.btn_InPutFile_Low.UseVisualStyleBackColor = true;
            this.btn_InPutFile_Low.Click += new System.EventHandler(this.btn_InPutFile_Low_Click);
            // 
            // dataGridView
            // 
            this.dataGridView.BackgroundColor = System.Drawing.SystemColors.HighlightText;
            this.dataGridView.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.Raised;
            this.dataGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.Date,
            this.LowFile,
            this.HighFile});
            this.dataGridView.GridColor = System.Drawing.SystemColors.InactiveCaptionText;
            this.dataGridView.Location = new System.Drawing.Point(19, 63);
            this.dataGridView.Name = "dataGridView";
            this.dataGridView.RowTemplate.Height = 23;
            this.dataGridView.Size = new System.Drawing.Size(482, 145);
            this.dataGridView.TabIndex = 75;
            // 
            // Date
            // 
            this.Date.HeaderText = "日期";
            this.Date.Name = "Date";
            this.Date.ReadOnly = true;
            // 
            // LowFile
            // 
            this.LowFile.HeaderText = "低空间分辨率影像";
            this.LowFile.Name = "LowFile";
            this.LowFile.ReadOnly = true;
            this.LowFile.Width = 200;
            // 
            // HighFile
            // 
            this.HighFile.HeaderText = "高空间分辨率影像";
            this.HighFile.Name = "HighFile";
            this.HighFile.ReadOnly = true;
            this.HighFile.Width = 200;
            // 
            // TSFusionForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(516, 359);
            this.Controls.Add(this.dataGridView);
            this.Controls.Add(this.txt_TWinSize);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.traBar_TWinSize);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.cbx_WinSize);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.btn_OpenOutputPath);
            this.Controls.Add(this.btn_Cancel);
            this.Controls.Add(this.btn_OK);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.TextBox_OutputPath);
            this.Controls.Add(this.btn_OutputPath);
            this.Controls.Add(this.cbx_Method);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.TextBox_HighPath);
            this.Controls.Add(this.btn_InPutFile_High);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.TextBox_LowPath);
            this.Controls.Add(this.Label1);
            this.Controls.Add(this.btn_InPutFile_Low);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "TSFusionForm";
            this.Text = "时空融合";
            this.Load += new System.EventHandler(this.TSFusionForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.traBar_TWinSize)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox TextBox_HighPath;
        private System.Windows.Forms.Button btn_InPutFile_High;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox TextBox_LowPath;
        private System.Windows.Forms.Label Label1;
        private System.Windows.Forms.Button btn_InPutFile_Low;
        private System.Windows.Forms.ComboBox cbx_Method;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.TextBox TextBox_OutputPath;
        private System.Windows.Forms.Button btn_OutputPath;
        private System.Windows.Forms.Button btn_OpenOutputPath;
        private System.Windows.Forms.Button btn_Cancel;
        private System.Windows.Forms.Button btn_OK;
        private System.Windows.Forms.ComboBox cbx_WinSize;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TrackBar traBar_TWinSize;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox txt_TWinSize;
        private System.Windows.Forms.DataGridView dataGridView;
        private System.Windows.Forms.DataGridViewTextBoxColumn Date;
        private System.Windows.Forms.DataGridViewTextBoxColumn LowFile;
        private System.Windows.Forms.DataGridViewTextBoxColumn HighFile;

    }
}