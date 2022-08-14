import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final int initialIndex = 0;
  late PageController controller;
  late final ValueNotifier<int> currentIndexNotifier;

  @override
  void initState() {
    super.initState();
    controller = PageController(viewportFraction: 0.12, initialPage: initialIndex);
    currentIndexNotifier = ValueNotifier<int>(initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Fun Tab bar'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 100),
          FunTabBar(
            controller: controller,
            onTabChanged: (newIndex) {
              currentIndexNotifier.value = newIndex;
            },
            itemCount: 10,
            tabItemBuilder: (context, index) {
              return tabItem(value: index + 1, index: index);
            },
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              controller.previousPage(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut);
            },
            child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              controller.nextPage(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut);
            },
            child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget tabItem({required int value, required int index}) {
    return Center(
      child: ValueListenableBuilder<int>(
        valueListenable: currentIndexNotifier,
        builder: (context, selectedIndex, _) {
          final isSelected = selectedIndex == index;
          return Text(
            '$value',
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey.shade400,
              fontSize: 16,
            ),
          );
        },
      ),
    );
  }
}

class FunTabBar extends StatefulWidget {
  const FunTabBar({
    super.key,
    required this.controller,
    required this.itemCount,
    required this.tabItemBuilder,
    this.onTabChanged,
    this.isScrollable = true,
  });

  final PageController controller;
  final int itemCount;
  final Widget Function(BuildContext context, int index) tabItemBuilder;
  final Function(int index)? onTabChanged;
  final bool isScrollable;

  @override
  State<FunTabBar> createState() => _FunTabBarState();
}

class _FunTabBarState extends State<FunTabBar> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            const Divider(thickness: 2),
            Container(width: 40, height: 2, color: Colors.blue),
            const SizedBox(height: 16),
          ],
        ),
        buildTabSlider(),
      ],
    );
  }

  Widget buildTabSlider() {
    return SizedBox(
      height: 40,
      width: double.maxFinite,
      child: PageView.builder(
        physics: !widget.isScrollable ? const NeverScrollableScrollPhysics() : null,
        onPageChanged: widget.onTabChanged,
        itemCount: widget.itemCount,
        controller: widget.controller,
        itemBuilder: widget.tabItemBuilder,
      ),
    );
  }
}
