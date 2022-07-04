import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinterest_clone_me_flutter/models/pinterest_model.dart';
import 'package:pinterest_clone_me_flutter/models/utils.dart';
import 'package:pinterest_clone_me_flutter/services/http_service.dart';


class SearchPhotoTest extends StatefulWidget {

  static const String id = 'search_test';

  @override
  _SearchPhotoTestState createState() => _SearchPhotoTestState();
}

class _SearchPhotoTestState extends State<SearchPhotoTest> with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  int pageNumber = 1;


  List<Post> note = [];
  bool isLoading = true;
  bool isLoadMore = false;

  void _searchImage() async {
    String image = textEditingController.text.trim().toString();
    dynamic response = await HttpService.GET(HttpService.API_TODO_SEARCH, HttpService.paramsSearch(pageNumber, image));
    List<Post> newPosts = HttpService.parseSearchParse(response);
    setState(() {
      note.addAll(newPosts);
      isLoadMore = false;
      pageNumber += 1;
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchImage();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          isLoadMore = true;
        });
        _searchImage();
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: TextField(
              controller: textEditingController,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _searchImage();
              },
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search for ideas',
                  prefixIcon: Icon(Icons.search, color: Colors.black,),
                  suffixIcon: Icon(Icons.camera_alt, color: Colors.black,)
              ),
            ),
          ),
        ),
      ),
      body:  MasonryGridView.builder(
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
                // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                //   return DetailPage(note[index].urls!.small!);
                // })
                // );
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
                                        context);
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
    );
  }

  SizedBox buildBottomSheet(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / (3 / 2) + 10,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),

          // close #icon and text
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
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
                          fontWeight: FontWeight.w400,
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

                // telegram #share
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
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
                const SizedBox(
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
                            "https://cdn.icon-icons.com/icons2/730/PNG/512/gmail_icon-icons.com_62758.png"),
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