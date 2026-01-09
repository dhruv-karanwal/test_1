import 'package:flutter/material.dart';
import '../menu/menu_screen.dart';
import '../transaction/transaction_screen.dart';
import '../../widgets/shared_ui.dart';
import '../../utils/app_colors.dart';

class EntryChoiceScreen extends StatefulWidget {
  const EntryChoiceScreen({super.key});

  @override
  State<EntryChoiceScreen> createState() => _EntryChoiceScreenState();
}

class _EntryChoiceScreenState extends State<EntryChoiceScreen> {
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/landing_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(color: appGreen.withOpacity(0.6)),
      ),
      bottomNavigationBar: buildCommonBottomNav(context, _scaffoldKey),
    );
  }
}
