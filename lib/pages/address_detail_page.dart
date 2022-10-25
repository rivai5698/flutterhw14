import 'package:flutter/material.dart';
import 'package:flutterhw14/bloc/district_bloc.dart';
import 'package:flutterhw14/common/my_text_field.dart';
import 'package:flutterhw14/models/District.dart';
import 'package:flutterhw14/pages/address_page.dart';
import 'package:flutterhw14/services/api_service.dart';
import 'package:flutterhw14/services/area_service.dart';

import '../models/City.dart';

class AddressDetailPage extends StatefulWidget {
  final List<City> cities;
  const AddressDetailPage({super.key, required this.cities});

  @override
  State<AddressDetailPage> createState() => _AddressDetailPageState();
}

class _AddressDetailPageState extends State<AddressDetailPage> {
  late String title;
  late TextEditingController _controller;
  bool option = true;
  DistrictBloc? districtBloc;
  String? citySel, districtSel;
  int? cityIdSel;
  List<City> filteredCity = [];
  List<District> filteredDistrict = [];
  List<District> districtList= [];

  @override
  void initState() {
    // TODO: implement initState
    title = 'Chọn thành phố';
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              MyTextField(
                  textEditingController: _controller,
                  hintText: option ?'Điền tỉnh/thành phố':'Điền quận/huyện',
                  inputCheck: '',
                  onChanged: (string) {
                    if(option){
                      setState(() {
                        filteredCity = widget.cities
                            .where((u) => (u.name!
                            .toLowerCase()
                            .contains(string.toLowerCase())))
                            .toList();
                      });
                    }else{
                      setState(() {
                        filteredDistrict = districtList
                            .where((u) => (u.name!
                            .toLowerCase()
                            .contains(string.toLowerCase())))
                            .toList();
                      });
                    }


                  }),
              const SizedBox(
                height: 8,
              ),
              Expanded(child: _listAreaItems(option)),

              // if(option)...[
              //   _listAreaItems(option),
              // ]else...[
              //   _listAreaItems(option),
              // ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _listAreaItems(bool op) {
    if (op) {
      return ListView.separated(
          itemBuilder: (_, index) {
            return GestureDetector(
              child: Text(filteredCity[index].name!),
              onTap: () async {
                districtBloc =
                    DistrictBloc(int.parse(filteredCity[index].id!));
                districtBloc?.getDistrict(int.parse(filteredCity[index].id!));
                var districtList2 = await getData(int.parse(filteredCity[index].id!));
                setState(()  {
                  districtList.addAll(districtList2);
                  print('dl : $districtList');
                  option = false;
                  title = 'Chọn quận/huyện';
                  citySel = filteredCity[index].name!;
                  cityIdSel = int.parse(filteredCity[index].id!);
                  _controller.text = '';
                });
              },
            );
          },
          separatorBuilder: (_, __) => const Divider(),
          itemCount: filteredCity.length);
    } else {
      return StreamBuilder<List<District>>(
        stream: districtBloc?.streamDistrict,
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.hasData) {
            final districts = snapshot.data ?? [];
            return ListView.separated(
                itemBuilder: (_, index) {
                  return GestureDetector(
                      onTap: () {
                        setState(() {
                          districtSel = filteredDistrict[index].name!;
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AddressPage(
                                      districtSel: districtSel,
                                      citySel: citySel,
                                      cityIdSel: cityIdSel,
                                    )),
                            (route) => false);
                      },
                      child: Text(filteredDistrict[index].name!));
                },
                separatorBuilder: (_, __) => const Divider(),
                itemCount: filteredDistrict.length);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    }
  }


  Future<List<District>> getData(int ctId) async{
    List<District> list = [];
    await apiService.getDistrict(cityId: ctId).then((value){
      list.addAll(value);
    });
    return list;
  }

}
