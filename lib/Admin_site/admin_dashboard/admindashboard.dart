import 'dart:convert';
import 'dart:io';
import 'package:socialhub/Admin_site/admin_common_widgets/header.dart';
import 'package:socialhub/app_state.dart';
import 'package:socialhub/common_widgets/admin_input.dart';
import 'package:socialhub/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common_widgets/responsive.dart';
import '../../models/user/user.dart';
import '../../toast/toast.php.dart';
import '../admin_common_widgets/chart.dart';
import 'package:http/http.dart' as http;

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  TextEditingController controller =
      TextEditingController(text: 'SELECT * FROM USERS');
  ScrollController scrollController = ScrollController();
  ScrollController scrollController1 = ScrollController();
  List<String> columnName = [];
  List<Map<String, dynamic>> analyticReport = [];
  List<Map<String, dynamic>> rows = [];
  bool loading = false;
  bool analysis = false;
  bool problem = false;
  var colors = [
    Colors.green,
    Colors.amber,
    Colors.yellow,
    Colors.blue,
    Colors.purple,
    Colors.purpleAccent,
    Colors.pink,
    Colors.red,
    Colors.deepOrange
  ];
  var icons = [
    Icons.person,
    Icons.post_add_sharp,
    Icons.share,
    Icons.emoji_emotions,
    Icons.comment,
    Icons.charging_station,
    Icons.notifications,
    Icons.report,
    Icons.reviews
  ];

  runQuery() async {
    setState(() {
      loading = true;
      problem = false;
      columnName = [];
      rows = [];
    });
    try {
      var response = await http.post(
          Uri.parse("${MyInheritedWidget.of(context)!.url}admin.php"),
          body: {"query": controller.text});
      List<dynamic> queryResult = jsonDecode(response.body);
      if (queryResult.isNotEmpty) {
        for (Map<String, dynamic> object in queryResult) {
          rows.add(object);
        }
        Map<String, dynamic> obj1 = queryResult[0];
        columnName = obj1.entries.map((e) => e.key).toList();
      }
    } catch (e) {
      print(e);
      setState(() {
        problem = true;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  getAnalysis() async {
    setState(() {
      analysis = false;
    });
    try {
      var response = await http.post(
        Uri.parse("${MyInheritedWidget.of(context)!.url}dataForAdmin.php"),
      );
      List<dynamic> queryResult = jsonDecode(response.body);
      setState(() {
        analyticReport = List<Map<String, dynamic>>.from(queryResult);
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        analysis = true;
      });
    }
  }

  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      runQuery();
      getAnalysis();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212332),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 2,
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Header(),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 6,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SearchField(
                                            controller: controller,
                                            runQuery: runQuery,
                                          ),
                                          const SizedBox(
                                            height: constantPadding,
                                          ),
                                          Container(
                                              padding: const EdgeInsets.all(
                                                  constantPadding),
                                              width: double.infinity,
                                              height: 590,
                                              decoration: const BoxDecoration(
                                                  color: Color(0xFF2A2D3E),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: !problem && loading
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )
                                                  : !problem && !loading
                                                      ? Scrollbar(
                                                          isAlwaysShown: true,
                                                          controller:
                                                              scrollController,
                                                          child:
                                                              SingleChildScrollView(
                                                                  scrollDirection:
                                                                      Axis
                                                                          .horizontal,
                                                                  controller:
                                                                      scrollController,
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    controller:
                                                                        scrollController1,
                                                                    child:
                                                                        DataTable(
                                                                      columns: columnName
                                                                          .map((e) => DataColumn(
                                                                                  label: Text(
                                                                                e,
                                                                                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                                                              )))
                                                                          .toList(),
                                                                      rows: List.generate(
                                                                          rows.length,
                                                                          (index) {
                                                                        return DataRow(
                                                                            cells:
                                                                                List.generate(columnName.length, (index1) {
                                                                          return DataCell(
                                                                              Text(
                                                                            rows[index][columnName[index1]].toString(),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                GoogleFonts.poppins(color: Colors.white54, fontSize: 10),
                                                                          ));
                                                                        }));
                                                                      }),
                                                                    ),
                                                                  )),
                                                        )
                                                      : const Center(
                                                          child: Text(
                                                              "Some problem in executing Query"),
                                                        ))
                                        ]),
                                  )),
                              if (!Responsive.isMobile(context))
                                const SizedBox(
                                  width: 16,
                                ),
                              if (!Responsive.isMobile(context))
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: const BoxDecoration(
                                          color: Color(0xFF2A2D3E),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      height: 670,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                              onTap: () async {
                                                User user = User(
                                                    userId: 'admin',
                                                    userBio:
                                                        'Decode Developers',
                                                    userCoverPhotoLinkName:
                                                        'admin_cover.png',
                                                    userEmail: 'Admin',
                                                    userName: 'Admin',
                                                    userPassword: '123',
                                                    userPhone: '123',
                                                    userProfileImageLinkName:
                                                        'admin_profile.jpg',
                                                    userUsername: 'Admin',
                                                    profileImage: base64Encode(
                                                        File('C:/xampp/againxamp/htdocs/dashboard/socialHub/images/admin_profile.png')
                                                            .readAsBytesSync()),
                                                    coverImage: base64Encode(
                                                        File('C:/xampp/againxamp/htdocs/dashboard/socialHub/images/admin_cover.jpg')
                                                            .readAsBytesSync()),
                                                    savePosts: []);
                                                try {
                                                  var response = await http.get(
                                                    Uri.parse(
                                                        "${MyInheritedWidget.of(context)!.url}adminExtra.php"),
                                                  );
                                                  print(response.body);
                                                  user.following =
                                                      List<String>.from(
                                                          jsonDecode(
                                                              response.body));
                                                } catch (e) {
                                                  print(e);
                                                  HubToast.shToast(context,
                                                      "Some problem", 100);
                                                }
                                                if (user.following
                                                        ?.isNotEmpty ??
                                                    false) {
                                                  MyInheritedWidget.of(context)!
                                                      .userLogin(user);
                                                  Navigator.pushNamed(
                                                      context, '/home');
                                                }
                                              },
                                              child: const Text(
                                                "User Details",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              )),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Chart(
                                            onClick: () {},
                                          ),
                                          Expanded(
                                            child: analysis
                                                ? ListWheelScrollView(
                                                    itemExtent: 60,
                                                    children:
                                                        analyticReport.map((e) {
                                                      int index = analyticReport
                                                          .indexOf(e);
                                                      String key =
                                                          e.keys.toList()[0];
                                                      String value = e.values
                                                          .toList()[0]
                                                          .toString();
                                                      return Container(
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            vertical: 4),
                                                        child: ListTile(
                                                          leading: Container(
                                                            height: 50,
                                                            width: 50,
                                                            decoration: BoxDecoration(
                                                                color: colors[
                                                                        index]
                                                                    .withOpacity(
                                                                        0.5),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            500))),
                                                            child: Center(
                                                              child: Icon(
                                                                icons[index],
                                                                color: colors[
                                                                    index],
                                                              ),
                                                            ),
                                                          ),
                                                          title: Text(
                                                            key,
                                                            style: const TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          subtitle: Text(
                                                            value,
                                                            style: const TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white54),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  )
                                                : const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                          )
                                        ],
                                      ),
                                    ))
                            ]),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
