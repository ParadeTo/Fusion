using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Windows.Forms;
using System.Drawing;
using System;
using System.Drawing.Drawing2D;

namespace Fusion
{
    public partial class UserControl_Color : UserControl
    {

        private Color _FromColor;
        private Color _ToColor;
        public Color FromColor
        {
            get { return _FromColor; }
            set { _FromColor = value; }
        }

        public Color ToColor
        {
            get { return _ToColor; }
            set { _ToColor = value; }
        }
        public event EventHandler SelectColorChanged;
        //预定义的渐变色
        private static string[] colorList =
        {

            "Bisque|Black","BlanchedAlmond|Blue","BlueViolet|Brown",

            "BurlyWood|CadetBlue","Chartreuse|Chocolate",

            "CornflowerBlue|Cornsilk","Crimson|Cyan","DarkBlue|DarkCyan",

            "DarkGoldenrod|DarkGray","DarkGreen|DarkKhaki",

            "DarkMagenta|DarkOliveGreen","DarkOrange|DarkOrchid"

        };
        public UserControl_Color()
        {
            InitializeComponent();
            PersonalizeComponent();
        }
        private void PersonalizeComponent()
        {
            this.comboBox1.DrawMode = DrawMode.OwnerDrawFixed;
            this.comboBox1.DropDownStyle = ComboBoxStyle.DropDownList;
            this.comboBox1.ItemHeight = 15;
            this.comboBox1.BeginUpdate();
            this.comboBox1.Items.Clear();
            foreach (string oneColor in colorList)
            {
                this.comboBox1.Items.Add(oneColor);
            }
            this.comboBox1.EndUpdate();
        }
        private void comboBox1_DrawItem(object sender, System.Windows.Forms.DrawItemEventArgs e)
        {
              if (e.Index < 0)
                return;
            Rectangle rect = e.Bounds;
            //读取起始、终止颜色值
            string fColorName = comboBox1.Items[e.Index].ToString().Split('|')[0];
            string tColorName = comboBox1.Items[e.Index].ToString().Split('|')[1];
            _FromColor = Color.FromName(fColorName);
            _ToColor = Color.FromName(tColorName);
            //选择线性渐变刷子
            LinearGradientBrush brush = new LinearGradientBrush(rect, _FromColor, _ToColor, 0, false);
            rect.Inflate(-1, -1);
            // 填充颜色
            e.Graphics.FillRectangle(brush, rect);
            // 绘制边框
            e.Graphics.DrawRectangle(Pens.Black, rect);
        }

        private void comboBox1_SelectedIndexChanged(object sender, System.EventArgs e)
        {
            if (SelectColorChanged != null)
            {
                SelectColorChanged(this, e);
            }
        }
    }       
}

