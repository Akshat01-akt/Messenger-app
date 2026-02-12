import 'package:chat_app/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'onboarding data.dart';
// import 'onboarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _bubbleController;


  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Welcome to ChatApp',
      description:
          'Connect with friends and family through instant messaging and calls',
      icon: Icons.chat_bubble_outline,
      color: Color(0xFF6C63FF),
      gradient: [Color(0xFF667eea), Color(0xFF764ba2)],
    ),
    OnboardingData(
      title: 'Stay Connected',
      description:
          'Share moments, photos, and videos with the people who matter most',
      icon: Icons.people_outline,
      color: Color(0xFF00D4AA),
      gradient: [Color(0xFF11998e), Color(0xFF38ef7d)],
    ),
    OnboardingData(
      title: 'Secure & Private',
      description:
          'Your conversations are end-to-end encrypted and completely private',
      icon: Icons.lock_outline,
      color: Color(0xFF4158D0),
      gradient: [Color(0xFF4158D0), Color(0xFFC850C0)],
    ),
    OnboardingData(
      title: 'Start Chatting',
      description:
          'Join millions of users and experience seamless communication',
      icon: Icons.send_outlined,
      color: Color(0xFFFF6584),
      gradient: [Color(0xFFf093fb), Color(0xFFf5576c)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    )..forward();

    _bubbleController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _fadeController.reset();
    _fadeController.forward();
    _slideController.reset();
    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background with floating bubbles effect
          AnimatedContainer(
            duration: Duration(milliseconds: 600),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _pages[_currentPage].gradient,
              ),
            ),
          ),

          ...List.generate(5, (index) {
            return AnimatedBuilder(
              animation: _bubbleController,
              builder: (context, child) {
                return Positioned(
                  top: 100 + (index * 120) + (_bubbleController.value * 30),
                  left: index.isEven ? 20 : null,
                  right: index.isOdd ? 20 : null,
                  child: Opacity(
                    opacity: 0.1 + (_bubbleController.value * 0.1),
                    child: Icon(
                      Icons.chat_bubble,
                      size: 60 + (index * 10),
                      color: Colors.white,
                    ),
                  ),
                );
              },
            );
          }),

          // PageView with slide animation
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
                  }

                  return Transform.translate(
                    offset: Offset(0, (1 - value) * 50),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: OnboardingPage(data: _pages[index]),
              );
            },
          ),

          // Custom Page Indicator with message bubble style
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedPageIndicator(
                  isActive: index == _currentPage,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Action Buttons with slide animation
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: SlideTransition(
              position: Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
                  .animate(
                    CurvedAnimation(
                      parent: _slideController,
                      curve: Curves.easeOut,
                    ),
                  ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    AnimatedButton(
                      text: 'Back',
                      onPressed: () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      isPrimary: false,
                    )
                  else
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomeScreen()),
                        );
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  AnimatedButton(
                    text: _currentPage == _pages.length - 1
                        ? 'Start Chatting'
                        : 'Next',
                    onPressed: () {
                      if (_currentPage == _pages.length - 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomeScreen()),
                        );
                      } else {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    isPrimary: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Onboarding Page Widget
class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Icon with message bubble style
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Icon(data.icon, size: 60, color: Colors.white),
          ),
          SizedBox(height: 60),

          // Title
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 20),

          // Description
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// Animated Page Indicator
class AnimatedPageIndicator extends StatelessWidget {
  final bool isActive;
  final Color color;

  const AnimatedPageIndicator({
    super.key,
    required this.isActive,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? color : color.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// Animated Button
class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const AnimatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: widget.isPrimary ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: widget.isPrimary
                ? null
                : Border.all(color: Colors.white, width: 2),
            boxShadow: widget.isPrimary
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.isPrimary ? Color(0xFF6C63FF) : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
