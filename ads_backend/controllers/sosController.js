const SOS = require('../models/SOS');
const EmergencyContact = require('../models/EmergencyContact');
const sendEmergencyEmail = require('../services/emailService');

// POST /api/sos
exports.triggerSOS = async (req, res) => {
  try {
    const {
      location,
      userId,
      name,
      vehicle,
      severity,
      description,
      latitude,
      longitude
    } = req.body;

    const sos = new SOS({
      location,
      userId: userId || 'guest',
    });

    const savedSOS = await sos.save();

    const contacts = await EmergencyContact.find({ userId });

    if (!contacts.length) {
      return res.status(400).json({ error: 'No emergency contacts found.' });
    }

    const now = new Date().toLocaleString('en-IN', {
      timeZone: 'Asia/Kolkata',
      dateStyle: 'long',
      timeStyle: 'short',
    });

    const emailHTML = `
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="UTF-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
          <title>Emergency Alert</title>
          <style>
            body {
              font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
              background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
              padding: 20px;
              min-height: 100vh;
              display: flex;
              align-items: center;
              justify-content: center;
            }
            .alert-container {
              background: #fff;
              max-width: 500px;
              width: 100%;
              border-radius: 20px;
              box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
              overflow: hidden;
            }
            .alert-header {
              background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
              color: white;
              padding: 30px 25px;
              text-align: center;
            }
            .emergency-icon {
              font-size: 48px;
              margin-bottom: 10px;
              animation: pulse 2s infinite;
            }
            @keyframes pulse {
              0% { transform: scale(1); }
              50% { transform: scale(1.1); }
              100% { transform: scale(1); }
            }
            .alert-title {
              font-size: 24px;
              font-weight: 700;
            }
            .alert-subtitle {
              font-size: 14px;
              opacity: 0.9;
            }
            .alert-body {
              padding: 30px 25px;
            }
            .info-grid {
              display: grid;
              gap: 20px;
              margin-bottom: 25px;
            }
            .info-item {
              display: flex;
              align-items: center;
              padding: 15px;
              background: #f8f9fa;
              border-radius: 12px;
              border-left: 4px solid #ff6b6b;
            }
            .info-icon {
              font-size: 20px;
              margin-right: 15px;
              color: #ff6b6b;
            }
            .info-content {
              flex: 1;
            }
            .info-label {
              font-size: 12px;
              color: #666;
              text-transform: uppercase;
              font-weight: 600;
            }
            .info-value {
              font-size: 16px;
              color: #2c3e50;
              font-weight: 500;
            }
            .severity-high {
              color: #e74c3c;
              font-weight: 700;
            }
            .description-box {
              background: linear-gradient(135deg, #ffeaa7 0%, #fab1a0 100%);
              padding: 20px;
              border-radius: 12px;
              margin-bottom: 25px;
              border: 1px solid #fdcb6e;
            }
            .description-label {
              font-size: 12px;
              color: #8b4513;
              text-transform: uppercase;
              font-weight: 600;
              margin-bottom: 8px;
            }
            .description-text {
              font-size: 16px;
              color: #000000;
              font-weight: 600;
              line-height: 1.4;
            }
            .map-button {
              display: inline-block;
              background: linear-gradient(135deg, #74b9ff 0%, #0984e3 100%);
              color: white;
              padding: 12px 20px;
              border-radius: 50px;
              text-decoration: none;
              font-weight: 600;
              font-size: 14px;
            }
            .map-button::before {
              content: "📍";
              margin-right: 6px;
            }
            .alert-footer {
              text-align: center;
              padding: 20px 25px;
              background: #f8f9fa;
              font-size: 12px;
              color: #6c757d;
            }
          </style>
        </head>
        <body>
          <div class="alert-container">
            <div class="alert-header">
              <div class="emergency-icon">🚨</div>
              <div class="alert-title">EMERGENCY ALERT</div>
              <div class="alert-subtitle">Immediate Response Required</div>
            </div>

            <div class="alert-body">
              <div class="info-grid">
                <div class="info-item">
                  <div class="info-icon">👤</div>
                  <div class="info-content">
                    <div class="info-label">Name</div>
                    <div class="info-value">${name}</div>
                  </div>
                </div>
                <div class="info-item">
                  <div class="info-icon">🚗</div>
                  <div class="info-content">
                    <div class="info-label">Vehicle</div>
                    <div class="info-value">${vehicle}</div>
                  </div>
                </div>
                <div class="info-item">
                  <div class="info-icon">⚠️</div>
                  <div class="info-content">
                    <div class="info-label">Severity</div>
                    <div class="info-value severity-high">${severity}</div>
                  </div>
                </div>
                <div class="info-item">
                  <div class="info-icon">🕐</div>
                  <div class="info-content">
                    <div class="info-label">Date & Time</div>
                    <div class="info-value">${now}</div>
                  </div>
                </div>
              </div>

              <div class="description-box">
                <div class="description-label">Incident Description</div>
                <div class="description-text">${description}</div>
              </div>

              <div style="text-align: center;">
                <a href="https://maps.google.com/?q=${latitude},${longitude}" target="_blank" class="map-button">
                  View Location on Map
                </a>
              </div>
            </div>

            <div class="alert-footer">
              This is an automated SOS alert — Accident Detection System
            </div>
          </div>
        </body>
        </html>
        `;


    for (const contact of contacts) {
      if (contact.email) {
        await sendEmergencyEmail(
          contact.email,
          '🚨 Accident Alert: Immediate Attention Required',
          emailHTML
        );
      } else {
        console.warn(`⚠️ Skipping contact with missing email:`, contact);
      }
    }

    res.status(201).json({ message: '🚨 SOS received and emails sent', data: savedSOS });
  } catch (err) {
    console.error('❌ Error in SOS:', err);
    res.status(500).json({ error: err.message });
  }
};

// GET /api/sos
exports.getAllSOS = async (req, res) => {
  try {
    const all = await SOS.find().sort({ timestamp: -1 });
    res.status(200).json(all);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
