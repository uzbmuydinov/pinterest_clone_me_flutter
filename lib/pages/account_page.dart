import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  static const String id = 'account_page';
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String name = "uzbmuydinov";
  String email = "uzbmuydinov@gmail.com";
  int followers = 0;
  int followings = 3;

  // save function

  _save(int index) async{
    var status=await Permission.storage.request();
    if (status.isGranted){
      var response =await Dio().get(
         defaultImage[index],
          options: Options(responseType: ResponseType.bytes)
      );
      final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),
          quality: 80,
          name: DateTime.now().toString()
      );
      print(result);

    }

  }

  final defaultImage = [
    "https://i.pinimg.com/736x/3c/cc/3b/3ccc3becc478b6f062ee6de96965ce33.jpg",
    "https://klike.net/uploads/posts/2020-04/1587105798_17.jpg",
    "http://1024x.net/wallpapers/20t/Tesla_Model_X_AWD_Minivan.jpg",
    "https://minimalistbaker.com/wp-content/uploads/2015/07/AMAZING-1-Bowl-Chocolate-Cake-with-Coconut-Whipped-Cream-with-Berries-The-perfect-summer-birthday-cake-vegan-glutenfree-cake-glutenfree-chocolate-dessert.jpg",
    "https://kartinkin.net/uploads/posts/2021-03/1616068145_10-p-ribki-krasivie-foto-10.jpg",
    "https://i.pinimg.com/originals/f5/41/ae/f541ae29711b665361d76b6f34e6db53.jpg",
    "https://i.pinimg.com/originals/ff/3b/f7/ff3bf7212d6ec6bd1a5fe5ce3424ca93.jpg",
  ];

  Future <void> refresh()async {

  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.share, color: Colors.black,),
              onPressed: (){
                showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                    ),
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return bottomSheet();
                    });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: const Icon(FontAwesomeIcons.ellipsisH, color: Colors.black, size: 18,),
                onPressed: (){},
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 114,
                width: 114,
                child: CircleAvatar(
                  radius: 57,
                  backgroundColor: Colors.grey.shade300,
                  child: Center(
                    child: TextButton(
                      onPressed: (){
                        if (kDebugMode) {
                          print("Hello => welcome account");
                        }
                      },
                      child: CircleAvatar(
                        radius: 55,

                        backgroundImage: NetworkImage('https://img.wattpad.com/593f606a3b215f4c99b9ba4c809a96d4d7b64cfa/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f776174747061642d6d656469612d736572766963652f53746f7279496d6167652f4e55746d565f76552d6e6e6d38673d3d2d3936373037363430342e313633656433636630623264333464353738373134373430323237332e6a7067?s=fit&w=720&h=720'),
                      ),
                      //child: Text(name.substring(0, 1), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 30, color: Colors.black),),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Center(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 35, color: Colors.black),)),
              const SizedBox(
                height: 12,
              ),
              Center(child: Text(email, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.black),)),
              const SizedBox(
                height: 12,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text(followers.toString(), style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.black),)),
                    const SizedBox(
                      width: 5,
                    ),
                    const Center(child: Text("followers", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.black),)),
                    const SizedBox(
                      width: 5,
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 1,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Center(child: Text(followings.toString(), style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.black),)),
                    const SizedBox(
                      width: 5,
                    ),
                    const Center(child: Text("followings", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.black),)),
                  ],
                ),
              ),
              Container(
                height: 70,
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 5,
                          child: GestureDetector(
                            onTap: (){
                              if (kDebugMode) {
                                print("Hello => TextField");
                              }
                            },
                            child: Container(
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(19),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Icon(Icons.search, color: Colors.black54,),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Text("Search your Pins", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),),
                                  ],
                                )
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                              onTap: (){
                                if (kDebugMode) {
                                  print("Hello => add");
                                }
                              },
                              child: const Icon(Icons.add, size: 30,  color: Colors.black,)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: MasonryGridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      itemCount: defaultImage.length,
                      itemBuilder: (context, index){
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image(
                                image: NetworkImage(defaultImage[index]),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Align(
                                  child: GestureDetector(
                                    onTap: (){
    showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
    return buildBottomSheet(
    context, index);
    });
    },

                                    child: const Icon(FontAwesomeIcons.ellipsisH, color: Colors.black, size: 17,),
                                  ),
                                  alignment: Alignment.centerRight,
                                ),
                              ),
                              width: MediaQuery.of(context).size.width/2,
                              height: 20,
                            ),
                          ],
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheet(){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / (5/2) + 30,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 25,
                    ),
                    splashRadius: 5,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text("Send Pinner", style: TextStyle(fontSize: 16, color: Colors.black),)
                ],
              ),
            ),
          ),
          SizedBox(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const SizedBox(
                  width: 20,
                ),

                // telegram #share
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SizedBox(
                      child: CircleAvatar(
                          radius: 35,
                          foregroundImage: AssetImage("assets/images/img_3.png")
                      ),
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Telegram",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    )
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),

                // whatsapp #share
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SizedBox(
                      child: CircleAvatar(
                          radius: 35,
                          foregroundImage:AssetImage("assets/images/img_4.png")
                      ),
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "WhatsApp",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    )
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),

                // message
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SizedBox(
                      child: CircleAvatar(
                          radius: 35,
                          foregroundImage: AssetImage("assets/images/img_1.png")
                      ),
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Message",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    )
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),

                // gmail
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SizedBox(
                      child: CircleAvatar(
                          radius: 35,
                          foregroundImage: AssetImage("assets/images/img_5.png")
                      ),
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Gmail",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    )
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey.shade100,
                        child: Icon(Icons.more_horiz_outlined, color: Colors.grey, size: 30,),
                      ),
                      height: 60,
                      width: 60,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "More",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    )
                  ],
                ),
              ],
            ),
            height: 100,
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }

SizedBox buildBottomSheet(BuildContext context, int index) {
  return SizedBox(
    height: MediaQuery.of(context).size.height / (3 / 2) ,
    width: MediaQuery.of(context).size.width,
    child: Column(
      children: [
        SizedBox(
          height: 10,
        ),

        // close #icon and text
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {Navigator.of(context).pop();},
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 26,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Share to',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          height: 30,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(
          height: 18,
        ),

        SizedBox(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(
                width: 20,
              ),

              // telegram share icon
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: CircleAvatar(
                      radius: 35,
                      foregroundImage: NetworkImage(
                          "https://www.vectorico.com/download/social_media/Telegram-Icon.png"),
                    ),
                    height: 60,
                    width: 60,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Telegram",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ],
              ),
              SizedBox(
                width: 20,
              ),

              // whatsapp share icon
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  SizedBox(
                    child: CircleAvatar(
                      radius: 35,
                      foregroundImage: NetworkImage(
                          "https://yt3.ggpht.com/a/AGF-l7_jgH6ieffY9170cc67XvlZhKy9brJ7DR1t5g=s900-c-k-c0xffffffff-no-rj-mo"),
                    ),
                    height: 60,
                    width: 60,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Twitter",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ],
              ),
              SizedBox(
                width: 20,
              ),
              // facebook messenger
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      foregroundImage: NetworkImage(
                          "https://www.gizchina.com/wp-content/uploads/images/2020/05/messenger.png"),
                    ),
                    height: 60,
                    width: 60,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Messenger",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ],
              ),
              SizedBox(
                width: 20,
              ),
              // whatsapp share icon
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  SizedBox(
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      foregroundImage: NetworkImage(
                          "https://icon-library.com/images/whatsapp-png-icon/whatsapp-png-icon-9.jpg"),
                    ),
                    height: 60,
                    width: 60,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "WhatsApp",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ],
              ),
              SizedBox(
                width: 20,
              ),

              // gmail #share
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  SizedBox(
                    child: CircleAvatar(
                      radius: 35,
                      foregroundImage: NetworkImage(
                          "https://usercontent.one/wp/www.techregister.co.uk/wp-content/uploads/2021/08/1629988226_How-to-Block-Someone-in-Gmail.png"),
                    ),
                    height: 60,
                    width: 60,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Gmail",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ],
              ),
              SizedBox(
                width: 20,
              ),


            ],
          ),
          height: 100,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(
          height: 20,
        ),
        Divider(
          height: 0.5,
          color: Colors.black.withOpacity(0.3),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: GestureDetector(
                onTap: () {
                  if (kDebugMode) {
                    print("Download Image");
                    _save(index);
                  }

                },
                child: const Text(
                  "Download Image",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 20),
                )),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: GestureDetector(
                onTap: () {
                  if (kDebugMode) {
                    print("Hide Pin");
                  }
                },
                child: const Text(
                  "Hide Pin",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 20),
                )),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: GestureDetector(
                onTap: () {
                  if (kDebugMode) {
                    print("Report Pin");
                  }
                },
                child: const Text(
                  "Report Pin",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 20),
                )),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: GestureDetector(
                onTap: () {
                  if (kDebugMode) {
                    print("Report Pin");
                  }
                },
                child: Text(
                  "This goes against Pinterest's community guidelines",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 15),
                )),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Divider(
          height: 0.5,
          color: Colors.black.withOpacity(0.3),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "This Pin is inspired by your recent activity",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 15),
            ),
          ),
        ),
      ],
    ),
  );
}
}
