import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/Genres.dart';
import '../widgets/authenticationScreen.dart';
import '../services/authentication.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool needToLogin = false;
  String photo =
  'https://cdn.midjourney.com/4bedaeb8-115c-4e49-a061-d86274154095/0_0.png';


  Future<String> getUserPhoto() async {

    final prefs = await SharedPreferences.getInstance();
    photo = prefs.getString("photoURL") ??
        photo;
    return photo;
  }

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString("displayName") ?? "Reader";
    return name;
  }

  List<String> selectedLabels = [];
  List<Genre> fakeGenres = FakeData.generateGenres();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(16),
      child: ListView(
        children: [
          SizedBox(height: 20,),
          // User Profile Section
         _buildHeader(),
          SizedBox(height: 20,),
          _buildLogoutButton(),
          // Subscriptions Section
          _buildSubscriptions(),
          SizedBox(height: 20),
           // Interests Section
          _buildInterestGrid(),
          SizedBox(height: 20),

          // Notifications Section
          _buildNotificationsCards(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Column(
        children: [
          FutureBuilder<String>(
            future: getUserPhoto(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(snapshot.data!),
                );
              } else if (snapshot.hasError) {
                return CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://cdn.midjourney.com/4bedaeb8-115c-4e49-a061-d86274154095/0_0.png'),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),

          SizedBox(height: 10),
          FutureBuilder<String>(
            future: getUserName(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  snapshot.data!,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                );
              } else if (snapshot.hasError) {
                return Text(
                  'Error retrieving name',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          //SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSubscriptions() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
        'Subscriptions',
        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Card(
          child: ListTile(
        title: Text('Annual Subscriptions'),
        onTap: () {
          // Handle annual subscription tap
        },
      )),
      Card(
          child: ListTile(
        title: Text('Monthly Subscriptions'),
        onTap: () {
          // Handle monthly subscription tap
        },
      )),]
    ),);
  }

  Widget _buildInterestGrid(){
    return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interests',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
              ),
              itemCount: fakeGenres.length, // Replace with your list of genres
              itemBuilder: (context, index) {
                final genre = fakeGenres[index];
                return FilterChip(
                  backgroundColor: genre.color,
                  shape: StadiumBorder(side: BorderSide(color: genre.color),),
                  label: Text(
                    genre.name,
                    style: TextStyle(color: Colors.white),),
                  selectedColor: Colors.black,
                  selected: selectedLabels.contains(genre.name),
                  onSelected: (bool selected){

                    if (selected) {
                      selectedLabels.add(genre.name);
                      print(selectedLabels);
                      setState(() {

                      });
                    } else {
                      selectedLabels.remove(genre.name);
                      setState(() {

                      });
                    }
                  },
                );
              },
            ),
          ],
        ),);
  }

  Widget _buildNotificationsCards(){
    return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Card(
              child: ListTile(
              title: Text('Get Notifications from FlatLine Comics'),
              trailing: Checkbox(
                // Handle checkbox value and state here
                value: false,
                onChanged: (value) {
                  // Handle checkbox value change
                },
              ),
            ),),
            Card(
                child: ListTile(
              title: Text('Get Notifications on Books with my Interest'),
              trailing: Checkbox(
                // Handle checkbox value and state here
                value: false,
                onChanged: (value) {
                  // Handle checkbox value change
                },
              ),
            )),
            Card(
              child: ListTile(
              title: Text('Get Notifications on New Deals'),
              trailing: Checkbox(
                // Handle checkbox value and state here
                value: false,
                onChanged: (value) {
                  // Handle checkbox value change
                },
              ),
            ),),

          ],
        ),);

  }

  Widget _buildLogoutButton() {
    return Center(
      child: Container(
        width: MediaQuery.sizeOf(context).width * .5,
        child: ElevatedButton(
          onPressed: () async {
            if (needToLogin) {
              setState(() {
                needToLogin = !needToLogin;
                photo =
                'https://cdn.midjourney.com/4bedaeb8-115c-4e49-a061-d86274154095/0_0.png';

              });


              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => authenticationScreen()),
              );
            } else {
              await authentication.logout();
             // await databaseWrite.clearInteractions();
             // SharedPreferences sp = await SharedPreferences.getInstance();
             // sp.setBool("interactionsLoad", false);
              setState(() {
                needToLogin = !needToLogin;

                  });
                }},

          style: ElevatedButton.styleFrom(
            backgroundColor: needToLogin ? Color(0xFF8DABE5) : Colors.redAccent,
          ),
          child: Text(
            needToLogin ? 'Log In' : 'Log Out',
            style: TextStyle(color: Colors.white),
          ),
        ),),
      );
  }

}