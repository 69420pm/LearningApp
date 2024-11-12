import 'package:flutter/material.dart';
import 'package:rect_getter/rect_getter.dart';

class Listing extends StatefulWidget {
  @override
  _ListingState createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  ScrollController controller = ScrollController();
  ScrollPhysics physics = ClampingScrollPhysics();
  var rectGlobalKey = RectGetter.createGlobalKey();
  double screenHeight = SharedViews.getScreenHeight();
  var customHeight = 0.0;
//LISTINFS
  void newListings() {
//IMP RESET CONTAINER, SO AFTER SETSTATE IT WILL AUTO ADJUST SIZE
    customHeight = 0.0;
    this.setState(() {});
//FETCH EMPTY SIZE
    Future.delayed(Duration(milliseconds: 150), () {
      getBottomSpace();
    });
  }

  @override
  void initState() {
    super.initState();
//GET NEW HEIGHT OF CONTAINER AFTER CERT LOADED
    newListings();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 100), () {
        getBottomSpace();
      });
    });
  }

  Widget bottomCard() {
    return RectGetter(
      key: rectGlobalKey,
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
              Color(0xffdbf5ff),
              Color.fromRGBO(241, 251, 255, 0.24),
            ])),
      ),
    );
  }

  getBottomSpace() {
    if (data.length != 0) {
      var rect;
      rect = RectGetter.getRectFromKey(rectGlobalKey);
      var x =
          screenHeight - rect.bottom - MediaQuery.of(context).padding.vertical;
      if (x > 1.0) {
        setState(() {
          customHeight = x;
        });
      }
    }
  }

  Widget ListWidget(context, data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Container(
              width: SharedViews.getScreenWidth(),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [],
                ),
              ),
            ),
            ListView.separated(
              physics: ClampingScrollPhysics(),
              controller: controller,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (BuildContext context, i) {
                return ListItem(title: data[i].title);
              },
              separatorBuilder: (BuildContext context, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  color: AppColors.cBLACK_10,
                  thickness: 1,
                ),
              ),
            ),
          ],
        ),
        data.length != 0
            ? AnimatedContainer(
                duration: Duration(milliseconds: 100),
                curve: Curves.easeIn,
                height: customHeight,
              )
            : Container(),
        data.length != 0 ? bottomCard() : Container(),
        SizedBox(
          height: customHeight == 0 ? MediaQuery.of(context).padding.bottom : 0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var data = [
      {"name": "test1"},
      {"name": "test2"},
      {"name": "test3"}
    ];
    return ListWidget(context, data);
  }
}
