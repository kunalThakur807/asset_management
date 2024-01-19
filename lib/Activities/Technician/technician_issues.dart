
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Authentication/register.dart';
 
import 'package:untitled/Customs/customappbar.dart';
 
class TechnicianIssues extends StatefulWidget {
  const TechnicianIssues({super.key});

  @override
  State<TechnicianIssues> createState() => _TechnicianIssuesState();
}

class _TechnicianIssuesState extends State<TechnicianIssues> {
  var m=[{'asset_tag':'ABCD_008','due_on':'7 Jul`24','issue_description':'Issue in handle of car','color':Colors.red},{'asset_tag':'ABCD_004','due_on':'10 Jul`24','issue_description':'Issue in computer','color':Colors.deepOrange},{'asset_tag':'ABCD_008','due_on':'7 Jul`24','issue_description':'Issue in engine','color':Colors.green},{'asset_tag':'ABCD_008','due_on':'7 Jul`24','issue_description':'Issue in head light of car','color':Colors.red}];
  
  @override
  void initState() {
    super.initState();
     
  }
   Future<void> deleteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user_email');
    prefs.remove('user_type');
    prefs.remove('id');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(txt: 'Issues'),
             GestureDetector(
                        onTap: (){
                               deleteData();
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const Register(),
                  ),
                );
                        },
                         child: SvgPicture.asset(
                                  'assets/arrow.svg',
                                width: 28,
                                height: 28, 
                                ),
                       ),
            GridItem(items: m)
          ],
        ),
      ),
    );
  }
}
class GridItem extends StatelessWidget {
  final List<Map<String, dynamic>> items;

 const GridItem({super.key,required this.items});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  const EdgeInsets.all(8.0),
        
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height-121,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            mainAxisSpacing: 10.0, // Spacing between rows
            crossAxisSpacing: 10.0, // Spacing between columns
            childAspectRatio: 1.25, // Width to height ratio of grid items
          ),
          itemCount: items.length, // Total number of items
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: (){
                //               Navigator.push(
                //                         context,
                //                         MaterialPageRoute(
                //                             builder: (context) =>
                //                                   const IssueDetails()));
              
               
             
              },
              highlightColor: Colors.blueGrey,
              child: Card(
                
                color: items[index]["color"],
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '  ${items[index]["asset_tag"]}',
                        style: const TextStyle(fontSize: 18, color: Colors.white,),
                      ),
                       const Divider(
                          height: 2.5, // Optional: Adjust the height of the line
                          color: Colors.white, // Optional: Specify the color of the line
                        ),
                         const SizedBox(
                        height: 10,
                      ),
              
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                            '  Due on : ${items[index]["due_on"]}',
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                        SvgPicture.asset(
                    'assets/arrows.svg',
                  ),
                  const SizedBox(
               
                  ),
                          ],
                        ),
                       const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '  ${items[index]["issue_description"]}',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                       const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}