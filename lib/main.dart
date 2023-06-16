import 'package:flutter/material.dart';

void main() {
  runApp(const AnimatedListApp());
}
class AnimatedListApp extends StatelessWidget {
  const AnimatedListApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AnimatedListView(),
    );
  }
}
class AnimatedListView extends StatelessWidget {
  const AnimatedListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated List'),
        centerTitle: true,
      ),
      body: const CustomAnimatedList(),
    );
  }
}
class CustomAnimatedList extends StatefulWidget {
  const CustomAnimatedList({Key? key}) : super(key: key);

  @override
  State<CustomAnimatedList> createState() => _CustomAnimatedListState();
}

class _CustomAnimatedListState extends State<CustomAnimatedList> {
  final List<String> items = [];
  final GlobalKey<AnimatedListState> key = GlobalKey();
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AnimatedList(
              key: key,
              controller: scrollController,
              initialItemCount: items.length,
              itemBuilder: (context, index, animation) {
                return SlideTransition(//or size transition for insert animation and size transition take animation without convert
                    position: animation.drive(Tween<Offset>(//to convert animation of double to offset
                        begin: const Offset(1, 0), end: const Offset(0, 0))),
                    child: AnimatedListItem(//item
                        onPressed: () {
                          deleteItem(index);
                        },
                        text: items[index]));
              }),
        ),
        TextButton(onPressed: insertItem, child: const Text('add'))//to addation
      ],
    );
  }
//insert لما اعملها لازم داخل ال ليست وكمان اقول ل انيمشن ليست ان حصل اضافة عشان تضيف وتعمل اعادة بناء عن طريق ال
  //key
  //وكذلك في المسح بقولها ان مسحت بس المسح بتاخد العنصر كامل
  void insertItem() {
    var index = items.length;
    items.add('item ${index + 1}');
    key.currentState!.insertItem(index);//take 300 milli second so make scroll delay 300 until scroll to last item
    Future.delayed(const Duration(milliseconds: 300), () {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    });
  }
//delete فيها كراش او اكسبشن لما تمسح عنصر من ال ليست بتاعت الداتا واجي اقوله اعمل مسح داخل ال ليست فيوو بيضرب
  //ليه لان انا تحت مديهitems[index] والعنصر دا المفروض انه اتمسح ومسح العنصر من ال ليست بياخد 300ملي ثانية لذلك بيضرب
  //الحل اخزن قيمة الداتا قبل ما امسحها وبالتالي ادهاله بدون ما اخدها من ال ليست وبذلك يتاخر براحته في المسح ومش هيضرب بس كده
  void deleteItem(int index) {
    var text=items.removeAt(index);
    key.currentState!.removeItem(index, (context, animation) {
      return SizeTransition(//animation to delete
          sizeFactor: animation,
          child: AnimatedListItem(text: text, onPressed: () {}));
    });
  }
}

class AnimatedListItem extends StatelessWidget {
  const AnimatedListItem(
      {Key? key, required this.text, required this.onPressed})
      : super(key: key);

  final String text;

  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.orange,
        ),
        title: Text(text),
        subtitle: const Text('sub title'),
        trailing:
        IconButton(onPressed: onPressed, icon: const Icon(Icons.delete)),
      ),
    );
  }
}