import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'أبو صياح للصرافة',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigoAccent, width: 2.0),
          ),
          labelStyle: TextStyle(color: Colors.grey),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigoAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: const TextStyle(fontSize: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigoAccent, width: 2.0),
          ),
          labelStyle: TextStyle(color: Colors.grey),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigoAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: const TextStyle(fontSize: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      themeMode: ThemeMode.system, // لتمكين الوضع الداكن حسب إعدادات الجهاز
      home: const CurrencyConverterScreen(),
    );
  }
}

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final double _sarToYerRate = 672.0;
  final double _usdToYerRate = 2517.0;

  double _sarAmount = 0.0;
  double _yerAmount = 0.0;
  double _usdAmount = 0.0;

  final TextEditingController _sarController = TextEditingController();
  final TextEditingController _yerController = TextEditingController();
  final TextEditingController _usdController = TextEditingController();

  // FocusNodes للتحكم في التركيز على حقول الإدخال
  final FocusNode _sarFocusNode = FocusNode();
  final FocusNode _yerFocusNode = FocusNode();
  final FocusNode _usdFocusNode = FocusNode();

  void _onCurrencyChanged(String? value, String currency) {
    if (value == null || value.isEmpty) {
      setState(() {
        if (currency == 'SAR') {
          _sarAmount = 0.0;
          _yerAmount = 0.0;
          _usdAmount = 0.0;
          _yerController.text = '';
          _usdController.text = '';
        } else if (currency == 'YER') {
          _sarAmount = 0.0;
          _yerAmount = 0.0;
          _usdAmount = 0.0;
          _sarController.text = '';
          _usdController.text = '';
        } else if (currency == 'USD') {
          _sarAmount = 0.0;
          _yerAmount = 0.0;
          _usdAmount = 0.0;
          _sarController.text = '';
          _yerController.text = '';
        }
      });
      return;
    }

    final double amount = double.tryParse(value) ?? 0.0;

    setState(() {
      if (currency == 'SAR') {
        _sarAmount = amount;
        _yerAmount = _sarAmount * _sarToYerRate;
        _usdAmount = _sarAmount / (_usdToYerRate / _sarToYerRate);
        _yerController.text = _yerAmount.toStringAsFixed(2);
        _usdController.text = _usdAmount.toStringAsFixed(2);
      } else if (currency == 'YER') {
        _yerAmount = amount;
        _sarAmount = _yerAmount / _sarToYerRate;
        _usdAmount = _yerAmount / _usdToYerRate;
        _sarController.text = _sarAmount.toStringAsFixed(2);
        _usdController.text = _usdAmount.toStringAsFixed(2);
      } else if (currency == 'USD') {
        _usdAmount = amount;
        _sarAmount = _usdAmount * (_usdToYerRate / _sarToYerRate);
        _yerAmount = _usdAmount * _usdToYerRate;
        _sarController.text = _sarAmount.toStringAsFixed(2);
        _yerController.text = _yerAmount.toStringAsFixed(2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أبـوصــياح لـلـصـرافـة'),
        centerTitle: true, // توسيط العنوان
      ),
      body: SingleChildScrollView( // لجعل الشاشة قابلة للتمرير في حال كانت المحتويات كبيرة
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // شعار أو صورة (اختياري)
            const Center(
              child: Icon(
                Icons.monetization_on,
                size: 80.0,
                color: Colors.indigoAccent,
              ),
            ),
            const SizedBox(height: 30),
            // حقل إدخال الريال السعودي
            TextField(
              controller: _sarController,
              focusNode: _sarFocusNode,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'الريال السعودي (SAR)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money), // إضافة أيقونة
              ),
              onChanged: (value) => _onCurrencyChanged(value, 'SAR'),
            ),
            const SizedBox(height: 15),
            // حقل إدخال الريال اليمني
            TextField(
              controller: _yerController,
              focusNode: _yerFocusNode,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'الريال اليمني (YER)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.money_off), // إضافة أيقونة مختلفة
              ),
              onChanged: (value) => _onCurrencyChanged(value, 'YER'),
            ),
            const SizedBox(height: 15),
            // حقل إدخال الدولار الأمريكي
            TextField(
              controller: _usdController,
              focusNode: _usdFocusNode,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'الدولار الأمريكي (USD)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.payments), // إضافة أيقونة أخرى
              ),
              onChanged: (value) => _onCurrencyChanged(value, 'USD'),
            ),
            const SizedBox(height: 40),
            // معلومات أسعار الصرف بتصميم أفضل
            Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    ':أسعار الصرف الحالية',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      const Text('1 SAR = '),
                      Text(
                        '${_sarToYerRate.toStringAsFixed(2)} YER',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      const Text('1 USD = '),
                      Text(
                        '${_usdToYerRate.toStringAsFixed(2)} YER',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
