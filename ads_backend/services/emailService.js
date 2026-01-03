require('dotenv').config(); // Load .env variables
const nodemailer = require('nodemailer');


const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

const sendEmergencyEmail = async (to, subject, html) => {
  const mailOptions = {
    from: `"ADS Alert 🚨" <${process.env.EMAIL_USER}>`,
    to,
    subject,
    html,
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log(`✅ Email sent to ${to}`);
  } catch (err) {
    console.error(`❌ Email failed to ${to}`, err);
  }
};

module.exports = sendEmergencyEmail;
