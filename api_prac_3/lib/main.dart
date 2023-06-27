import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Stats> fetchStats() async {
  final response = await http
      .get(Uri.parse('https://balldontlie.io/api/v1/stats?seasons[]=2022&player_ids[]=115&per_page=100'));

  if (response.statusCode == 200) {
    return Stats.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load stats');
  }
}

class Stats {
  final int fg3a;
  final int fg3m;
  final int ast;

  const Stats({
    required this.fg3a,
    required this.fg3m,
    required this.ast,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      fg3a: json['fg3a'],
      fg3m: json['fg3m'],
      ast: json['ast'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Stats> futureStats;
  @override
  void initState() {
    super.initState();
    futureStats = fetchStats();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Stats>(
            future: futureStats,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.fg3m.toString());
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
