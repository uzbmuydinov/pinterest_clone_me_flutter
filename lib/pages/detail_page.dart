import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinterest_clone_me_flutter/models/pinterest_model.dart';
import 'package:pinterest_clone_me_flutter/services/http_service.dart';



class DetailPage extends StatefulWidget {

  String indexImage;
  DetailPage(this.indexImage, {Key? key}) : super(key: key);
  static const String id = "detail_page";
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ScrollController _scrollController = ScrollController();
  String name = "Alice Marathon";
  int seeMore = 3;
  List<Post> note = [];
  int _page = 4;

  void _showResponse(String response) {
    List<Post> list = HttpService.parseResponse(response);
    setState(() {
      note = list;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiGet();
    setState(() {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          _loadMore();
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  void apiGet() {
    HttpService.GET(HttpService.API_TODO_LIST, HttpService.paramEmpty())
        .then((value) {
      if (value != null) {
        _showResponse(value);
      }
    });
  }

  Future<void> _loadMore() async {
    String? response = await HttpService.GET(HttpService.API_TODO_LIST, HttpService.paramsPage(_page + 1, 10));
    List<Post> list = HttpService.parseResponse(response!);
    setState(() {
      note.addAll(list);
      _page += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // user #info
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(23.0),
                      child: Column(
                        children: [
                          Image(
                            image: NetworkImage(widget.indexImage),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),),
                          const SizedBox(
                            height: 20,
                          ),


                          SizedBox(
                            height: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: (){
                                    if (kDebugMode) {
                                      print("comment");
                                    }
                                  },
                                  icon: const Icon(FontAwesomeIcons.comment, color: Colors.black,),
                                ),
                                Row(
                                  children: [
                                    MaterialButton(
                                      elevation: 0,
                                      onPressed: (){},
                                      height: 60,
                                      shape: const StadiumBorder(),
                                      color: Colors.grey.withOpacity(0.3),
                                      child: const Text("View", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    MaterialButton(
                                      elevation: 0,
                                      height: 60,
                                      shape: const StadiumBorder(),
                                      onPressed: (){},
                                      color: Colors.red.shade800,
                                      child: const Text("Save", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),),
                                    ),
                                  ],

                                ),
                                IconButton(
                                  onPressed: (){
                                    if (kDebugMode) {
                                      print("comment");
                                    }
                                  },
                                  icon: const Icon(Icons.share, color: Colors.black,),
                                ),

                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(
                height: 3,
              ),

              // comments
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 18,
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text("Comments", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black),),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey.shade300,
                              child: Center(
                                child: TextButton(
                                  onPressed: (){},
                                  child: Text(name.substring(0, 1), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 25, color: Colors.black),),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text("@uzbmuydinov", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("amazing!", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: const [
                                Icon(Icons.favorite, color: Colors.black,),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Reply", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey.shade300,
                              child: Center(
                                child: TextButton(
                                  onPressed: (){
                                    if (kDebugMode) {
                                      print("Hello => welcome account");
                                    }
                                  },
                                  child: Text(name.substring(0, 1), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 25, color: Colors.black),),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){},
                          child: Text("Add a comment", style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w500),),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: MaterialButton(
                        elevation: 0,
                        onPressed: (){},
                        height: 50,
                        shape: const StadiumBorder(),
                        color: Colors.grey.withOpacity(0.3),
                        child: Text("See ${seeMore.toString()} more", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: const [
                      SizedBox(
                        height: 18,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text("More likes this", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black),),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                    ],
                  )
              ),
              Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: MasonryGridView.builder(
                    controller: _scrollController,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: note.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.circular(15.0),
                                child: Image(
                                  image: NetworkImage(note[index].urls!.small!),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5, top: 5),
                              child: GestureDetector(
                                onTap: () {},
                                child: const Align(
                                  child: Icon(FontAwesomeIcons.ellipsisH, color: Colors.black, size: 15,
                                  ),
                                  alignment: Alignment.centerRight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
