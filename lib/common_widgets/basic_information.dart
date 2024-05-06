import 'package:socialhub/common_widgets/button.dart';
import 'package:socialhub/common_widgets/responsive.dart';
import 'package:flutter/material.dart';

import 'input_field.dart';

class BasicInfo extends StatelessWidget {
  TextEditingController confirmPassword,name,userName,email,password,number;
  Function() function;

  BasicInfo({Key? key,
  required this.confirmPassword,
  required this.name,
  required this.userName,
  required this.email,
  required this.password,
  required this.number,
  required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Builder(
        builder: (context) {
          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            direction: Axis.vertical,
            spacing: 20,
            children: [
              InputField(
                isPassword: false,
                hintText: "Name",
                prefixIcon:  Icon(Icons.person_pin,color: Theme.of(context).colorScheme.primary,),
                controller: name,
                validator: (value1){
                  String value = value1 ?? "";
                    if( value == '' || value.isEmpty ){
                      return "Name field must not be empty";
                    }else if(!value.contains(" ")){
                      return "Name field must contains first and last name with address";
                    }else{
                      return null;
                    }
                },
              ),
              InputField(
                isPassword: false,
                hintText: "Username",
                prefixIcon:  Icon(Icons.person,color: Theme.of(context).colorScheme.primary,),
                controller: userName,
                validator: (value1){
                  String value = value1 ?? "";
                  if( value == '' || value.isEmpty ){
                    return "Username field must not be empty";
                  }else if(value.contains(" ")){
                    return "Username field must not contain space";
                  }else{
                    return null;
                  }
                },
              ),
              InputField(
                isPassword: false,
                hintText: "Email",
                prefixIcon:  Icon(Icons.person,color: Theme.of(context).colorScheme.primary,),
                controller: email,
                validator: (value1){
                  String value = value1 ?? "";
                  if( value == '' || value.isEmpty ){
                    return "Email field must not be empty";
                  }else if(!value.contains("@") || !value.contains(".com")){
                    return "Email field must contains @ and .com";
                  }else{
                    return null;
                  }
                },
              ),
              InputField(
                isPassword: true,
                hintText: "Password",
                prefixIcon:  Icon(Icons.lock,color: Theme.of(context).colorScheme.primary,),
                controller: password,
                validator: (value1){
                  String value = value1 ?? "";
                  if( value == '' || value.isEmpty ){
                    return "Password field must not be empty";
                  }else if(value.length < 10){
                    return "Password must be greater than 10 length";
                  }else{
                    return null;
                  }
                },
              ),
              InputField(
                isPassword: true,
                hintText: "Confirm Password",
                prefixIcon:  Icon(Icons.lock,color: Theme.of(context).colorScheme.primary,),
                controller: confirmPassword,
                validator: (value1){
                  String value = value1 ?? "";
                  if( value == '' || value.isEmpty ){
                    return "Confirm password field must not be empty";
                  }else if(value != password.text){
                    return "Must be equal to password";
                  }else{
                    return null;
                  }
                },
              ),
              InputField(
                isPassword: false,
                hintText: "PhoneNumber",
                prefixIcon:  Icon(Icons.person,color: Theme.of(context).colorScheme.primary,),
                controller: number,
                validator: (value1){
                  String value = value1 ?? "";
                  if( value == '' || value.isEmpty ){
                    return "Number field must not be empty";
                  }else if(!value.contains("-")){
                    return "Name field must contains ( - )";
                  }else{
                    return null;
                  }
                },
              ),
              Wrap(
                spacing: 25,
                direction: Axis.horizontal,
                children: [
                  SocialHubButton(
                    onTap: (){
                    }
                    , text: "Previous",
                    width:Responsive.isMobile(context)?150:190,
                    height: 35,),
                  SocialHubButton(
                    onTap: (){
                      if(Form.of(context)?.validate() ?? false){
                          function();
                      }
                    }
                    , text: "Next",
                    width:Responsive.isMobile(context)?150:190,
                    height: 35,),
                ],
              ),
            ],
          );
        }
      ),
    );
  }
}
