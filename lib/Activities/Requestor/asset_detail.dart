import 'package:flutter/material.dart';
import 'package:untitled/Customs/customappbar.dart';

class AssetDetail extends StatefulWidget {
    final Map assetData;
   const AssetDetail({super.key, required this.assetData});

  @override
  State<AssetDetail> createState() => _AssetDetailState();
}

class _AssetDetailState extends State<AssetDetail> {

  double? width;
  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomAppBar(txt: 'Asset Detail'),
              const SizedBox(
                height: 16,
              ),
               Container(
                  width: MediaQuery.of(context).size.width -
                      25, // You can adjust the width and height as needed
                  height: MediaQuery.of(context).size.height - 100,
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    borderRadius:
                        BorderRadius.circular(10), // Radius for rounded corners
                    border: Border.all(
                      color: const Color(0xFF282828)
                          .withOpacity(0.5), // Light grey border color
                      width: 2.0, // Border width
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey
                            .withOpacity(0.5), // Shadow color and opacity
                        spreadRadius: 5, // Spread radius
                        blurRadius: 10, // Blur radius
                        offset: const Offset(0, 3), // Shadow offset
                      ),
                    ],
                  ),
                  child:   Padding(
                      padding: const EdgeInsets.fromLTRB(8,8,8,0),
                      child:   Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Center(
                                  child: 
                                   
                                  Image.network(
                                        widget.assetData['asset_img']! ,
                                        width: width,
                                        height: 400,
                                        fit: BoxFit.cover,
                                  ),
                                ),
                            
                                const SizedBox(
                                  height: 16,
                                ),
                                const Text(
                                  'Price',
                                  style: TextStyle(
                                      color: Color(0XFF282828),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 4  
                              ,
                                ),
                                Text(widget.assetData['asset_price'],
                                  style: const TextStyle(
                                      color: Color(0XFF909090),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                               
                                const SizedBox(
                                  height: 10,
                                ),
                                 const Text(
                                  'Product Description',
                                  style: TextStyle(
                                      color: Color(0XFF282828),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(widget.assetData['asset_description'],
                                  style: const TextStyle(
                                      color: Color(0XFF909090),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                               
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            )
                           ))
                
            ],
          ),
        ),
      ),
    );
  }
}