class UserModel {
  final String uid;
  final String name;
  final String profile;
  final String phone;
  final int age;
  final List<String> searchKeys;
  UserModel({
    required this.uid,
    required this.name,
    required this.profile,
    required this.phone,
    required this.age,
    required this.searchKeys,
  });
  UserModel copyWit({
    String? uid,
    String? name,
    String? profile,
    String? phone,
    int? age,
    List<String>? searchKeys,
  }) =>
      UserModel(
        uid: uid??this.uid,
          name: name ?? this.name,
          phone: phone ?? this.phone,
          age: age ?? this.age,
          searchKeys: searchKeys ?? this.searchKeys,
          profile: profile ?? this.profile);

  Map<String, dynamic> toMap() => {
    'uid':uid,
        'name': name,
        'profile': profile,
        'phone': phone,
        'age': age,
        'searchKeys': searchKeys,
      };
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
        name: map['name'],
        profile: map['profile'],
        phone: map['phone'],
        age: map['age'],
        searchKeys: List<String>.from(map['searchKeys']));
  }
}
