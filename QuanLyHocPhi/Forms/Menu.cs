using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QuanLyHocPhi.Forms
{
    public partial class Menu : Form
    {
        public Menu()
        {
            InitializeComponent();
        }

        private void Menu_Load(object sender, EventArgs e)
        {
            label2.Text = Program.userLogin.HoTen;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Lop f = new Lop();
            f.ShowDialog();
        }
    }
}
