import 'package:flutter/material.dart';
import 'package:stack_bottom_appbar_widget/back_drop.dart';
import 'package:stack_bottom_appbar_widget/blur_nav_bar_item.dart';

void main() {
  runApp(const MyApp());
}

/// 很简单，一眼就是Stack打底，先是中间一个毛玻璃层，后面是一个Shape，后置于中间层，
/// zIndex最顶层是一个设定好宽高Container，用AnimationController根据bottombar选中的
/// 索引来做动画，根据系统深浅色主题，改变外观
///  https://juejin.cn/post/7216287037207445561
/// https://github.com/imWalsh/bottom_blur_bar/blob/main/lib/src/blur_nav_bar.dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'Flutter Demo Home Page',
        items: [],
      ),
    );
  }
}

enum BlurEffectStyle {
  /// 跟随系统
  auto,
  light,
  dark
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
      required this.title,
      required this.onTap,
      this.style = BlurEffectStyle.auto,
      this.selectedColor,
      this.borderRadius = 24,
      required this.items,
      this.currentIndex = 0,
      this.fontSize = 10,
      this.iconSize = 40})
      : assert(items.length > 1 && items.length <= 5, '至少2个，至多5个'),
        assert(currentIndex >= 0 && currentIndex < items.length)
  // ,super(key: key)
  ;

// 模糊效果
  final BlurEffectStyle style;
  final String title;
  final double borderRadius;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BlurNavbarItem> items;
  final double fontSize;
  final double iconSize;
  final Color? selectedColor;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// 不得不会的Mixin https://www.cnblogs.com/mengqd/p/14433128.html
/// www.laomenggit.com
class _MyHomePageState extends State<MyHomePage>
// with SignleTickerProviderStateMixin
{
  int _counter = 0;
  // 用于获取上级StatefulWidget 中的属性值？
  double get borderRadius => widget.borderRadius;
  // 底边栏列表项目集合
  List<BlurNavbarItem> get items => widget.items;
  Color? get selectedColor => widget.selectedColor;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 边框宽度，固定值
    const borderWidth = .7;
    // 底边栏中每项的宽度
    final itemWidth =
        (MediaQuery.of(context).size.width - borderWidth * 2) / items.length;

    final sColor = selectedColor ?? Theme.of(context).primaryColor;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    final double barHeight = 50 + bottomPadding;

// 根据圆角度数返回圆角外观对象
    final radius = Radius.circular(borderRadius);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      // 最外层先包裹一层Container用来显示边线和切割顶部左右圆角：
      body: Container(
        height: barHeight,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
            border: Border.all(
                // 灰色，透明度0.35
                color: Colors.grey.withOpacity(0.35),
                width: borderWidth,
                // border: borderBox
                strokeAlign: BorderSide.strokeAlignOutside)),

        /// TODO: 这是什么
        child: ClipRRect(
          borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
          // 利用Stack 实现效果的核心代码：
          child: Stack(children: [
            // 背景Shape
            Backdrop(
                color: sColor,
                width: width,
                height: height,
                selectedIndex: selectedIndex,
                previousIndex: previousIndex,
                controller: controller)
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
