import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinterest_clone_me_flutter/models/pinterest_model.dart';
import 'package:pinterest_clone_me_flutter/models/utils.dart';
import 'package:pinterest_clone_me_flutter/pages/detail_page.dart';
import 'package:pinterest_clone_me_flutter/services/http_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final ScrollController _scrollController = ScrollController();
  late int _page = 1;

  List<Post> note = [];
  bool isLoading = true;
  bool isLoadMore = false;

  void _showResponse(String response) {
    List<Post> list = HttpService.parseResponse(response);
    setState(() {
      note = list;
      isLoading = false;
    });
  }

  void apiGet() {
    HttpService.GET(HttpService.API_TODO_LIST, HttpService.paramEmpty())
        .then((value) {
      if (value != null) {
        // tekshirish uchun. faqat debug modeda ishlaydi
        if (kDebugMode) {}
        _showResponse(value);
      }
    });
  }

  Future<void> _loadMore() async {
    String? response = await HttpService.GET(
        HttpService.API_TODO_LIST, HttpService.paramsPage(_page + 1, 10));
    List<Post> list = HttpService.parseResponse(response!);
    setState(() {
      //UtilsColors(value: note[1].color!).toColor();

      note.addAll(list);
      isLoadMore = false;
      _page += 1;
    });
  }


  static List<Tab> _tabs = [

    Tab(
      height: 40,
      child: Container(
        width: 80,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'All',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
    Tab(
      height: 40,
      child: SizedBox(

        child: Container(
          width: 80,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: Text(
              'UX/UI',
              style: TextStyle(fontSize: 14),
              overflow: 'UX'.length >= 10
                  ? TextOverflow.ellipsis
                  : TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ),
    Tab(
      height: 40,
      child: Container(
        width: 80,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            'Modern',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),

  ];

  @override
  void initState() {

    super.initState();
    myScroll();
    apiGet();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.animateTo(0);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          isLoadMore = true;
        });
        _loadMore();
      }
    });
  }
  final ScrollController _scrollBottomBarController = ScrollController();
  bool isScrollingDown = false;
  bool _show = false;


  // scroll detection
  void myScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          hideBottomBar();
        }
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          showBottomBar();
        }
      }
    });
  }
  void showBottomBar() {
    setState(() {
      _show = true;
    });
  }

  void hideBottomBar() {
    setState(() {
      _show = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.removeListener(() {});
    _scrollController.dispose();
  }

  late int colorIndex;

  // save function

  _save(int index) async{
    var status=await Permission.storage.request();
    if (status.isGranted){
      var response =await Dio().get(
        note[index].urls!.small!,
        options: Options(responseType: ResponseType.bytes)
      );
      final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),
          quality: 80,
        name: DateTime.now().toString()
      );
      print(result);

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 58,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBar(

              // isScrollable funksiyasi tabbardagi berilgan narsalar scroll bo'la olishi yoki bo'lmasligini belgilaydi
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              indicator: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(25.0),
              ),
              tabs: _tabs,
              controller: _tabController,
            ),
          ),
        ),
      ),
      body: TabBarView(

        // tabbarni boshqarish uchun controller funksiya
        controller: _tabController,

        children: [

          isLoading
              ? Center(
            child: SizedBox(
              height: 40,
              width: 40,

             // lottie animation load
              /*child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blueGrey,
                child: Lottie.asset('assets/lottie/lf30_editor_naboxmse.json'),
              ),*/

              child: CircularProgressIndicator(
                strokeWidth: 4.0,
                color: Colors.black,
              ),
            ),
          )
              : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Expanded(
                  flex: isLoadMore ? 11 : 1,
                  child: MasonryGridView.builder(
                    controller: _scrollController,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: note.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                              return DetailPage(note[index].urls!.small!);
                            })
                            );
                          },
                          child: Column(
                            children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: CachedNetworkImage(
                                        imageUrl: note[index].urls!.small!,
                                        placeholder: (context, widget) => AspectRatio(
                                          aspectRatio: note[index].width!/note[index].height!,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15.0),
                                              color: UtilsColors(value: note[index].color!).toColor(),
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [note[index].altDescription == null
                                      ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.favorite_rounded, color: Colors.red,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(note[index].likes.toString())
                                    ],
                                  )
                                      : SizedBox(
                                      width: MediaQuery.of(context).size.width / 2 - 60,
                                      child: note[index].altDescription!.length > 50
                                          ? Text(
                                        note[index].altDescription!, overflow: TextOverflow.ellipsis,
                                      )
                                          : Text(note[index].altDescription!)),
                                    GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              context: context,
                                              builder: (context) {
                                                return buildBottomSheet(
                                                    context, index);
                                              });
                                        },
                                        child: const Icon(
                                          FontAwesomeIcons.ellipsisH,
                                          color: Colors.black,
                                          size: 15,
                                        ))
                                  ],
                                ),
                              )
                            ],
                          )
                      );
                    },
                  ),
                ),
                isLoadMore
                    ? Expanded(
                  flex: 2,

                 // animatsia bo'pturadigan effekt
                  child: Container(
                    alignment: Alignment.topCenter,
                    color: Colors.transparent,
                    /*child: CircleAvatar(
                      radius: 30,
                      child: Lottie.asset('assets/lottie/wave.json'),
                    ),*/

                    child: const CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                      color: Colors.black,
                    ),
                  ),
                )
                    : const SizedBox.shrink()
              ],
            ),
          ),
          Container(),
          Container(),
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
