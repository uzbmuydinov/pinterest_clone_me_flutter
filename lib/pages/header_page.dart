import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinterest_clone_me_flutter/pages/account_page.dart';
import 'package:pinterest_clone_me_flutter/pages/search_page.dart';
import 'comment_page.dart';
import 'home_page.dart';


class HeaderPage extends StatefulWidget {


  static const String id = 'header_page';
  const HeaderPage({Key? key}) : super(key: key);
  @override
  _HeaderPageState createState() => _HeaderPageState();
}

class _HeaderPageState extends State<HeaderPage> {
  late final PageController _pageController = PageController();
  int _selectedIndex = 0;
  // get show => widget.show;

  // final ScrollController _scrollBottomBarController = ScrollController();
  // bool isScrollingDown = false;
  // bool _show = false;

  // void myScroll() async {
  //   _scrollBottomBarController.addListener(() {
  //     if (_scrollBottomBarController.position.userScrollDirection ==
  //         ScrollDirection.reverse) {
  //       if (!isScrollingDown) {
  //         isScrollingDown = true;
  //         hideBottomBar();
  //       }
  //     }
  //     if (_scrollBottomBarController.position.userScrollDirection ==
  //         ScrollDirection.forward) {
  //       if (isScrollingDown) {
  //         isScrollingDown = false;
  //         showBottomBar();
  //       }
  //     }
  //   });
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   myScroll();
  // }
  //
  // @override
  // void dispose() {
  //   _scrollBottomBarController.removeListener(() {});
  //   super.dispose();
  // }

  // void showBottomBar() {
  //   setState(() {
  //     _show = true;
  //   });
  // }
  //
  // void hideBottomBar() {
  //   setState(() {
  //     _show = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (int index){
          setState(() {
            _selectedIndex = index;
          });
        },
        children:const [
          HomePage(),
          SearchPage(),
          CommentPage(),
          AccountPage(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal:45, vertical: 15),
        child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.white,
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black.withOpacity(0.7),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_filled, size: 30,), label: ''),
                BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.search,), label: ''),
                BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.commentDots, size: 24,), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.perm_identity, size: 30,), label: ''),
              ],
              currentIndex: _selectedIndex,
              onTap: (int index){
                setState(() {
                  _selectedIndex = index;
                });
                _pageController.jumpToPage(index);
              },
            )
        ),
      ),
    );
  }
}
