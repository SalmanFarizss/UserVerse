
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user_verse/core/theme/palette.dart';
import 'package:user_verse/core/utils.dart';
import 'package:user_verse/features/home/bloc/filter_cubit.dart';
import 'package:user_verse/features/home/bloc/home_bloc.dart';
import 'package:user_verse/features/home/bloc/home_state.dart';
import 'package:user_verse/features/home/bloc/users_cubit.dart';
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
  final usersCubit = UsersCubit();
  final _filterCubit = FilterCubit();
  String currentLocation = '';
  DocumentSnapshot? lastDoc;
  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.blackColor,
          title: Text(
              currentLocation==""?"Location":currentLocation,
            style: TextStyle(fontSize: width * 0.04, color: Palette.whiteColor),
          ),
          leading: const Icon(
            Icons.location_pin,
            color: Palette.whiteColor,
          ),
        ),
        backgroundColor: Palette.greyColor.shade200,
        body: BlocBuilder<FilterCubit, int>(
          bloc: _filterCubit,
          builder: (context, radioValue) {
            usersCubit.clearState();
            context
                .read<HomeBloc>()
                .add(GetInitialUsers(search: '', radioValue: radioValue));
            return Padding(
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
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              hintText: 'search by name',
                              hintStyle: TextStyle(
                                  fontSize: width * 0.035,
                                  color: Palette.greyColor.shade600),
                              // hintText: 'Enter Phone Number *',
                              // hintStyle: TextStyle(fontSize: width*0.035,color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(height * 0.3),
                                borderSide:
                                    BorderSide(color: Palette.greyColor.shade100),
                              ),
                            ),
                            onChanged: (value) {
                              usersCubit.clearState();
                              context.read<HomeBloc>().add(GetInitialUsers(
                                  search: searchController.text.trim().toUpperCase(),
                                  radioValue: radioValue));
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            srtBottomSheet(
                                context: context, sortingValue: radioValue);
                          },
                          child: Container(
                            height: height * 0.05,
                            width: height * 0.05,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Palette.blackColor),
                            child: const Icon(
                              Icons.filter_list_sharp,
                              color: Palette.whiteColor,
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
                          fontSize: width * 0.04, color: Palette.greyColor.shade700),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    BlocConsumer<HomeBloc, HomeState>(
                        listener: (context, state) {
                      if (state is HomeFailure) {
                        failureSnackBar(context, state.error);
                      }
                      if (state is FetchingCompleted) {
                        usersCubit.newUserBatch(state.users);
                        lastDoc = state.lastDoc;
                      }
                    }, builder: (context, state) {
                      if (state is HomeLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return SizedBox(
                          child: BlocBuilder<UsersCubit, List<UserModel>>(
                              bloc: usersCubit,
                              builder: (context, users) {
                                return users.isEmpty
                                    ? const Center(
                                        child: Text('No Users found'),
                                      )
                                    : SizedBox(
                                        height: height * 0.76,
                                        child: LazyLoadScrollView(
                                          onEndOfPage: () {
                                            if ((users.length % limit)==0&&lastDoc!=null) {
                                              context.read<HomeBloc>().add(
                                                  GetMoreUsers(
                                                      search: searchController
                                                          .text
                                                          .trim()
                                                          .toUpperCase(),
                                                      radioValue: radioValue,
                                                      lastDoc: lastDoc!));
                                            }
                                          },
                                          child: Scrollbar(
                                            child: ListView.builder(
                                                // shrinkWrap: true,
                                                itemCount: users.length,
                                                itemBuilder: (context, index) {
                                                  UserModel user = users[index];
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: Container(
                                                      height: height * 0.1,
                                                      width: width,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Palette.greyColor
                                                                .withOpacity(
                                                                    0.5),
                                                            offset:
                                                                const Offset(
                                                                    0, 2),
                                                          ),
                                                        ],
                                                        color: Palette.whiteColor,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(6),
                                                            child:CachedNetworkImage(
                                                              imageUrl: user.profile,
                                                              imageBuilder: (context, imageProvider) => Container(
                                                                width: height*0.1,
                                                                height: height*0.1,
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  image: DecorationImage(
                                                                      image: imageProvider, fit: BoxFit.cover),
                                                                ),
                                                              ),
                                                              placeholder: (context, url) => CircleAvatar(radius: height*0.05,backgroundColor: Palette.greyColor,),
                                                              errorWidget: (context, url, error) => SizedBox(
                                                                height: height*0.1,
                                                                  width: height*0.1,
                                                                  child: const Icon(Icons.error,color: Palette.greyColor,)),
                                                            ),
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                user.name,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        width *
                                                                            0.04,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                               'Age: ${user.age}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        width *
                                                                            0.035,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade600),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),
                                      );
                              }));
                    })
                  ],
                ),
              ),
            );
          },
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
            backgroundColor: Palette.blackColor,
            child: Icon(
              Icons.add,
              color:Palette.whiteColor,
              size: width * 0.08,
            ),
          ),
        ),
      ),
    );
  }

  void srtBottomSheet(
      {required BuildContext context, required int sortingValue}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(height * 0.04))),
        context: context,
        builder: (context) => Container(
              height: height * 0.35,
              decoration: const BoxDecoration(
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
                    RadioListTile(
                        value: 0,
                        groupValue: sortingValue,
                        onChanged: (value) {
                          Navigator.pop(context);
                          _filterCubit.doSort(value!);
                        },
                        title: const Text('All')),
                    RadioListTile(
                        value: 1,
                        groupValue: sortingValue,
                        onChanged: (value) {
                          Navigator.pop(context);
                          _filterCubit.doSort(value!);
                        },
                        title: const Text('Age: Elder')),
                    RadioListTile(
                        value: 2,
                        groupValue: sortingValue,
                        onChanged: (value) {
                          Navigator.pop(context);
                          _filterCubit.doSort(value!);
                        },
                        title: const Text('Age: Younger')),
                  ],
                ),
              ),
            ));
  }
  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }
      PermissionStatus permission = await Permission.location.status;
      if (permission == PermissionStatus.denied) {
        permission = await Permission.location.request();
        if (permission != PermissionStatus.granted) {
          return;
        }
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      Placemark placemark = placemarks[0];
      setState(() {
        currentLocation = placemark.locality!;
      });
    } catch (e) {
      print('Loacation error:${e.toString()}');
    }
  }
@override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
