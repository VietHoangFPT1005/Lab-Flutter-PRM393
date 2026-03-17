import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // ── Form key ──────────────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();

  // ── Text controllers ──────────────────────────────────────────────────────
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  // ── Focus nodes (Lab 7.3) ─────────────────────────────────────────────────
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  // ── State ─────────────────────────────────────────────────────────────────
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isCheckingEmail = false; // Lab 7.4 async
  bool _acceptTerms = false;     // Bonus checkbox

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  // ── Validators ────────────────────────────────────────────────────────────

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w\-.]+@[\w\-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least 1 digit';
    }
    return null;
  }

  String? _validateConfirm(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  // ── Password strength (Bonus) ─────────────────────────────────────────────

  String _passwordStrength(String password) {
    if (password.isEmpty) return '';
    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*]').hasMatch(password)) score++;
    if (score <= 1) return 'Weak';
    if (score == 2) return 'Medium';
    return 'Strong';
  }

  Color _strengthColor(String strength) {
    switch (strength) {
      case 'Weak':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Strong':
        return Colors.green;
      default:
        return Colors.transparent;
    }
  }

  // ── Submit logic ──────────────────────────────────────────────────────────

  Future<void> _submit() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Local validation
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms & Conditions'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    _formKey.currentState!.save();

    // ── Lab 7.4 – Async email check ───────────────────────────────────────
    setState(() => _isCheckingEmail = true);

    // Simulate API call (2 seconds delay)
    await Future.delayed(const Duration(seconds: 2));

    final email = _emailController.text.trim().toLowerCase();
    final isTaken = email.startsWith('taken');

    if (!mounted) return;
    setState(() => _isCheckingEmail = false);

    if (isTaken) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This email is already taken. Please use another.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ── Success ───────────────────────────────────────────────────────────
    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Account Created!'),
          content: Text(
            'Welcome, ${_nameController.text.trim()}!\nYour account has been created successfully.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _formKey.currentState!.reset();
                _nameController.clear();
                _emailController.clear();
                _passwordController.clear();
                _confirmController.clear();
                setState(() => _acceptTerms = false);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strength = _passwordStrength(_passwordController.text);

    return GestureDetector(
      // Lab 7.3 – Dismiss keyboard on tap outside
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            // Lab 7.2 – Auto-validate on user interaction
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Create your account',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                // ── Full Name ──────────────────────────────────────────────
                TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  textInputAction: TextInputAction.next,  // Lab 7.3
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateName,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_emailFocus),
                ),
                const SizedBox(height: 16),

                // ── Email ──────────────────────────────────────────────────
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                    helperText: 'Tip: emails starting with "taken" are simulated as already used',
                    helperMaxLines: 2,
                  ),
                  validator: _validateEmail,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passwordFocus),
                ),
                const SizedBox(height: 16),

                // ── Password ───────────────────────────────────────────────
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  textInputAction: TextInputAction.next,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: _validatePassword,
                  onChanged: (_) => setState(() {}), // Rebuild for strength indicator
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_confirmFocus),
                ),
                // Password strength indicator (Bonus)
                if (_passwordController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Row(
                      children: [
                        const Text('Strength: ',
                            style: TextStyle(fontSize: 12)),
                        Text(
                          strength,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _strengthColor(strength),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),

                // ── Confirm Password ───────────────────────────────────────
                TextFormField(
                  controller: _confirmController,
                  focusNode: _confirmFocus,
                  textInputAction: TextInputAction.done,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirm
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: _validateConfirm,
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 16),

                // ── Terms & Conditions checkbox (Bonus) ────────────────────
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (v) =>
                          setState(() => _acceptTerms = v ?? false),
                    ),
                    const Expanded(
                      child: Text(
                        'I accept the Terms & Conditions',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Submit Button ──────────────────────────────────────────
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    // Disable while checking email (Lab 7.4)
                    onPressed: _isCheckingEmail ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _isCheckingEmail
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : const Text('Create Account',
                            style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
