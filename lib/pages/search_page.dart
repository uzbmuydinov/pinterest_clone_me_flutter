import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_clone_me_flutter/models/pinterest_model.dart';
import 'package:pinterest_clone_me_flutter/services/http_service.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  static const String id = "search_page";
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final _image = [
    "https://kpdclub.ru/chernomorskoe/images/upload/1080x720/1657.png",
    "https://i.pinimg.com/originals/82/ba/bf/82babf9b64bf993809e1aac8c7e7d376.jpg",
    "https://i.pinimg.com/736x/78/c9/72/78c9726986bfc9b1714c534da7ce7f82.jpg",
  ];
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
  late int _page = 1;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / (5/2),
              width: MediaQuery.of(context).size.width,
              child: PageView(
                scrollDirection: Axis.horizontal,
                children: const [
                  Image(
                    image: NetworkImage("https://images7.alphacoders.com/977/thumb-1920-977986.jpg"),
                    fit: BoxFit.cover,
                  ),
                  Image(
                    image: NetworkImage("https://homebuilding.ru/wp-content/uploads/2016/02/Ribbon-Chapel-v-Onomichi-KHirosima.jpg"),
                    fit: BoxFit.cover,
                  ),
                  Image(
                    image: NetworkImage("https://i.pinimg.com/236x/8b/c3/42/8bc34251074979f9b5d6f93b2d9777ee.jpg"),
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Ideas from creators", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black),),
            const SizedBox(
              height: 15,
            ),
            ideaFromCreators(),
            const SizedBox(
              height: 20,
            ),
            const Text("Shopping spotlight", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black),),
            const SizedBox(
              height: 15,
            ),


            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.symmetric(horizontal: 7),
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  image: const DecorationImage(
                      image: NetworkImage("https://catherineasquithgallery.com/uploads/posts/2021-02/1612336129_104-p-fon-rabochego-stola-shokolad-209.jpg"),
                      fit: BoxFit.cover
                  )
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Chocolate moon amour", style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.w600),),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Popular on Pinterest", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black),),
            const SizedBox(
              height: 15,
            ),
            popularOn(),
          ],
        ),
      ),
    );
  }

  // Idea from creators
  Widget ideaFromCreators(){
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _image.length + 1,
        itemBuilder: (context, index){
          return _image.length != index ? Stack(
            children: [
              GestureDetector(
                onTap: (){
                  print("Welcome to hot ideas");
                },
                child: Container(
                  margin: index != _image.length - 1 ? const EdgeInsets.only(left: 7) : const EdgeInsets.only(left: 7, right: 7),
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.height / 3 - 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: CachedNetworkImage(
                      imageUrl: _image[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: MediaQuery.of(context).size.width / 6 - 10.5,
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 19,
                    backgroundColor: Colors.grey,
                  ),
                ),
              )
            ],
          ) : Container(
            margin: const EdgeInsets.only(right: 7),
            width: MediaQuery.of(context).size.width / 3,
            height: 60,
            child: Center(
              child: MaterialButton(
                elevation: 0,
                onPressed: (){},
                height: 60,
                minWidth: MediaQuery.of(context).size.width / 3 - 20,
                shape: const StadiumBorder(),
                color: Colors.grey.withOpacity(0.3),
                child: const Text("View all", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),),
              ),
            ),
          );
        },
      ),
    );
  }

  // popular on pinterest
  Widget popularOn(){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: MasonryGridView.builder(
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          crossAxisSpacing: 7,
          mainAxisSpacing: 7,
          itemCount: 6,
          itemBuilder: (context, index){
            return SizedBox(
              height: MediaQuery.of(context).size.height / 7,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: "https://yobte.ru/uploads/posts/2019-11/kosmos-76-foto-11.jpg",
                  placeholder:(context, index) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.grey,
                    ),
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
