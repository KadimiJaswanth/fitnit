import 'package:flutter/material.dart';
import 'organization_profile.dart';

class OrganizationDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Organization Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Organization Features Here"),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OrganizationProfile())),
              child: Text("Go to Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
