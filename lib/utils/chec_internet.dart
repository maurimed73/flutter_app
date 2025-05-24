import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/music_servidor.dart';
import 'package:lottie/lottie.dart';

class CheckConnectionPage extends StatefulWidget {
  const CheckConnectionPage({super.key});

  @override
  State<CheckConnectionPage> createState() => _CheckConnectionPageState();
}

class _CheckConnectionPageState extends State<CheckConnectionPage> {
  bool? isConnected;

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  Future<void> checkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    print(connectivityResult);
    if (connectivityResult.first == ConnectivityResult.mobile ||
        connectivityResult.first == ConnectivityResult.wifi ||
        connectivityResult.first == ConnectivityResult.other) {
      setState(() {
        isConnected = true;
      });
    } else {
      setState(() {
        isConnected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isConnected == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (isConnected == true) {
      return const MusicServidor();
    } else {
      return NoConnectionPage(onRetry: checkConnection);
    }
  }
}

class NoConnectionPage extends StatelessWidget {
  final VoidCallback onRetry;

  const NoConnectionPage({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[950],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Sem Conexão'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          onRetry();
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Lottie.asset(
                  'assets/downloads/no_wifi.json',
                  width: 250,
                  height: 250,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sem conexão com a internet',
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    backgroundColor: Colors.amberAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Tentar Novamente'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
