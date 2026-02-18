const express = require('express');
const router = express.Router();
const { admin } = require('../firebase-config');

// POST /api/notifications/send
router.post('/send', async (req, res) => {
    const { token, title, body } = req.body;

    if (!token || !title || !body) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    try {
        // Logic to send notification using Firebase Admin
        // await admin.messaging().send({ ... })

        console.log(`Sending notification to ${token}: ${title} - ${body}`);

        res.status(200).json({ success: true, message: 'Notification sent (simulated)' });
    } catch (error) {
        console.error('Error sending notification:', error);
        res.status(500).json({ error: 'Failed to send notification' });
    }
});

module.exports = router;
