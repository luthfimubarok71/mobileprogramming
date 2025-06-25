import 'package:flutter/material.dart';
import 'package:my_daily_life/main.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String _code = '';
  final String _expectedOtp = '123456';

  @override
  void initState() {
    super.initState();
    _simulateOtpSend();
  }

  Future<void> _simulateOtpSend() async {
    await Future.delayed(const Duration(seconds: 2));
    final signature = await SmsAutoFill().getAppSignature;
    debugPrint('📩 [Simulasi SMS]');
    debugPrint('<#> Your MyDailyLife OTP is: $_expectedOtp');
    debugPrint(signature);
  }

  void _verifyOtp() {
    if (_code == _expectedOtp) {
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
            const Text(
              'Masukkan kode OTP yang dikirim via SMS',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            PinFieldAutoFill(
              codeLength: 6,
              currentCode: _code,
              onCodeChanged: (code) {
                if (code != null && code.length == 6) {
                  setState(() => _code = code);
                }
              },
              decoration: UnderlineDecoration(
                textStyle: const TextStyle(fontSize: 24, color: Colors.black),
                colorBuilder: FixedColorBuilder(Colors.indigo),
              ),
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
