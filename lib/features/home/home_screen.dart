import 'package:flutter/material.dart';

import '../../core/globals.dart';

class HomeScreen extends StatefulWidget {
  const   HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
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
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 15,
                      itemBuilder: (context, index) => Padding(
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(6),
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets/images/login_image.png'),
                                      radius: height * 0.05,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'User Name',
                                        style: TextStyle(
                                            fontSize: width * 0.04,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Age: 35',
                                        style: TextStyle(
                                            fontSize: width * 0.035,
                                            color: Colors.grey.shade600),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: InkWell(
          onTap: () {
            addNewUser(context: context);
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

  Future<void> addNewUser({required BuildContext context}) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(width*0.05)),
        title: Text('Add A New User'),
        content: SizedBox(
          height: height * 0.3,
          width: width ,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.1,
                width: width,
                child: Image.asset('assets/images/default_avatar.png'),
              ),
              Text('Name'),
              SizedBox(
                height: height * 0.06,
                child: TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Name',
                      hintStyle: TextStyle(
                          fontSize: width * 0.035, color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade100))),
                ),
              ),
              Text('Age'),
              SizedBox(
                height: height * 0.06,
                child: TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Age',
                      hintStyle: TextStyle(
                          fontSize: width * 0.035, color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade100))),
                ),
              ),
            ],
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade200),
              height: height * 0.04,
              width: width * 0.25,
              child: Center(
                child: Text('Cancel'),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueAccent),
              height: height * 0.04,
              width: width * 0.25,
              child: Center(
                child: Text('Save'),
              ),
            ),
          )
        ],
      ),
    );
  }

  void sortingBox({required BuildContext context}) {
    int sortingValue = 0;
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top: Radius.circular(height*0.04)) ),
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
