const User = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// POST /api/auth/register
exports.registerUser = async (req, res) => {
  try {
    const { name, email, password } = req.body;

    // Check if email exists
    const existing = await User.findOne({ email });
    if (existing) return res.status(400).json({ error: 'User already exists' });

    const user = new User({ name, email, password }); // no hashing here
    const saved = await user.save();

    res.status(201).json({
      _id: saved._id,
      name: saved.name,
      email: saved.email,
    });

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// POST /api/auth/login
exports.loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;

    console.log('[Login] Incoming email:', email);
    console.log('[Login] Incoming password:', password);

    const user = await User.findOne({ email });
    if (!user) {
      console.log('[Login] No user found with that email');
      return res.status(404).json({ error: 'User not found' });
    }

    console.log('[Login] User found:', user);

    const isMatch = await bcrypt.compare(password, user.password);

    console.log('[Login] isMatch:', isMatch);
    console.log('[Login] Stored hashed password:', user.password);

    if (!isMatch) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const token = jwt.sign(
      { userId: user._id },
      process.env.JWT_SECRET || 'mysecretkey',
      { expiresIn: '1h' }
    );

    return res.status(200).json({
      message: 'Login successful',
      token,
      user: {
        _id: user._id,
        name: user.name,
        email: user.email
      }
    });

  } catch (err) {
    console.error('[Login] Error:', err);
    return res.status(500).json({ error: err.message });
  }
};
