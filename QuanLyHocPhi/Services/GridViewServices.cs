using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QuanLyHocPhi.Services
{
    public class GridViewServices
    {
        public static void GenDataGridView(DataGridView dgv, dynamic data)
        {
            if (data.Count == 0)
            {
                return;
            }
            dgv.Columns.Clear();
            dgv.DataSource = data;
            dgv.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
        }
    }
}
