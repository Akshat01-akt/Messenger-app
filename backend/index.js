const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const { initializeFirebase } = require('./firebase-config');

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Initialize Firebase
initializeFirebase();

// Routes
app.get('/', (req, res) => {
    res.send('Chat App Backend is running!');
});

// Example Notification Route
const notificationRoutes = require('./routes/notification');
app.use('/api/notifications', notificationRoutes);

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
