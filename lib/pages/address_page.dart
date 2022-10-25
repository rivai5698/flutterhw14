import 'package:flutter/material.dart';
import 'package:flutterhw14/bloc/city_bloc.dart';
import 'package:flutterhw14/bloc/district_bloc.dart';
import 'package:flutterhw14/common/my_button.dart';
import 'package:flutterhw14/common/my_text_field.dart';
import 'package:flutterhw14/models/City.dart';
import 'package:flutterhw14/models/District.dart';
import 'package:flutterhw14/pages/address_detail_page.dart';
import 'package:flutterhw14/services/api_service.dart';
import 'package:flutterhw14/services/area_service.dart';

class AddressPage extends StatefulWidget {
   String? citySel;
   int? cityIdSel;
   String? districtSel;

   AddressPage({super.key,  this.citySel,  this.districtSel, this.cityIdSel});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  late CityBloc cityBloc;
  late DistrictBloc districtBloc;
  late TextEditingController _cityController;
  late TextEditingController _districtController;
  late TextEditingController _detailAddressController;
  List<City> cities = [];
  //List<District>? districts;
  int? citySelected;
  @override
  void initState() {
    // TODO: implement initState
    _cityController = TextEditingController();
    _districtController = TextEditingController();
    _detailAddressController = TextEditingController();
    cityBloc = CityBloc();
    _cityController.text = widget.citySel ?? '';
    _districtController.text = widget.districtSel ?? '';
    citySelected = widget.cityIdSel ;
    if(citySelected!=null){
      print('cS $citySelected');
      districtBloc = DistrictBloc(citySelected!);
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _cityController.dispose();
    _districtController.dispose();
    _detailAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Địa chỉ mới'),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Tỉnh/thành phố')),
                      MyTextField(
                        hintText: 'Nhập tỉnh/thành phố',
                        textEditingController: _cityController,
                        inputCheck: '',
                        onTap: () {
                          showMyDialog(true);
                          setState(() {
                            _districtController.text = '';
                          });
                        },
                        readonly: true,
                        icon: GestureDetector(
                            child: const Icon(Icons.arrow_drop_down)),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Quận/huyện')),
                      MyTextField(
                        onTap: () async {
                          if(_cityController.text!=''||_cityController.text!=''){
                            showMyDialog(false);
                          }else{
                            await apiService.getCity().then((value){
                              setState(() {
                                cities.addAll(value);
                              });
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>AddressDetailPage(cities: cities)));
                          }
                        },
                        hintText: 'Nhập quận/huyện',
                        textEditingController: _districtController,
                        inputCheck: '',
                        readonly: true,
                        icon: GestureDetector(
                            child: const Icon(Icons.arrow_drop_down)),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Địa chỉ cụ thể')),
                      MyTextField(
                        hintText: 'Nhập địa chỉ cụ thể',
                        textEditingController: _detailAddressController,
                        inputCheck: '',
                      ),
                    ],
                  ),
                ),
              ),
              MyButton(
                text: 'Lưu',
                onPressed: () {
                  setState(() {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>AddressPage()), (route) => false);
                  });
                },
                color: Colors.red,
                isEnable: true,
              )
            ],
          ),
        ),
      ),
    );
  }

  void showMyDialog(bool op){
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        //barrierColor: Colors.grey.withOpacity(0.2),
        barrierLabel:
        MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pageBuilder: (_,__,___){
        return Container(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              child: Container(
                color: Colors.white,
                  width: MediaQuery.of(context).size.width/3,
                  margin: op ? EdgeInsets.only(top: MediaQuery.of(context).size.height/6,right: 16,bottom: 8):EdgeInsets.only(top: MediaQuery.of(context).size.height/5,right: 16,bottom: 8) ,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: op ? _dropdownCityItems() : _dropdownDistrictItems(citySelected!)) ,
            ),
          ),
        );
    });
  }

  Widget _dropdownCityItems(){
    return StreamBuilder<List<City>>(
      stream: cityBloc.streamCity,
        builder: (_,snapshot){
          if(snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if(snapshot.hasData){
            final cities = snapshot.data ?? [];
            return ListView.separated(itemBuilder: (_,index){
              return GestureDetector(
                  onTap: (){
                    districtBloc = DistrictBloc(int.parse(cities[index].id!));
                    districtBloc.getDistrict(int.parse(cities[index].id!));
                    _cityController.text = cities[index].name!;
                    setState(() {
                      citySelected = int.parse(cities[index].id!);
                      cityBloc.closeStream();
                      cityBloc = CityBloc();
                    });
                    Navigator.pop(context);
                  },
                  child: Text(cities[index].name!));
            }, separatorBuilder: (_,__)=>const Divider(),
                itemCount: cities.length);
          }
          return const Center(child: CircularProgressIndicator(),);
        }
    );
  }



  Widget _dropdownDistrictItems(int ctId){
    return StreamBuilder<List<District>>(
        stream: districtBloc.streamDistrict,
        builder: (_,snapshot){
          if(snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if(snapshot.hasData){
            final district = snapshot.data ?? [];
            return ListView.separated(itemBuilder: (_,index){
              return GestureDetector(
                  onTap: (){
                    _districtController.text = district[index].name!;
                    setState(() {
                      districtBloc.closeStream();
                      districtBloc = DistrictBloc(ctId);
                    });
                    Navigator.pop(context);
                  },
                  child: Text(district[index].name!));
            }, separatorBuilder: (_,__)=>const Divider(),
                itemCount: district.length);
          }
          return const Center(child: CircularProgressIndicator(),);
        }
    );
  }

}
