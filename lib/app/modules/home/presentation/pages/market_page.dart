import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../app_controller.dart';
import '../../../../core/domain/configs/core_config.dart';
import '../../../../core/domain/consts/img.dart';
import '../../../../core/domain/entities/route_entity.dart';
import '../../../store/data/models/store_model.dart';
import '../../../store/presentation/stores/get_store_by_market_store.dart';
import '../../../store/presentation/widgets/store_tile.dart';

class MarketPage extends StatelessWidget {
  final RouteEntity _routeEntity;
  final GetStoreByMarketStore getStoreByMarketStore =
      Modular.get<GetStoreByMarketStore>();
  MarketPage(this._routeEntity) {
    getStoreByMarketStore.execute(_routeEntity.marketName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          height: getHeight(context),
          width: getWidth(context),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(APPLE_WALLPAPER),
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: _buildContainerContent(context),
          ),
        ),
        _buildBackButton(),
      ],
    );
  }

  Padding _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 55.0, horizontal: 30.0),
      child: IconButton(
        icon: Icon(Ionicons.ios_arrow_back, color: Colors.white, size: 40),
        onPressed: () => Modular.to.pop(),
      ),
    );
  }

  final AppController _controller = Modular.get<AppController>();
  Widget _buildContainerContent(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 30.0),
          Image.asset(LOGO_NAMED_WHITE, width: 90, height: 90),
          Expanded(
            child: Observer(builder: (_) {
              List<StoreModel> storeList = getStoreByMarketStore.storeList.data;
              if (getStoreByMarketStore.storeList.hasError) {
                return Center(child: Text('Ocorreu um erro'));
              }
              if (getStoreByMarketStore.storeList.data == null) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: storeList.length,
                itemBuilder: (context, index) {
                  StoreModel store = storeList[index];
                  return StoreTile(
                    img: store.logo,
                    label: store.name,
                    onTap: () async {
                      _controller.select(index);
                      await Modular.to.pushNamed('/store/shopping');
                      _controller.selectedIndex = 100;
                    },
                    index: index,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
