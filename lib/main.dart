import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const UnblockerApp());
}

class UnblockerApp extends StatelessWidget {
  const UnblockerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'أداة فك الحجب والتصفح - v2',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        cardColor: const Color(0xFF2B2B2B),
      ),
      home: const UnblockerLauncherV2(),
    );
  }
}

class UnblockerLauncherV2 extends StatefulWidget {
  const UnblockerLauncherV2({super.key});

  @override
  State<UnblockerLauncherV2> createState() => _UnblockerLauncherV2State();
}

class _UnblockerLauncherV2State extends State<UnblockerLauncherV2> {
  static const platform = MethodChannel('com.unblocker/vpn_engine');

  String _statusText = 'غير مفعل 🔴';
  Color _statusColor = const Color(0xFFFF4C4C);
  bool _isRunning = false;

  Future<void> _startUnblock() async {
    try {
      await platform.invokeMethod('startService');
      setState(() {
        _isRunning = true;
        _statusText = 'مفعل ويعمل الآن 🟢';
        _statusColor = const Color(0xFF2ECC71);
      });
    } on PlatformException catch (e) {
      setState(() {
        _statusText = 'خطأ في التشغيل: ${e.message}';
        _statusColor = const Color(0xFFFF4C4C);
      });
    }
  }

  Future<void> _stopUnblock() async {
    try {
      await platform.invokeMethod('stopService');
      setState(() {
        _isRunning = false;
        _statusText = 'متوقف 🔴';
        _statusColor = const Color(0xFFFF4C4C);
      });
    } catch (_) {
      setState(() {
        _isRunning = false;
        _statusText = 'متوقف 🔴';
        _statusColor = const Color(0xFFFF4C4C);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 35),
                const Text(
                  '🔓 برنامج فك الحجب وتأمين الاتصال (v2)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'يقوم هذا البرنامج بتمرير حركة الاتصال لفك الحجب وتحسين الاستقرار.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFAAAAAA),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B2B2B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'حالة خدمة فك الحجب:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _statusText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F6AA5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isRunning ? null : _startUnblock,
                    child: const Text(
                      '🚀 تفعيل فك الحجب (Start Service)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: !_isRunning ? null : _stopUnblock,
                    child: const Text(
                      '🛑 إيقاف فك الحجب (Stop Service)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'ملاحظة: يعمل التطبيق عبر خدمة VPN محلية لضمان نجاح التمرير.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF777777),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
