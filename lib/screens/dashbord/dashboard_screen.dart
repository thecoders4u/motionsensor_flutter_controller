import 'package:admin/constants.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';

import 'components/header.dart';

import 'components/homedata.dart';

class DashbordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home",
        style: TextStyle(
            color: Colors.blue,
        ),),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: defaultPadding),
                child: Header(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [

                        const SizedBox(height: defaultPadding),
                        const RecentFiels(),
                      ],
                    ),
                  ),
              ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
