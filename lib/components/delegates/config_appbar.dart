import 'package:animesan/components/logo.dart';
import 'package:animesan/models/mixins.dart';
import 'package:animesan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ConfigAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double tabHeight = 40.0;
  final TabController tabController;
  late final List<TabConfig> _tabs;
  final void Function(int) onTapTab;

  final iconPadding = EdgeInsets.zero;
  final double iconSize = 25;

  ConfigAppBarDelegate({
    required tabs,
    required this.onTapTab,
    required this.expandedHeight,
    required this.tabController,
  }) {
    _tabs = tabs;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            AppBar(
              backgroundColor: appPrimaryColor,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.black,
                ),
                onPressed: () => Get.back(),
              ),
              title: Text(
                _tabs[tabController.index].tabTitle,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "Bree Serif",
                ),
              ),
              centerTitle: true,
            ),
            Flexible(
              flex: 9,
              child: Container(
                decoration: const BoxDecoration(
                  color: appPrimaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                height: expandedHeight - kToolbarHeight - (tabHeight / 2),
                width: double.infinity,
                child: Hero(
                  tag: "appLogo",
                  child: AnimeSanLogo(
                    enableShadowLogo: true,
                    enableShadowTitle: true,
                    loading: false,
                    margin: EdgeInsets.only(bottom: (tabHeight / 2)),
                  ),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                height: tabHeight / 2,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Opacity(
            opacity: disappear(shrinkOffset),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: tabHeight,
                  decoration: const BoxDecoration(
                    color: appSecondaryColor,
                  ),
                  child: Theme(
                    data: ThemeData().copyWith(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    ),
                    child: TabBar(
                      onTap: onTapTab,
                      controller: tabController,
                      indicator: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      tabs: List.generate(
                        _tabs.length,
                        (index) => Tab(
                          iconMargin: iconPadding,
                          icon: Icon(
                            _tabs[index].tabIcon,
                            color: Colors.black,
                            size: iconSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double appear(double shrinkOffset) => shrinkOffset / maxExtent;

  double disappear(double shrinkOffset) => 1 - shrinkOffset / maxExtent;

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
