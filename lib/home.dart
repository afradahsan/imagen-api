import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign In process via Firebase
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the GoogleSignInAuthentication object
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      // Create a GoogleAuthProvider credential using the GoogleAuth object
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google Auth credentials
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  TextEditingController prompt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: (){
              signInWithGoogle();
            }, icon: Icon(Icons.login)),
            TextField(
              controller: prompt,
            ),
            ElevatedButton(onPressed: (){generateImage();}, child: Text('Submit')),
          ],
        ),
      )),
    );
  }

  Future generateImage() async{
    print('onclick');
    const String projectId = 'nth-computing-409212';
    const String url = 'https://us-central1-aiplatform.googleapis.com/v1/projects/$projectId/locations/us-central1/publishers/google/models/imagegeneration:predict';
    final String userPrompt = prompt.text;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer YOUR_AUTH_TOKEN', // Replace with your authorization token
          'Content-Type': 'application/json',
        },
        body: json.encode(<String, dynamic>{
          'instances': [
            {'prompt': userPrompt},
          ],
          'parameters': {'sampleCount': 1},
        },)
      );

      // Handle the response here, e.g., update UI with the generated image
      if (response.statusCode == 200) {
        print('success');
        // Image generated successfully, process the response
        // For example, decode and display the image
        // final imageData = response.body['predictions'][0]['bytesBase64Encoded'];
        // Display the image
      } else {
        print('errroorr');
        // Handle other status codes
      }
    } catch (error) {
      // Handle errors, e.g., show an error message
      print('Error: $error');
    }
  }

  Future<String?> getOAuthToken(String firebaseIdToken) async {
  try {
    final response = await http.post(
      Uri.parse(exchangeUrl),
      body: json.encode({'firebaseToken': firebaseIdToken}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String oauthToken = data['oauthToken']; // Get the OAuth token from the response
      return oauthToken;
    } else {
      print('Failed to exchange tokens: ${response.statusCode}');
      return null;
    }
  } catch (error) {
    print('Error exchanging tokens: $error');
    return null;
  }
}

  // Future<void> readCredentials() async {
  // String jsonString = await rootBundle.loadString('assets/google_credentials.json');
  // Map<String, dynamic> credentials = json.decode(jsonString);
  // }
}