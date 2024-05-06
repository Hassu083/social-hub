import 'package:socialhub/app_state.dart';
import 'package:socialhub/color.dart';
import 'package:socialhub/screens/home/home_widget/profile_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }
}

class Menu extends StatefulWidget {
    List<Function()>? functions;
   Menu({Key? key, this.functions}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<String> options = ["Home","Profile","Notifications","Follow Request","Save posts","Logout","Reviews"];
  var icons = const [Icons.home,Icons.person,Icons.notifications_active,Icons.hail,Icons.save ,Icons.logout,Icons.reviews];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children:  [
        Container(
          decoration:  BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(45))
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 8),
          child:  ListTile(
            leading: ProfileImage(user: MyInheritedWidget.of(context)!.loggedInUser!),
            title:  Text(MyInheritedWidget.of(context)!.loggedInUser!.userName!),
            subtitle: Text(MyInheritedWidget.of(context)!.loggedInUser!.userBio!,overflow: TextOverflow.ellipsis,),
          ),
        ),
        const SizedBox(height: constantPadding,),
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.zero,
            decoration:  BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(25))
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              child: ListView.separated(
                  itemBuilder: (context, index){
                    return Container(
                      color: _index==index? context.isDarkMode? logoColor.withOpacity(0.5) : const Color(0xFFFFF9EA): Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal:constantPadding*0.5,vertical:constantPadding*0.4 ),
                      child:  ListTile(
                        leading: Icon(icons[index],color: _index==index? logoColor : Theme.of(context).textTheme.headline5!.color,),
                        title: Text(options[index],style: _index==index? Theme.of(context).textTheme.headline5!.copyWith(color: logoColor) : Theme.of(context).textTheme.headline5 ,),
                        onTap: (){
                          setState(() {
                            _index = index;
                          });
                          widget.functions![index]();
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context,index){
                    return  const SizedBox(height: constantPadding*0.5,);
                  },
                  itemCount: options.length
              ),
            ),
          ),
        ),
        Expanded(child: Container())
      ],
    );
  }
}
