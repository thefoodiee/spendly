import 'package:flutter/material.dart';
import 'package:spendly/services/wrapper.dart';
import 'package:spendly/pages/register_account.dart';
import 'package:spendly/pages/home_page.dart';
import 'package:spendly/pages/sms_permission.dart';
import 'package:spendly/pages/set_budget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spendly/pages/edit_budget.dart';
import 'firebase_options.dart';

Future<void> main() async{
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
    );
    
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            initialRoute: '/',
            onGenerateRoute: (settings) {
                switch (settings.name) {
                    case '/':
                        return _buildPageRoute(Wrapper(), settings, isLeftToRight: true);
                    case '/createAccount':
                        return _buildPageRoute(RegisterAccount(), settings, isLeftToRight: false);
                    case '/home':
                        return _buildPageRoute(HomePage(), settings, isLeftToRight: false);
                    case '/smsPermission':
                        return _buildPageRoute(SmsPermission(), settings, isLeftToRight: false);
                    case '/setBudget':
                        return _buildPageRoute(SetBudget(), settings, isLeftToRight: false);
                    case '/editBudget':
                        return _buildPageRoute(EditBudget(), settings, isLeftToRight: false);
                        
                    default:
                        return null;
                }
            },
            debugShowCheckedModeBanner: false,
        );
    }

    PageRouteBuilder _buildPageRoute(Widget page, RouteSettings settings, {required bool isLeftToRight}) {
        return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                // Slide Transition for the incoming page
                final slideBegin = isLeftToRight ? Offset(-1.0, 0.0) : Offset(1.0, 0.0);
                const slideEnd = Offset.zero;
                const slideCurve = Curves.easeInOut;
                var slideTween = Tween(begin: slideBegin, end: slideEnd).chain(CurveTween(curve: slideCurve));
                var slideAnimation = animation.drive(slideTween);

                // Fade Transition for dimming the background
                const fadeBegin = 0.0;
                const fadeEnd = 0.5; // Adjust to control dimness intensity
                var fadeTween = Tween(begin: fadeBegin, end: fadeEnd);
                var fadeAnimation = animation.drive(fadeTween);

                return Stack(
                    children: [
                        // Dimmed background
                        FadeTransition(
                            opacity: fadeAnimation,
                            child: Container(color: Colors.black),
                        ),
                        // Sliding page
                        SlideTransition(
                            position: slideAnimation,
                            child: child,
                        ),
                    ],
                );
            },
        );
    }
}
