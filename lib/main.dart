import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Great-Grandparent
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color brandColor = Color(0xFF4AB6A6);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun Signup App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Aktiv Grotesk',
        colorScheme: ColorScheme.fromSeed(seedColor: brandColor),
        useMaterial3: true,
      ),
      home: const SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  static const Color brandColor = Color(0xFF4AB6A6);

  // The Global Key - acts like a remote control for the form
  final _formKey = GlobalKey<FormState>();

  // Controllers to track what the user types
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Task A: Fixed local preset demo tips (no network/HTTP used)
  final List<String> _demoTips = [
    'Use at least 8 characters with a mix of letters and numbers so it is hard to guess.',
    'Do not reuse passwords across multiple websites or apps.',
    'Combine unrelated words to make a strong password that is easy to remember.',
    'Avoid using obvious personal info like birthdays, pet names, or phone numbers in your password.',
    'Consider using a reputable password manager to generate and store complex, unique credentials.',
    'Make sure your email address is correct and accessible so you never get locked out of your account.',
    'Add special characters like exclamation marks, hashes, or dollar signs to boost password strength.',
    'Enable two-factor authentication whenever available to add an extra layer of account protection.',
  ];

  int _tipIndex = 0;
  bool _isLoadingTip = false;
  String? _displayedTip;
  String? _tipError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Task A: Local tip simulation
  Future<void> _fetchLocalTip({bool forceError = false}) async {
    setState(() {
      _isLoadingTip = true;
      _displayedTip = null;
      _tipError = null;
    });

    // Brief local delay to simulate loading state
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    if (forceError) {
      setState(() {
        _tipError = 'Could not load tip. Tap retry.';
        _isLoadingTip = false;
      });
      return;
    }

    setState(() {
      _displayedTip = _demoTips[_tipIndex % _demoTips.length];
      _tipIndex++;
      _isLoadingTip = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Parent
      appBar: AppBar(
        title: const Text('Join Us Today for the Cash Money!'),
        backgroundColor: brandColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // Child
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person, color: brandColor),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: brandColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email, color: brandColor),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: brandColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: brandColor),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: brandColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              // Task A: Local sample tip action
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _isLoadingTip ? null : () => _fetchLocalTip(),
                  onLongPress: () => _fetchLocalTip(forceError: true),
                  icon: const Icon(Icons.lightbulb_outline, size: 18, color: brandColor),
                  label: const Text(
                    'Get a signup tip',
                    style: TextStyle(color: brandColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              if (_isLoadingTip)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  child: Text('Loading demo tip...'),
                ),
              if (_displayedTip != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  child: Text(
                    'Tip: $_displayedTip',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2C6B61),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (_tipError != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _tipError!,
                          style: const TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _fetchLocalTip(forceError: false),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // Sign Up Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Demo signup complete — your form passed validation!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
