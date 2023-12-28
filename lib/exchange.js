const express = require('express');
const { OAuth2Client } = require('google-auth-library');

const app = express();
const CLIENT_ID = '637102427435-plo8h8m2kpjlhf93ip6n5apmb6l66mce.apps.googleusercontent.com'; // Replace with your Google Client ID
const client = new OAuth2Client(CLIENT_ID);

app.post('/exchange-token', async (req, res) => {
  const { firebaseToken } = req.body; // Receive Firebase ID token from the request

  try {
    const ticket = await client.verifyIdToken({
      idToken: firebaseToken,
      audience: CLIENT_ID,
    });
    const payload = ticket.getPayload();
    
    // Perform additional checks on the payload if needed

    // Generate OAuth token for Vertex AI API
    const oauthToken = getOAuthToken; // Replace with your generated OAuth token

    res.json({ oauthToken });
  } catch (error) {
    console.error('Error exchanging tokens:', error);
    res.status(500).json({ error: 'Token exchange failed' });
  }
});

app.listen(3000, () => {
  console.log('Server is running on port 3000');
});
