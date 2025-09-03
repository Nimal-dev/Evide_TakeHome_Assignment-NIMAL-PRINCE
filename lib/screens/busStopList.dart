import 'package:evde_takehome/utilities/BusStops.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StopRouteLists extends StatefulWidget {
  final String routeName;
  final List<BusStop> stops;

  const StopRouteLists({super.key, required this.routeName, required this.stops});

  @override
  State<StopRouteLists> createState() => _StopRouteListsState();
}

class _StopRouteListsState extends State<StopRouteLists> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late List<BusStop> _filteredStops;
  Set<String> _favorites = {};
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _filteredStops = widget.stops;
    _loadFavorites();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favList = prefs.getStringList('favorites') ?? [];
    setState(() {
      _favorites = favList.toSet();
    });
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favorites.toList());
  }

  void _onSearch(String query) {
    setState(() {
      _filteredStops = widget.stops.where((stop) => stop.stopname.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void _toggleFavorite(String stopName) {
    setState(() {
      if (_favorites.contains(stopName)) {
        _favorites.remove(stopName);
      } else {
        _favorites.add(stopName);
      }
    });
    _saveFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routeName),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search bus stops...',
                  prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                onChanged: _onSearch,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredStops.length,
                itemBuilder: (context, index) {
                  final stop = _filteredStops[index];
                  final isFavorite = _favorites.contains(stop.stopname);

                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 8,
                        child: ListTile(
                          leading: const Icon(Icons.location_on, color: Colors.deepPurple),
                          title: Text(
                            stop.stopname,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ETA: ${stop.timedifference} min",
                                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "(${stop.latitude.toStringAsFixed(4)}, ${stop.longitude.toStringAsFixed(4)})",
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isFavorite ? Icons.star : Icons.star_border,
                              color: isFavorite ? Colors.yellow : Colors.grey,
                            ),
                            onPressed: () => _toggleFavorite(stop.stopname),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailScreen(
                                  stop: stop,
                                  isFavorite: isFavorite,
                                  onFavoriteToggle: () => _toggleFavorite(stop.stopname),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StopCard extends StatelessWidget {
  final BusStop stop;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const StopCard({
    super.key,
    required this.stop,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: ListTile(
        leading: const Icon(Icons.location_on, color: Colors.deepPurple),
        title: Hero(
          tag: 'stopName-${stop.stopname}',
          child: Text(
            stop.stopname,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ETA: ${stop.timedifference} min",
              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
            ),
            Text(
              "(${stop.latitude.toStringAsFixed(4)}, ${stop.longitude.toStringAsFixed(4)})",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border,
            color: isFavorite ? Colors.yellow : Colors.grey,
          ),
          onPressed: onFavoriteToggle,
        ),
        onTap: onTap,
      ),
    );
  }
}
