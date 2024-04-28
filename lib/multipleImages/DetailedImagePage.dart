import 'package:flutter/material.dart';

class FullScreenImage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  FullScreenImage({required this.imageUrls, this.initialIndex = 0});

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage>{
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  void _navigateToNextImage() {
    if (_currentIndex < widget.imageUrls.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _navigateToPrevImage() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Screen Image'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.photo),
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                color: Colors.black,
                child: Center(
                  child: InteractiveViewer(
                    boundaryMargin: EdgeInsets.all(20.0),
                    minScale: 0.1,
                    maxScale: 2.0,
                    child: Image.network(
                      widget.imageUrls[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_left,
                  color: Colors.white,
                ),
                onPressed: _navigateToPrevImage,
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_right,
                    color: Colors.white,
                  ),
                  onPressed: _navigateToNextImage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

