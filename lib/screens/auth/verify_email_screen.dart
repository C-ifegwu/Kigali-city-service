import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/theme.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  Timer? _timer;
  bool _emailSent = true;

  @override
  void initState() {
    super.initState();
    // Poll every 6 seconds for verification (reduced from 3s to cut log noise)
    _timer = Timer.periodic(const Duration(seconds: 6), (_) async {
      await context.read<AppAuthProvider>().reloadUser();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();
    final email = auth.firebaseUser?.email ?? '';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: kGold.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mark_email_unread_outlined,
                      size: 64, color: kGold),
                ),
                const SizedBox(height: 32),
                Text('Verify your email',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 12),
                Text(
                  'We sent a verification email to\n$email\n\nPlease click the link in the email to verify your account.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 8),
                const Text('Checking verification status…',
                    style: TextStyle(color: kWhite40, fontSize: 12)),
                const SizedBox(height: 4),
                const SizedBox(
                    width: 180,
                    child: LinearProgressIndicator(
                        backgroundColor: kNavyCard, color: kGold)),
                const SizedBox(height: 32),
                if (_emailSent)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: kGold.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_outline,
                            color: kGold, size: 18),
                        const SizedBox(width: 8),
                        Text('Verification email sent!',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: kGold)),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kGold),
                    foregroundColor: kGold,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                  ),
                  onPressed: auth.isLoading
                      ? null
                      : () async {
                          await auth.sendVerificationEmail();
                          setState(() => _emailSent = true);
                        },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Resend Email'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => auth.signOut(),
                  child: const Text('Sign Out',
                      style: TextStyle(color: kWhite40)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
