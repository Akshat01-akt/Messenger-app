import 'package:chat_app/presentation/screens/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/auth_repositories.dart';
import '../../../presentation/screens/auth/login_screen.dart';
import '../../../presentation/screens/home/home_screen.dart';
import '../../../presentation/screens/splash_screen.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();
    if (!authService.currentUser!.emailVerified) {
      return RouteSettings(name: Routes.LOGIN);
    }
    return null;
  }
}

//routes

class Routes {
  static const SPLASH = '/';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const HOME = '/home';
  static const PROFILE = '/profile';
}

class AppPages {
  static final pages = [
    GetPage(name: Routes.SPLASH, page: () => SplashScreen()),
    GetPage(name: Routes.LOGIN, page: () => LoginScreen()),
    GetPage(name: Routes.REGISTER, page: () => SignUpScreen()),
    GetPage(name: Routes.HOME, page: () => HomeScreen()),
    // GetPage(name: Routes.PROFILE, page: ()=>ProfileScreen(),binding: ProfileBinding(),middlewares: [AuthMiddleware()]),
  ];
}
//bindings

// class AuthBinding extends Bindings{
//   @override
//   void dependencies() {
//     // TODO: implement dependencies
//     Get.lazyPut(()=>LoginController());
//     Get.lazyPut(()=>RegisterController());
//   }
// }
//
// class HomeBinding extends Bindings{
//   @override
//   void dependencies() {
//     // TODO: implement dependencies
//     Get.lazyPut(()=>HomeController());
//   }
// }
//
//
// class ProfileBinding extends Bindings{
//   @override
//   void dependencies() {
//     // TODO: implement dependencies
//     Get.lazyPut(()=>ProfileController());
//   }
// }
