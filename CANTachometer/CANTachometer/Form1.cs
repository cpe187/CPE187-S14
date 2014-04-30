using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO.Ports;

namespace CANTachometer
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            /*
             * Get list of COM ports
             */
            btnRefreshPorts_Click(this, null);

            /*
             * Enable/Disable appropriate controls
             */
            btnRead.Enabled = false;
            btnWrite.Enabled = false;
            txtGreen.Enabled = false;
            txtYellow.Enabled = false;
            txtRed.Enabled = false;
            txtFlashingRed.Enabled = false;
            txtCANAddress.Enabled = false;

        }

        private void btnCOMOpenClose_Click(object sender, EventArgs e)
        {
            if (!comPort.IsOpen) {
                /*
                 * Connect
                 */
                if (lstComPorts.SelectedIndex > -1) {
                    comPort.PortName = lstComPorts.SelectedItem.ToString();
                    try {
                        comPort.Open();
                        /*
                         * Enable/Disable appropriate controls
                         */
                        btnCOMOpenClose.Text = "Close";
                        btnRead.Enabled = true;
                        btnWrite.Enabled = true;
                        txtGreen.Enabled = true;
                        txtYellow.Enabled = true;
                        txtRed.Enabled = true;
                        txtFlashingRed.Enabled = true;
                        txtCANAddress.Enabled = true;
                        lstComPorts.Enabled = false;
                        btnRefreshPorts.Enabled = false;

                        // Read values from device
                        btnRead_Click(this, null);
                    } catch (UnauthorizedAccessException error) {
                        MessageBox.Show(error.Message);
                    }
                } else {
                    MessageBox.Show("Select a COM port.");
                }

            } else {
                /*
                 * Disconnect
                 */
                comPort.Close();

                // Enable/Disable appropriate controls
                btnCOMOpenClose.Text = "Open";
                btnRead.Enabled = false;
                btnWrite.Enabled = false;
                txtGreen.Enabled = false;
                txtYellow.Enabled = false;
                txtRed.Enabled = false;
                txtFlashingRed.Enabled = false;
                txtCANAddress.Enabled = false;
                lstComPorts.Enabled = true;
                btnRefreshPorts.Enabled = true;
            }
        }

        private void btnWrite_Click(object sender, EventArgs e)
        {
            /*
             * Message format for writing data to device:
             * [identifier][upper byte][lower byte]
             * 
             * Identifier   Setting destination
             * 0x81         Green tachometer setting
             * 0x82         Yellow tachometer setting
             * 0x83         Red tachometer setting
             * 0x84         Flashing red tachometer setting
             * 0x85         CAN address
             */
            writeValue(0x81, UInt16.Parse(txtGreen.Text));
            writeValue(0x82, UInt16.Parse(txtYellow.Text));
            writeValue(0x83, UInt16.Parse(txtRed.Text));
            writeValue(0x84, UInt16.Parse(txtFlashingRed.Text));
            writeValue(0x85, UInt16.Parse(txtCANAddress.Text));
        }

        private void btnRead_Click(object sender, EventArgs e)
        {
            /*
             * Message format for reading data from device:
             * [identifier]
             * 
             * Identifier   Setting destination
             * 0x01         Green tachometer setting
             * 0x02         Yellow tachometer setting
             * 0x03         Red tachometer setting
             * 0x04         Flashing red tachometer setting
             * 0x05         CAN address
             */

            txtGreen.Text = readValue(0x01).ToString();
            txtYellow.Text = readValue(0x02).ToString();
            txtRed.Text = readValue(0x03).ToString();
            txtFlashingRed.Text = readValue(0x04).ToString();
            txtCANAddress.Text = readValue(0x05).ToString();
        }

        /*
         * Reads a value from the specified register
         * 
         * Parameter    Description
         * register     What register to read
         * 
         * Returns a UInt16 of the value in the register
         */
        private UInt16 readValue(byte register)
        {
            byte[] bytes = new byte[1];
            bytes[0] = register;

            comPort.Write(bytes, 0, bytes.Length);

            byte upper = (byte)comPort.ReadByte();
            byte lower = (byte)comPort.ReadByte();
            comPort.ReadExisting(); // clear rest of buffer

            MessageBox.Show(((UInt16)((upper << 8) | lower)).ToString());

            return (UInt16)((upper << 8) | lower);
        }

        /*
         * Write a value to the specified register
         * 
         * Parameter    Description
         * register     The register to write
         * value        The value to write
         * 
         * No return value
         */
        private void writeValue(byte register, UInt16 value)
        {
            byte[] bytes = new byte[3];
            bytes[0] = register;
            bytes[1] = (byte)(value >> 8); // upper
            bytes[2] = (byte)(value & 0x00FF); // lower

            comPort.Write(bytes, 0, 3);

        }

        private void btnRefreshPorts_Click(object sender, EventArgs e)
        {
            string[] ports = SerialPort.GetPortNames();
            lstComPorts.Items.Clear();
            lstComPorts.Items.AddRange(ports);
            if (lstComPorts.Items.Count > 0) {
                lstComPorts.SelectedIndex = 0;
            }
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (comPort.IsOpen) {
                comPort.Close();
            }
        }
    }
}
