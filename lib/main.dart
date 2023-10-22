import 'package:flutter_ais_bottombar/bloc/res_bloc.dart';
import 'package:flutter_ais_bottombar/bloc/res_event.dart';
import 'package:flutter_ais_bottombar/bloc/res_state.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Bar Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Page(),
    );
  }
}

class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    WorkPage(),
    AccountPage(),
    SquaresPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Дом"),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "Работа"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "Аккаунт"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_on), label: "Квадраты"),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _resBloc = ResBloc();

  @override
  void initState() {
    super.initState();
    _resBloc.eventSink.add(FetchPhotosEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GET Запрос Flutter')),
      body: StreamBuilder<ResState>(
        stream: _resBloc.state,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final state = snapshot.data;
          if (state is ResLoadedState) {
            return ListView.builder(
              itemCount: state.photos.length,
              itemBuilder: (context, index) {
                final photo = state.photos[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 4.0,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    title: Text('Title: ${photo.title}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Album ID: ${photo.albumId}'),
                        Text('ID: ${photo.id}'),
                        Text('URL: ${photo.url}'),
                        Text('Thumbnail URL: ${photo.thumbnailUrl}'),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is ResErrorState) {
            return Center(child: Text(state.message));
          }

          return SizedBox.shrink();
        },
      ),
    );
  }

  @override
  void dispose() {
    _resBloc.dispose();
    super.dispose();
  }
}

class WorkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lottie Animations')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animation1.json', width: 200, height: 200),
            SizedBox(height: 20),
            Lottie.asset('assets/animation2.json', width: 200, height: 200),
          ],
        ),
      ),
    );
  }
}

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text("Аккаунт"));
}

class SquaresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text("Квадраты"));
}
