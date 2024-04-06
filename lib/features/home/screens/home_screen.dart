import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_verse/features/home/bloc/home_bloc.dart';
import 'package:user_verse/features/home/screens/add_user.dart';
import 'package:user_verse/models/user_model.dart';

import '../../../core/globals.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  final _homeBloc = HomeBloc();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Nilambur',
            style: TextStyle(fontSize: width * 0.04, color: Colors.white),
          ),
          leading: const Icon(
            Icons.location_pin,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey.shade200,
        body: Padding(
          padding: EdgeInsets.only(
              left: width * 0.03, right: width * 0.03, top: width * 0.03),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: height * 0.06,
                      width: width * 0.8,
                      child: TextFormField(
                        controller: searchController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'search by name',
                          hintStyle: TextStyle(
                              fontSize: width * 0.035,
                              color: Colors.grey.shade600),
                          // hintText: 'Enter Phone Number *',
                          // hintStyle: TextStyle(fontSize: width*0.035,color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(height * 0.3),
                            borderSide: BorderSide(color: Colors.grey.shade100),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        sortingBox(context: context);
                      },
                      child: Container(
                        height: height * 0.05,
                        width: height * 0.05,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black),
                        child: Icon(
                          Icons.filter_list_sharp,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Text(
                  'Users List',
                  style: TextStyle(
                      fontSize: width * 0.04, color: Colors.grey.shade700),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: height,
                  child: StreamBuilder<List<UserModel>>(
                    stream: _homeBloc.usersStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final users = snapshot.data!;
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              UserModel user=users[index];
                              return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Container(
                                    height: height * 0.1,
                                    width: width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(6),
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(user.profile),
                                            radius: height * 0.05,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              user.name,
                                              style: TextStyle(
                                                  fontSize: width * 0.04,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              user.age.toString(),
                                              style: TextStyle(
                                                  fontSize: width * 0.035,
                                                  color: Colors.grey.shade600),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                            });
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: InkWell(
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const AddNewUser(),
                ));
          },
          child: CircleAvatar(
            radius: width * 0.085,
            backgroundColor: Colors.black,
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: width * 0.08,
            ),
          ),
        ),
      ),
    );
  }
  void sortingBox({required BuildContext context}) {
    int sortingValue = 0;
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(height * 0.04))),
        context: context,
        builder: (context) => Container(
              height: height * 0.3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: EdgeInsets.all(width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sort',
                      style: TextStyle(fontSize: width * 0.04),
                    ),
                    SizedBox(
                      height: height * 0.025,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: width * 0.05,
                          width: width * 0.05,
                          child: Radio(
                            value: 0,
                            groupValue: sortingValue,
                            onChanged: (value) {
                              setState(() {
                                sortingValue = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('All')
                      ],
                    ),
                    SizedBox(
                      height: height * 0.025,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: width * 0.05,
                          width: width * 0.05,
                          child: Radio(
                            value: 1,
                            groupValue: sortingValue,
                            onChanged: (value) {
                              setState(() {
                                sortingValue = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Age: Elder')
                      ],
                    ),
                    SizedBox(
                      height: height * 0.025,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: width * 0.05,
                          width: width * 0.05,
                          child: Radio(
                            value: 2,
                            groupValue: sortingValue,
                            onChanged: (value) {
                              setState(() {
                                sortingValue = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Age: Younger')
                      ],
                    ),
                  ],
                ),
              ),
            ));
  }
}
