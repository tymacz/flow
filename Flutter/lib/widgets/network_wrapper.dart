import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flow/services/offline_service.dart';
import 'package:flow/services/api_service.dart';

class NetworkWrapper extends StatefulWidget {
  final Widget child;
  const NetworkWrapper({super.key, required this.child});

  @override
  State<NetworkWrapper> createState() => _NetworkWrapperState();
}

class _NetworkWrapperState extends State<NetworkWrapper> {
  bool _isOffline = false;
  final OfflineService _offlineService = OfflineService();
  final ApiService _apiService = ApiService(); // Pour la synchro

  @override
  void initState() {
    super.initState();
    // On écoute les changements de réseau
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      bool isNowOffline = results.every(
        (result) => result == ConnectivityResult.none,
      );

      setState(() {
        _isOffline = isNowOffline;
      });

      // Si on REVIENT en ligne, on lance la synchronisation de la file d'attente ! (NIVEAU 3)
      if (!isNowOffline) {
        _offlineService.syncQueue(_apiService);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child, // Ton application normale
        // Le bandeau "Hors Ligne" (NIVEAU 2)
        if (_isOffline)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                color: Colors.grey.shade800,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      "Mode hors ligne",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
