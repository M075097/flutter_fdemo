import 'package:flutter/material.dart';

void main() => runApp(new TestApp());

class TestApp extends StatelessWidget {
  //无状态组件--StatelessWidget
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Test Demo',
      theme: new ThemeData( //设置主题相关
        // This is the theme of your application.
        primarySwatch: Colors.blueGrey, //主题颜色，对应APPBar的默认颜色会使用该处定义的颜色
      ),
      /* home: new Scaffold(
         appBar: new AppBar(
          title: new Text("Welcom to test Flutter"),
        ),
        body: new Center(
          child: new Text('Hello World!'),
        ),
      ),*/
      home: new BookListWidget(), //给出一个自定义带状态组件
    );
  }
}

//自定义带状态组件
class BookListWidget extends StatefulWidget {
  //有状态组件--StatefulWidget
  @override
  State<StatefulWidget> createState() {
    //需要覆写此方法，声明对应的State
    return new BookListState();
  }

}

class BookListState extends State<BookListWidget> {
  //带状态组件，一般数据在此处与组件相互作用
  final _bookDataList = <BookData>[];
  final _choicedBookList = <BookData>[];
  final _listTextStyle = const TextStyle(
      fontSize: 18.0,
      color: Colors.black);
  final _listTextLittleStyle = const TextStyle(
      fontSize: 8.0,
      color: Colors.grey);
  final _listTextsecLittleStyle = const TextStyle(
      fontSize: 12.0,
      color: Colors.black45
  );
  var batchNum = 1;//数据为模拟数据，每一批数据添加标识以作区分

  @override
  Widget build(BuildContext context) {
    //每次调用setState(),都会触发该方法调用
    //    return _buildListView();
    return new Scaffold( //同样脚手架--》相当于根布局
      appBar: new AppBar( //TitleBar,如果不需要可以直接注掉
        title: new Text("书架", //标题内容
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          new IconButton( //对应titleBar右侧菜单按钮
            icon: new Icon(Icons.list),
            onPressed: _navigate2Detail, //按下触发该方法，该方法后不需要加(),否则解析到此处会直接调用
          ),
        ],
        centerTitle: true, //标题对齐方式
      ),
      body: _buildListView(true), //对应body部分视图组件
    );
  }

//ListView构建，在右上角导航之后的下个页面中复用了该方法、使用isAll标记数据源具体使用哪个
  Widget _buildListView(bool isAll) {
    if (isAll) { //条目构建
      return new ListView.builder(
          padding: const EdgeInsets.all(0.0),
          itemBuilder: (context,
              i) { //该方法中的i值是自增的，具体需要根据数据集合大小做判定返回，需要返回一个条目的视图
            if (i.isOdd)
              return new Divider(
                color: Colors.grey,
                height: 1.0,);
            final index = i ~/ 2;
            if (index >=
                _bookDataList.length) { //此处判定数据加载完毕则直接添加新数据，保证该listView无限
              _bookDataList.addAll(generateBookData());
            }
            return _buildItemView(_bookDataList[index]); //返回对应条目视图
          }
      );
    } else { //当给入的参数为 false时，则只渲染已选中的数据条目，条目UI相同直接复用了该构建条目的方法
      print("favorites");
      print(_choicedBookList.toString());
      return new ListView.builder(
          padding: const EdgeInsets.all(0.0),
//        padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          itemBuilder: (context, j) {
            if (j.isOdd)
              return new Divider(
                color: Colors.grey,
                height: 1.0,);
            final index2 = j ~/ 2;
            print(j);
            print(index2);

            if (index2 <
                _choicedBookList.length) { //此处需要判断，是否超出数据长度，否则报out of range 错误
              return _buildItemView(_choicedBookList[index2]);
            }
          }
      );
    }
  }

  //根据数据生成ListView中的Item组件视图
  Widget _buildItemView(BookData bookData) {
    final bool alreadChoice = _choicedBookList.contains(bookData);
    return new Padding( //Padding 布局可以设置内部边距，child：对应该容器对应的组件
      padding: const EdgeInsets.all(5.0), //设置内边距
      child: new Row( //该布局对应的横向排列，相当于横向LinearLayout
        verticalDirection: VerticalDirection.down,
        //组件方向
        mainAxisSize: MainAxisSize.max,
        //主轴方向大小，max则在横向占满空间，高度则为Wrap类型的，此处设置为min会导致控件不显示
        crossAxisAlignment: CrossAxisAlignment.start,
        //所有子组件上对齐，相当于alignParentTop，parent指代该Row布局
        children: <Widget>[ //children:对应所有子组件信息
          new Container( //该布局可以设置大小
            alignment: Alignment.center,
//            padding: const EdgeInsets.all(3.0),
            width: 100.0,
            height: 100.0,
            child: new Image.network( //Image 组件可以直接从网络加载图片
              bookData.bookcoverurl, //对应需要加载图片的url
              width: 75.0,
              height: 100.0,
              fit: BoxFit.fill, //图片填充方式
            ),
          ),
          new Expanded( //该布局对应占完父布局中的剩余空间，相当于在LinearLayour中子View设置weight = 1
              child: new Container(
                //alignment: Alignment.topLeft, //设置对齐方式？？无效
                padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0), //设置内边距
                child: new Column( //该布局对应竖向布局，相当于竖向的LinearLayout
                  verticalDirection: VerticalDirection.down,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //该属性会使主轴垂直方向按设置对齐
                  children: <Widget>[ //对应所有子组件
                    new Text(
                      "书名：" + bookData.name,
                      style: _listTextStyle,
                    ),
                    new Text(
                      "作者：" + bookData.autor,
                      style: _listTextLittleStyle,
                    ),
                    new Text(
                      "价格：￥" + bookData.price.toString(),
                      style: _listTextsecLittleStyle,
                    ),
                  ],
                ),
              )
          ),
          new Container(
            height: 100.0, //此处不设置高度默认经上面父布局Row中的crossAxisAlignment: CrossAxisAlignment.start,属性使该控件位于上方不居中，宽度不设置则自动为Wrap
            alignment: Alignment.center,
            child: new GestureDetector( //该组件对应可以相应相关动作，对组件进行了一层包装
              onTap: () { //点击事件最终会触发该方法
                setState(() {
                  if (alreadChoice) {
                    _choicedBookList.remove(bookData);
                    print("remove");
                  }
                  else {
                    _choicedBookList.add(bookData);
                    print("add");
                  }
                });
              },
              child: new Icon( //对应Icon组件，系统自带
                alreadChoice ? Icons.favorite : Icons.favorite_border,
                color: alreadChoice ? Colors.red : null,
              ),
            ),
          ),
        ],
      ),

    );
  }

  //点击topbar右侧菜单按钮，执行该方法，进行页面导航
  _navigate2Detail() {
    print("go to next page!");
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) {
          return new Scaffold( //渲染器<脚手架>,相当于整体页面布局，
            appBar: new AppBar(
              title: new Text('收藏的书籍'),
            ),
            body: _buildListView(
                false), //对应body视图的生成，复用前一页的视图生成，根据标志位使用相应选中的数据集合
          );
        })
    );
  }


  //生成模拟数据
  Iterable<BookData> generateBookData() {
    final listBookName = [ //对应List的定义即为如此
      "区块链",
      "大数据",
      "人工智能",
      "深度学习",
      "卷积神经",
      "物联网",
      "无人驾驶",
      "支付加密",
      "自我意识",
      "宇宙深处"
    ];

   /* final String a = "adad"; // OK

    final String a1;//错误 必须赋值。
    const String a2; //错误 必须赋值

    String b = "adad";//OK
    String b1;//OK

    var d;//OK,var 声明可变变量，可以不赋值
    var d1 = "aaaa";//OK,var 声明可变变量，也可以赋值
    //var String = "";//错误写法,Dart没有关键字保留，此时String 被认为是一个普通变量，

    e = "adas";//错误,此时e没有被生命过*/


    final listAutorName = [
      "丁丁张",
      "[美] H.P.洛夫克拉夫特 ",
      " [美] 克里斯·克劳利",
      "[英] 珍妮特·温特森 ",
      "[马来西亚] 黄锦树",
      "[挪] 尤·奈斯博 ",
      "李硕",
      "[日] MONCEAU FLEURS ",
      "黄鹭",
      "贝尔纳黛特·墨菲"
    ];
    final listBookCoverUrl = [
      "https://img3.doubanio.com/lpic/s29625884.jpg",
      "https://img3.doubanio.com/lpic/s29700193.jpg",
      "https://img3.doubanio.com/lpic/s29712680.jpg",
      "https://img3.doubanio.com/lpic/s29679753.jpg",
      "https://img3.doubanio.com/mpic/s29682706.jpg",
      "https://img1.doubanio.com/mpic/s29667478.jpg",
      "https://img1.doubanio.com/mpic/s29669647.jpg",
      "https://img3.doubanio.com/mpic/s29648610.jpg",
      "https://img3.doubanio.com/mpic/s29683281.jpg",
      "https://img1.doubanio.com/mpic/s29664089.jpg",
    ];
    var listtemp = <BookData>[];
    for (var i = 0; i < 10; i++) {
      BookData bookData = new BookData();
      bookData.autor = listAutorName[i];
      bookData.name = batchNum.toString() + listBookName[i];
      bookData.price = 12 + i;
      bookData.bookcoverurl = listBookCoverUrl[i];
      listtemp.add(bookData);
    }
    batchNum++;
    return listtemp;
  }
}


//数据元和java类似
class BookData {
  String name;
  String autor;
  int price;
  String bookcoverurl;
}