import 'dart:convert';

import 'package:evde_takehome/screens/busStopList.dart';
import 'package:evde_takehome/utilities/BusStop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  Map<String, List<BusStop>> _routes = {};
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _loadRoutes();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadRoutes() async {
    final String response = await rootBundle.loadString('assets/mock/stops.json');
    final data = json.decode(response);

    final routes = <String, List<BusStop>>{};
    (data['routes'] as Map<String, dynamic>).forEach((key, value) {
      routes[key] = (value as List).map((e) => BusStop.fromJson(e)).toList();
    });

    setState(() {
      _routes = routes;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_routes.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Evide Assignment- NIMAL PRINCE',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        backgroundColor: Colors.deepPurple[700],
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF5A3FBB),
              Color(0xFF2A2A72)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: _routes.keys.length,
          itemBuilder: (context, index) {
            final routeKey = _routes.keys.elementAt(index);
            return FadeTransition(
              opacity: _animationController,
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                child: ListTile(
                  leading: const Icon(Icons.directions_bus, color: Colors.deepPurple),
                  title: Text(
                    routeKey,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.deepPurple),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StopRouteLists(routeName: routeKey, stops: _routes[routeKey]!),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
