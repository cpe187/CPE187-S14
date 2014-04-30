namespace CANTachometer
{
    partial class Form1
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
            this.components = new System.ComponentModel.Container();
            this.lstComPorts = new System.Windows.Forms.ComboBox();
            this.label1 = new System.Windows.Forms.Label();
            this.btnWrite = new System.Windows.Forms.Button();
            this.comPort = new System.IO.Ports.SerialPort(this.components);
            this.label2 = new System.Windows.Forms.Label();
            this.txtGreen = new System.Windows.Forms.TextBox();
            this.txtYellow = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.txtRed = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.txtFlashingRed = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.txtCANAddress = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.btnRead = new System.Windows.Forms.Button();
            this.btnCOMOpenClose = new System.Windows.Forms.Button();
            this.btnRefreshPorts = new System.Windows.Forms.Button();
            this.toolTip1 = new System.Windows.Forms.ToolTip(this.components);
            this.SuspendLayout();
            // 
            // lstComPorts
            // 
            this.lstComPorts.FormattingEnabled = true;
            this.lstComPorts.Location = new System.Drawing.Point(71, 12);
            this.lstComPorts.Name = "lstComPorts";
            this.lstComPorts.Size = new System.Drawing.Size(67, 21);
            this.lstComPorts.TabIndex = 1;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 15);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(53, 13);
            this.label1.TabIndex = 2;
            this.label1.Text = "COM Port";
            // 
            // btnWrite
            // 
            this.btnWrite.Location = new System.Drawing.Point(173, 170);
            this.btnWrite.Name = "btnWrite";
            this.btnWrite.Size = new System.Drawing.Size(75, 22);
            this.btnWrite.TabIndex = 7;
            this.btnWrite.Text = "Write";
            this.toolTip1.SetToolTip(this.btnWrite, "Write data to device");
            this.btnWrite.UseVisualStyleBackColor = true;
            this.btnWrite.Click += new System.EventHandler(this.btnWrite_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(12, 43);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(36, 13);
            this.label2.TabIndex = 9;
            this.label2.Text = "Green";
            // 
            // txtGreen
            // 
            this.txtGreen.Location = new System.Drawing.Point(87, 40);
            this.txtGreen.Name = "txtGreen";
            this.txtGreen.Size = new System.Drawing.Size(161, 20);
            this.txtGreen.TabIndex = 10;
            // 
            // txtYellow
            // 
            this.txtYellow.Location = new System.Drawing.Point(87, 66);
            this.txtYellow.Name = "txtYellow";
            this.txtYellow.Size = new System.Drawing.Size(161, 20);
            this.txtYellow.TabIndex = 12;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(12, 69);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(38, 13);
            this.label3.TabIndex = 11;
            this.label3.Text = "Yellow";
            // 
            // txtRed
            // 
            this.txtRed.Location = new System.Drawing.Point(87, 92);
            this.txtRed.Name = "txtRed";
            this.txtRed.Size = new System.Drawing.Size(161, 20);
            this.txtRed.TabIndex = 14;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(12, 95);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(27, 13);
            this.label4.TabIndex = 13;
            this.label4.Text = "Red";
            // 
            // txtFlashingRed
            // 
            this.txtFlashingRed.Location = new System.Drawing.Point(87, 118);
            this.txtFlashingRed.Name = "txtFlashingRed";
            this.txtFlashingRed.Size = new System.Drawing.Size(161, 20);
            this.txtFlashingRed.TabIndex = 16;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(12, 121);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(69, 13);
            this.label5.TabIndex = 15;
            this.label5.Text = "Flashing Red";
            // 
            // txtCANAddress
            // 
            this.txtCANAddress.Location = new System.Drawing.Point(87, 144);
            this.txtCANAddress.Name = "txtCANAddress";
            this.txtCANAddress.Size = new System.Drawing.Size(161, 20);
            this.txtCANAddress.TabIndex = 18;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(12, 147);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(70, 13);
            this.label6.TabIndex = 17;
            this.label6.Text = "CAN Address";
            // 
            // btnRead
            // 
            this.btnRead.Location = new System.Drawing.Point(12, 170);
            this.btnRead.Name = "btnRead";
            this.btnRead.Size = new System.Drawing.Size(75, 22);
            this.btnRead.TabIndex = 19;
            this.btnRead.Text = "Read";
            this.toolTip1.SetToolTip(this.btnRead, "Read data from device");
            this.btnRead.UseVisualStyleBackColor = true;
            this.btnRead.Click += new System.EventHandler(this.btnRead_Click);
            // 
            // btnCOMOpenClose
            // 
            this.btnCOMOpenClose.Location = new System.Drawing.Point(203, 11);
            this.btnCOMOpenClose.Name = "btnCOMOpenClose";
            this.btnCOMOpenClose.Size = new System.Drawing.Size(45, 23);
            this.btnCOMOpenClose.TabIndex = 20;
            this.btnCOMOpenClose.Text = "Open";
            this.toolTip1.SetToolTip(this.btnCOMOpenClose, "Connect to selected COM Port");
            this.btnCOMOpenClose.UseVisualStyleBackColor = true;
            this.btnCOMOpenClose.Click += new System.EventHandler(this.btnCOMOpenClose_Click);
            // 
            // btnRefreshPorts
            // 
            this.btnRefreshPorts.Location = new System.Drawing.Point(144, 11);
            this.btnRefreshPorts.Name = "btnRefreshPorts";
            this.btnRefreshPorts.Size = new System.Drawing.Size(53, 23);
            this.btnRefreshPorts.TabIndex = 21;
            this.btnRefreshPorts.Text = "Refresh";
            this.toolTip1.SetToolTip(this.btnRefreshPorts, "Refresh COM Ports list");
            this.btnRefreshPorts.UseVisualStyleBackColor = true;
            this.btnRefreshPorts.Click += new System.EventHandler(this.btnRefreshPorts_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(260, 204);
            this.Controls.Add(this.btnRefreshPorts);
            this.Controls.Add(this.btnCOMOpenClose);
            this.Controls.Add(this.btnRead);
            this.Controls.Add(this.txtCANAddress);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.txtFlashingRed);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.txtRed);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.txtYellow);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.txtGreen);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.btnWrite);
            this.Controls.Add(this.lstComPorts);
            this.Controls.Add(this.label1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "Form1";
            this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide;
            this.Text = "CAN Tachometer";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Form1_FormClosing);
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ComboBox lstComPorts;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button btnWrite;
        private System.IO.Ports.SerialPort comPort;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtGreen;
        private System.Windows.Forms.TextBox txtYellow;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox txtRed;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox txtFlashingRed;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox txtCANAddress;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Button btnRead;
        private System.Windows.Forms.Button btnCOMOpenClose;
        private System.Windows.Forms.Button btnRefreshPorts;
        private System.Windows.Forms.ToolTip toolTip1;

    }
}

