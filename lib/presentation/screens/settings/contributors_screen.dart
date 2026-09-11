import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ContributorsScreen extends StatefulWidget {
  const ContributorsScreen({super.key});

  @override
  State<ContributorsScreen> createState() => _ContributorsScreenState();
}

class _ContributorsScreenState extends State<ContributorsScreen> {
  List<dynamic> _contributors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContributors();
  }

  Future<void> _loadContributors() async {
    try {
      final jsonString = await rootBundle.loadString('data/contributors.json');
      final data = json.decode(jsonString);
      setState(() {
        _contributors = (data['contributors'] as List<dynamic>?) ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.contributors),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _contributors.isEmpty
              ? Center(child: Text(l10n.error))
              : ListView.builder(
                  itemCount: _contributors.length,
                  itemBuilder: (context, index) {
                    final c = _contributors[index] as Map<String, dynamic>;
                    final name = c['name'] as String? ?? 'Unknown';
                    final contact = c['contact'] as String?;
                    final url = c['url'] as String?;

                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(name),
                      subtitle: contact != null ? Text(contact) : null,
                      trailing: url != null ? const Icon(Icons.open_in_new) : null,
                      onTap: url != null
                          ? () => launchUrl(
                                Uri.parse(url),
                                mode: LaunchMode.externalApplication,
                              )
                          : null,
                    );
                  },
                ),
    );
  }
}
