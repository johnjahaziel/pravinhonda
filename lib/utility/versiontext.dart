import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pravinhonda/utility/styles.dart';

class Versiontext extends StatefulWidget {
  const Versiontext({super.key});

  @override
  State<Versiontext> createState() => _VersiontextState();
}

class _VersiontextState extends State<Versiontext> {
  String _version = '1.0.0'; // Default version

  @override
  void initState() {
    super.initState();
    _fetchVersion();
  }

  Future<void> _fetchVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Version $_version',
      style: customtext(
        fs12,
        Color.fromRGBO(117, 117, 117, 1),
      )
    );
  }
}