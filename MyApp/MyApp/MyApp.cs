using System;
using System.Drawing;
using System.Windows.Forms;

namespace MyApp
{
    public class MyApp : Form
    {
        private TextBox txtBox = new TextBox();
        private Button btnAdd = new Button();
        private ListBox lstBox = new ListBox();
        private CheckBox chkBox = new CheckBox();
        private Label lblCount = new Label();

        public MyApp()
        {
            //Set up the form.
            Name = "PGIS - Vaja1";
            Text = "PGIS routing";
            MaximizeBox = false;
            MinimizeBox = false;
            BackColor = Color.White;
            ForeColor = Color.Black;
            Size = new System.Drawing.Size(155, 265);
            FormBorderStyle = FormBorderStyle.FixedDialog;
            StartPosition = FormStartPosition.CenterScreen;
            //Format controls. Note: Controls inherit color from parent form.
            btnAdd.BackColor = Color.Gray;
            btnAdd.Text = "Add";
            btnAdd.Location = new System.Drawing.Point(90, 25);
            btnAdd.Size = new System.Drawing.Size(50, 25);
            btnAdd.Click += new EventHandler(btnAdd_Click);

            txtBox.Text = "Text";
            txtBox.Location = new System.Drawing.Point(10, 25);
            txtBox.Size = new System.Drawing.Size(70, 20);

            lstBox.Items.Add("One");
            lstBox.Items.Add("Two");
            lstBox.Items.Add("Three");
            lstBox.Items.Add("Four");
            lstBox.Sorted = true;
            lstBox.Location = new System.Drawing.Point(10, 55);
            lstBox.Size = new System.Drawing.Size(130, 95);

            chkBox.Text = "Disable";
            chkBox.Location = new System.Drawing.Point(15, 190);
            chkBox.Size = new System.Drawing.Size(110, 30);

            lblCount.Text = lstBox.Items.Count.ToString() + " items";
            lblCount.Location = new System.Drawing.Point(55, 160);
            lblCount.Size = new System.Drawing.Size(65, 15);

            //Add controls to the form.
            Controls.Add(btnAdd);
            Controls.Add(txtBox);
            Controls.Add(lstBox);
            Controls.Add(chkBox);
            Controls.Add(lblCount);
        }

        public void btnAdd_Click(object sender, EventArgs e)
        {
            if (!chkBox.Checked)
            {
                lstBox.Items.Add(txtBox.Text.ToString());
                lblCount.Text = lstBox.Items.Count.ToString() + " items";
            }
        }

        public static void Main()
        {
            var f = new MyApp();
            Application.Run(f);
        }
    }
}
