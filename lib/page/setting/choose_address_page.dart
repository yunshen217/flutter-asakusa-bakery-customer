import 'package:flutter/material.dart';
import 'package:shopping_client/common/constant.dart';
import 'package:shopping_client/common/custom_color.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/repository/repository.dart';
import 'package:shopping_client/routes/Routes.dart';
import 'package:shopping_client/view/BaseScaffold.dart';

import '../../adapter/address_adapter.dart';
import '../../common/InitEventBus.dart';
import '../../model/AddressModel.dart';

class ChooseAddressPage extends StatefulWidget {
  final Map map;

  const ChooseAddressPage(this.map, {super.key});

  @override
  State<ChooseAddressPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<ChooseAddressPage> {
  List<Data>? users = [];

  @override
  void initState() {
    backEndRepository.doGet(Constant.psCustomerAddressList, successRequest: (res) {
      users = AddressModel.fromJson(res).data;
      setState(() {});
    });

    EventBusUtil.listen((e) {
      if (e == Constant.FLAG) {
        backEndRepository.doGet(Constant.psCustomerAddressList, successRequest: (res) {
          users = AddressModel.fromJson(res).data;
          setState(() {});
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appBar: customWidget.setAppBar(
            title: "配送先情報の選択",
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(height: 5, width: double.infinity, color: CustomColor.grayF5))),
        body: Column(
          children: [
            ListTile(
                tileColor: CustomColor.white,
                trailing: const Icon(Icons.chevron_right_outlined),
                contentPadding: const EdgeInsets.only(right: 15, left: 15),
                title: customWidget.setText("配送先情報を登録する", fontWeight: FontWeight.w600),
                leading: null,
                onTap: () => Routes.goPage(context, "/AddressPage")),
            Container(height: 5, color: CustomColor.grayF5),
            Expanded(
                child: ListView.separated(
                    itemCount: users!.length,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        Container(height: 5, color: CustomColor.grayF5),
                    itemBuilder: (_, index) {
                      if (users!.isEmpty) {
                        return const SizedBox();
                      }
                      return InkWell(
                        child: AddressAdapter(users![index]),
                        onTap: () {
                          if (widget.map[Constant.FLAG] == Constant.ID) {
                            Routes.finishPage(context: context, param: users![index]);
                          }
                        },
                      );
                    }))
          ],
        ));
  }
}
