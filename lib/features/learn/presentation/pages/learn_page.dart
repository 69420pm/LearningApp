import 'package:flutter/material.dart';
import 'package:learning_app/core/ui_components/ui_components/responsive_layout.dart';
import 'package:learning_app/core/ui_components/ui_components/widgets/ui_appbar.dart';
import 'package:learning_app/generated/l10n.dart';

class _CardContent {
  final List<Widget> front;
  final List<Widget> back;

  _CardContent(this.front, this.back);
}

class LearnPage extends StatelessWidget {
  LearnPage({super.key});

  //get from api
  final List<_CardContent> _content = List.generate(3, (index) {
    return _CardContent(
      List.generate(10, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            width: 100,
            color: Colors.red,
            child: Center(
              child: Text('Front $index'),
            ),
          ),
        );
      }),
      List.generate(10, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            width: 100,
            color: Colors.green,
            child: Center(
              child: Text('Back $index'),
            ),
          ),
        );
      }),
    );
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _LearnViewMobile(
        content: _content,
      ),
    );
  }
}

class _LearnViewMobile extends StatefulWidget {
  const _LearnViewMobile({super.key, required this.content});

  final List<_CardContent> content;

  @override
  State<_LearnViewMobile> createState() => _LearnViewMobileState();
}

class _LearnViewMobileState extends State<_LearnViewMobile> {
  final PageController _pageController = PageController(
    initialPage: 1,
  );

  final ScrollController _scrollController = ScrollController();

  int _currentCard = 0;
  bool _showFront = true;

  @override
  void initState() {
    _pageController.addListener(
      () {
        if (_pageController.page == 2 || _pageController.page == 0) {
          if (_currentCard >= widget.content.length - 1) {
            Navigator.of(context).pop();
          } else {
            setState(() {
              _currentCard++;
              _showFront = true;
              _pageController.jumpToPage(1);
              _scrollController.jumpTo(0);
            });
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIAppBar(
        title: S.of(context).learnPage,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: 3,
        itemBuilder: (context, index) {
          if (index == 1) {
            return GestureDetector(
              onTap: () => setState(() {
                _showFront = !_showFront;
                _scrollController.jumpTo(0);
              }),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: _showFront
                      ? widget.content[_currentCard].front
                      : widget.content[_currentCard].back,
                ),
              ),
            );
          }
          return Container(
            color: index == 0 ? Colors.green : Colors.red,
          );
        },
      ),
    );
  }
}
