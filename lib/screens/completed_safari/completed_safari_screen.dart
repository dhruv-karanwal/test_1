import 'package:flutter/material.dart';
import '../menu/menu_screen.dart';
import '../../widgets/shared_ui.dart';
import '../../utils/app_colors.dart';
import '../transaction/transaction_screen.dart';

class CompletedSafariScreen extends StatelessWidget {
  CompletedSafariScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const Color appGreen = AppColors.appGreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MenuScreen(),
      endDrawer: TransactionScreen(),
      backgroundColor: appGreen,
      appBar: buildCommonAppBar(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/landing_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: appGreen.withOpacity(0.6),
            ),
          ),
          // Empty Content
        ],
      ),
      bottomNavigationBar: buildCommonBottomNav(context, _scaffoldKey),
    );
  }
}
