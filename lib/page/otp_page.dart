import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:mobileprogrammingp9/main.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with CodeAutoFill {
  String? _code;

  @override
  void initState() {
    super.initState();
    listenForCode();
  }

  @override
  void codeUpdated() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _code = code; // `code` di sini adalah properti dari CodeAutoFill
      });

      if (_code == '123456') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MyApp()),
        );
      }
    });
  }


  @override
  void dispose() {
    cancel(); // dari CodeAutoFill
    super.dispose();
  }

  void _verifyOtp() {
    if (_code != null && _code!.length == 6) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyApp()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP tidak valid')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verifikasi OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Masukkan kode OTP yang dikirim via SMS'),
            const SizedBox(height: 16),
            PinFieldAutoFill(
              codeLength: 6,
              onCodeChanged: (code) {
                if (code != null && code.length == 6) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    setState(() {
                      _code = code;
                    });

                    if (_code == '123456') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const MyApp()), // atau halaman home kamu
                      );
                    }
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _verifyOtp,
              child: const Text('Verifikasi'),
            ),
          ],
        ),
      ),
    );
  }
}
