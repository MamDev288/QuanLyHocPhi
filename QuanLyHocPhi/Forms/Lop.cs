using QuanLyHocPhi.Services;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.Entity;
using System.Drawing;
using System.Linq;
using System.Net.NetworkInformation;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QuanLyHocPhi.Forms
{
    public partial class Lop : Form
    {
        public Lop()
        {
            InitializeComponent();
        }
        Models.Lop l;
        private List<Object> renderGrid()
        {
            List<Models.Lop> render = Program.db.Lops.ToList();
            if (txtFilter.Text != "")
            {
                string key = txtFilter.Text;
                render = render.Where(u => u.TenLop.Contains(key)).ToList();
            }
            List<Object> list = render.Select(u => new {
                id = u.id,
                TenLop = u.TenLop,
                
            }).ToList<Object>();
            return list;
        }
        private void Lop_Load(object sender, EventArgs e)
        {
            GridViewServices.GenDataGridView(dataGridView1, renderGrid());
            groupBox1.Enabled = false;

        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (textBox1.Text == "" && l != null)
                return;
            if (l.id == 0) 
                Program.db.sp_AddLop(textBox1.Text);
            else
                Program.db.sp_EditLop(l.id,textBox1.Text);
            GridViewServices.GenDataGridView(dataGridView1, renderGrid());
            groupBox1.Enabled = false;

        }

        private void button2_Click(object sender, EventArgs e)
        {
            l = new Models.Lop();
            groupBox1.Enabled = true;

        }

        private void button3_Click(object sender, EventArgs e)
        {
            l = Program.db.Lops.FirstOrDefault(u => u.id == 1) ;
            GridViewServices.GenDataGridView(dataGridView1, renderGrid());

        }

        private void button4_Click(object sender, EventArgs e)
        {
            if(MessageBox.Show("Bạn có muốn xoá lớp này không ?", "Thông báo", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                Program.db.sp_DeleteLop(0);
                GridViewServices.GenDataGridView(dataGridView1, renderGrid());
            }

        }

        private void txtFilter_TextChanged(object sender, EventArgs e)
        {
            GridViewServices.GenDataGridView(dataGridView1, renderGrid());

        }
    }
}
