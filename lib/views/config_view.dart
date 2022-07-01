import 'package:animesan/components/delegates/config_appbar.dart';
import 'package:animesan/components/tabs/geral_tab.dart';
import 'package:animesan/components/tabs/notification_tab.dart';
import 'package:animesan/components/tabs/plugins_tab.dart';
import 'package:animesan/models/mixins.dart';
import 'package:animesan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Config extends StatefulWidget {
  const Config({Key? key}) : super(key: key);

  @override
  State<Config> createState() => _ConfigState();
}

class _ConfigState extends State<Config> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<TabConfig> _tabs = [
    GeralTabConfig(),
    const NotificationTabConfig(),
    PluginsTabConfig(),
  ];
  final double expandedHeight = 230.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        toolbarHeight: 0,
      ),
      backgroundColor: appBackgroudColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            delegate: ConfigAppBarDelegate(
              tabs: _tabs,
              onTapTab: (index) => setState(() {}),
              expandedHeight: expandedHeight,
              tabController: _tabController,
            ),
            pinned: false,
            floating: true,
          ),
          SliverToBoxAdapter(
            child: Container(
              constraints: BoxConstraints(minHeight: Get.height - MediaQuery.of(context).padding.top),
              child: _tabs[_tabController.index] as Widget,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
