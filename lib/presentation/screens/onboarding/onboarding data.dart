import 'package:flutter/material.dart';

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<Color> gradient;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.gradient,
  });
}








// import 'package:flutter/material.dart';
//
// class OnboardingData {
//   final String title;
//   final String description;
//   final IconData icon;
//   final Color color;
//   final List<Color>  gradient;
//
//   OnboardingData({
//     required this.title,
//     required this.description,
//     required this.icon,
//     required this.color,
//     required this.gradient,
//   });
// }
//
// class OnboardingPage extends StatelessWidget {
//   final OnboardingData data;
//
//   const OnboardingPage({required this.data});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(40),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           TweenAnimationBuilder(
//
//             tween: Tween<double>(begin: 0, end: 1),
//             duration: Duration(milliseconds: 800),
//             curve: Curves.elasticOut,
//             builder: (context, double value, child) {
//               return Transform.scale(
//
//                 scale: value,
//                 child: Container(
//                   width: 200,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     data.icon,
//                     size: 100,
//                     color: Colors.white,
//                   ),
//                 ),
//               );
//             },
//           ),
//           SizedBox(height: 60),
//           FadeTransition(
//             opacity: CurvedAnimation(
//               parent: AlwaysStoppedAnimation(1.0),
//               curve: Curves.easeIn,
//             ),
//             child: Text(
//               data.title,
//               style: TextStyle(
//                 fontSize: 32,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           SizedBox(height: 20),
//           Text(
//             data.description,
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.white.withOpacity(0.9),
//               height: 1.5,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class AnimatedPageIndicator extends StatelessWidget {
//   final bool isActive;
//   final Color color;
//
//   const AnimatedPageIndicator({
//     required this.isActive,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 300),
//       margin: EdgeInsets.symmetric(horizontal: 4),
//       height: 8,
//       width: isActive ? 24 : 8,
//       decoration: BoxDecoration(
//         color: isActive ? color : color.withOpacity(0.4),
//         borderRadius: BorderRadius.circular(4),
//       ),
//     );
//   }
// }
//
// class AnimatedButton extends StatefulWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final bool isPrimary;
//
//   const AnimatedButton({
//     required this.text,
//     required this.onPressed,
//     required this.isPrimary,
//   });
//
//   @override
//   _AnimatedButtonState createState() => _AnimatedButtonState();
// }
//
// class _AnimatedButtonState extends State<AnimatedButton> {
//   bool _isPressed = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (_) => setState(() => _isPressed = true),
//       onTapUp: (_) {
//         setState(() => _isPressed = false);
//         widget.onPressed();
//       },
//       onTapCancel: () => setState(() => _isPressed = false),
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 150),
//         padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//         decoration: BoxDecoration(
//           color: widget.isPrimary
//               ? Colors.white
//               : Colors.white.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: _isPressed
//               ? []
//               : [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 10,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
//         child: Text(
//           widget.text,
//           style: TextStyle(
//             color: widget.isPrimary ? Color(0xFF6C63FF) : Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
// }