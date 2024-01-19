import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:untitled/Activities/Requestor/asset_detail.dart';
import 'package:untitled/Customs/customappbar.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Customs/customsubmitbutton.dart';
import 'package:untitled/Customs/customtextfield.dart';
import 'package:untitled/Customs/customtitletext.dart';

class AssetRequest extends StatefulWidget {
  const AssetRequest({super.key});
  @override
  State<AssetRequest> createState() => _AssetRequestState();
}

class _AssetRequestState extends State<AssetRequest> {
 double? width;
 String? txt;
    FocusNode? node,node2;
    TextEditingController? purposeController,urgentController;
String selectedPriority = 'High';
  List<String> selectPriority = ['High', 'Medium', 'Low'];
 String? selectedType = 'Select Type';
 String? selectedSubType = 'Select Item';
  bool isChecked=false;
  String urlHead = 'http://192.168.1.108/dashboard/sf11/';
  Map<String,String> itemValue={
    'asset_img':'',
    'asset_price':'',
    'asset_name':''

  };
  List<Map<String,String>> category = [
    {'id': '1', 'category': 'Select Category'}
  ];List<Map<String,String>> type = [
    {'id': '1', 'type': 'Select Type'}
  ];
  List<Map<String,String>> subType=[ {'asset_name': 'Select Item'}];
 
   List<Map<String,String>>? listOfItems=[]; 
  
   
 

  void getCategoryList() async {
    var d = {'id': '1', 'category': 'Select Category'};
    List<Map<String,String>> list = [d];
    String url = '${urlHead}ViewDataForAssetCategory.php';
    final response = await http.get(Uri.parse(url));
    var j = json.decode(response.body);
   
    for (var n in j) {
      d = {'id': n['id'], 'category': n['name']};
      list.add(d);
    }
    setState(() {
      category = list;
    });
  }

  void getAssetTypeList(String id) async {
 var d = {'id': '1', 'type': 'Select Type'};
    List<Map<String,String>> list = [d];
    String url = '${urlHead}queryDataForAssetType.php';
   final response = await http.post(Uri.parse(url), body: {
      'id': id,
    });
    var j = json.decode(response.body);
    
    for (var n in j) {
      d = {'id': n['id'], 'type': n['name']};
      list.add(d);
    }
    setState(() {
      type = list;
    });
    
  }
void getAssetDataList(String id) async {
 var d = {'asset_name': 'Select Item'};
    List<Map<String,String>> list = [d];
    String url = '${urlHead}queryAssetData.php';
   final response = await http.post(Uri.parse(url), body: {
      'type': id,
    });
    var j = json.decode(response.body);  
   
    for (var n in j) {
      d = {
         'asset_name': n['asset_name'],
         'asset_description': n['asset_description'],
         'asset_price': n['asset_price'],
         'asset_img': n['asset_img'],
          };
      list.add(d);
    }
    setState(() {
      subType = list;
      listOfItems=list.sublist(1);  
    });
   
  }
  DateTime selectedDate = DateTime.now().toLocal();
   Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String selectedCategory = 'Select Category';
   int i=0;
  String selectedCompany = 'Select Company';
 bool isNotItem=true;
 @override
  void initState() {
     
    super.initState();
    getCategoryList();
    selectedType ='Select Type';
      node = FocusNode();
      node2 = FocusNode();
    purposeController=TextEditingController(); 
    urgentController=TextEditingController(); 
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    txt = 'Request Asset';
 
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(txt: txt),
              Container(
                padding:   const EdgeInsets.fromLTRB(10, 10, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     
                      const SizedBox(
                      height: 8,
                    ),

                      const CustomTitleText(
                        title:  'Asset Category',
                        size: 18,
                        color: Color(0xFF282828)),

                      const SizedBox(height: 10),
                    
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10))
                          ]),

                      child: DropdownButtonHideUnderline(
                        child:    DropdownButton<String>(
                         
                            value: selectedCategory,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCategory = newValue!;
                              });
                              for (var v in category) {
                                if (v['category'] == newValue) {
                                getAssetTypeList(v['id']!);
                                }
                              }
                            },
                            items: category.map((Map language) {
                              return DropdownMenuItem<String>(
                                value: language['category'],
                                child: Text(language['category'],
                                    style: const TextStyle(
                                        fontSize:
                                             14)),
                              );
                            }).toList(),
                          ),
                      ),
                    ),
                      const SizedBox(
                      height: 16,
                    ),
                     
                      const CustomTitleText(
                      title: 'Asset Type',
                      size: 18,
                      color: Colors.black,
                    ),

                      const SizedBox(height: 10),
                    // Your content goes here
                    Container(
                      width: width,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10))
                          ]),
                      child: DropdownButtonHideUnderline(
                        child:  DropdownButton<String>(
                            value: selectedType,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedType = newValue!;
                              });
                             if(selectedType!='Select Type')
                             {
                                  getAssetDataList(selectedType!);
                             }
                            },
                            items: type.map((Map language) {
                              return DropdownMenuItem<String>(
                                value: language['type'],
                                child: Text(language['type'],
                                    style: const TextStyle(
                                        fontSize:
                                             14)),
                              );
                            }).toList(),
                          ),
                      ),
                      ),
 
                      const SizedBox(
                      height: 16,
                    ),
                     const CustomTitleText(
                      title: 'Subtype',
                      size: 18,
                      color: Colors.black,
                    ),

                      const SizedBox(height: 10),
                    // Your content goes here
                    Container(
                      width: width,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10))
                          ]),
                      child: DropdownButtonHideUnderline(
                        child:  DropdownButton<String>(
                            value: selectedSubType,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedSubType = newValue!;
                              });
                               for (var v in listOfItems!) {
                                if (v['asset_name'] == newValue) {
                                   setState(() {
                                     itemValue=v;
                                   });
                                  break;
                                }
                              }
                             setState(() {
                              if(itemValue['asset_name']!.isNotEmpty)
                              {
                               isNotItem=false;
                              }
                             });
                            },
                            items: subType.map((Map language) {
                              return DropdownMenuItem<String>(
                                value: language['asset_name'],
                                child: Text(language['asset_name'],
                                    style: const TextStyle(
                                        fontSize:
                                             14)),
                              );
                            }).toList(),
                          ),
                      ),
                      ),
 
                      const SizedBox(
                      height: 16,
                    ),
                     

                    
                     
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                                 const CustomTitleText(
                                    title: 'Required by',
                                    size: 18,
                                    color: Colors.black,
                                ),
                                const SizedBox(
                                height: 8,
                              ),
                            GestureDetector(
                              onTap: (){
                              _selectDate(context);
                              },
                              child: Container(
                                    width: width!/2.25,
                                    height: 50,
                                                  padding:   const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                                  decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, .3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10))
                                ]),
                                child:     Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}')),
                              ),
                            ),
                            
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                                 const CustomTitleText(
                                    title: 'Qty',
                                    size: 18,
                                    color: Colors.black,
                                ),
                                const SizedBox(
                                height: 8,
                              ),
                            Container(
                                 width: width!/2.25,
                                  height: 50,
                      padding:     const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow:     const [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10))
                              ]),
                              child:     Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('  $i'),
                                    Row(
                                     children: [
                                         SizedBox(
                                          width: 40,
                                          height: 25,
                                          child: ElevatedButton(onPressed: (){
                                            setState(() {
                                              i++;
                                            });
                                          }, child: const Center(child: Text('+')))),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                           SizedBox(
                                          width: 40,
                                          height: 25,
                                          child: ElevatedButton(onPressed: (){
                                            if(i>0)
                                              {
                                            setState(() {
                                              i--;
                                            });
                                           }
                                          }, child: const Center(child: Text('-')))),
                                    
                                     ],
                                    ),
                                       
                                  ],
                                )),
                            ),
                            
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const CustomTitleText(
                        title: 'Purpose',
                        size: 18,
                        color: Color(0XFF282828)),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                        node1: node!,
                        usernameController: purposeController!,
                        onSubmitted: () {},
                        keyboardType: TextInputType.streetAddress,
                        hintText: "Enter your purpose...",
                        obscureText: false,
                        suffixWidget: const Text(''),
                        width: width!,
                        onPressed: () {}),
                    Offstage(
                      offstage: isNotItem,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                              const CustomTitleText(
                              title: 'Item',
                              size: 18,
                              color: Colors.black,
                            ),
                              const SizedBox(
                              height: 8,
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>   AssetDetail(assetData:itemValue,)));
                              },
                              child: Container(
                                                  width: width,
                                                  padding:   const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow:   const [
                                  BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, .3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10))
                                ]),
                                                  child:  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                     
                              children: [
                                Center(
                                  child: 
                                  isNotItem?
                                    Container()
                                  :
                                  Image.network(
                                        itemValue['asset_img']! ,
                                        width: 175.0,
                                        height: 175.0,
                                        fit: BoxFit.cover,
                                  ),
                                ),
                            
                                                  Container(
                                                    padding:   const EdgeInsets.all(16),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Text(itemValue['asset_name']!,
                                                      style:   const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF909090),
                                                      )),
                                                    Row(
                                                    children: [
                                   const CustomTitleText(
                                                    title: 'Price',
                                                    size: 18,
                                                    color: Colors.black,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(itemValue['asset_price']!,
                                                      style:   const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF909090),
                                                      )),
                                                     
                                                    ],
                                                    )
                                                    ],
                                                    ),
                                                  )
                              ],
                                                  ),
                                                ),
                            ),
                          ],
                        ),
                    
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(children: [
                      const CustomTitleText(title: 'Urgent?', size: 18, color: Color(0xFF282828)),
                      Checkbox(
                       value: isChecked,
                       onChanged: (bool? value) {
                       setState(() {
                       isChecked = value!;
                       });
                        },
                     ),
                    ],),
                    isChecked?
                     CustomTextField(
                        node1: node2!,
                        usernameController: urgentController!,
                        onSubmitted: () {
                        },
                        keyboardType: TextInputType.streetAddress,
                        hintText: "Write Reason For Urgency...",
                        obscureText: false,
                        suffixWidget: const Text(''),
                        width: width!,
                        onPressed: () {}):Container(),

                        const SizedBox(
                          height: 16,
                        ),
                      CustomSubmitButton(onPressed: (){}),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}