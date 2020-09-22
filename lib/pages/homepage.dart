import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_halloween/components/spooky_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../components/sliding_panel.dart';

List<SpookyCard> data = [];
final GlobalKey<AnimatedListState> animatedListKey = GlobalKey();
Faker faker = const Faker();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController _bgColorController;

  Matrix4 moonTransform = Matrix4.translation(vector.Vector3(0, 0, 0));
  Matrix4 sunTransform = Matrix4.translation(vector.Vector3(450, 45, 420));
  double moonRotation = 0;
  bool moonHidden = false;
  bool sunHidden = true;
  void changeTime() {
    if (sunHidden) {
      moonTransform = Matrix4.translation(vector.Vector3(450, 45, 420));
      sunTransform = Matrix4.translation(vector.Vector3(0, 0, 0));
      _bgColorController.animateTo(1);
      moonHidden = true;
      sunHidden = false;
    } else {
      sunTransform = Matrix4.translation(vector.Vector3(450, 45, 420));
      moonTransform = Matrix4.translation(vector.Vector3(0, 0, 0));
      _bgColorController.animateTo(0);
      moonHidden = false;
      sunHidden = true;
    }

    setState(() {});
  }

  Logger logger = Logger();

  Widget buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ScaleTransition(
        scale: animation,
        child: SlidingPanel(
          index: index,
          subtitleText: data[index].subtitle,
          trailingText: data[index].trailingText,
          titleText: data[index].title,
          titleColor: textColorSwitches.evaluate(
            AlwaysStoppedAnimation(_bgColorController.value),
          ),
          subtitleColor: textColorSwitches.evaluate(
            AlwaysStoppedAnimation(_bgColorController.value),
          ),
          trailingColor: textColorSwitches.evaluate(
            AlwaysStoppedAnimation(_bgColorController.value),
          ),
          shadowColor: shadowColorSwithces.evaluate(
            AlwaysStoppedAnimation(_bgColorController.value),
          ),
          firstGradient: moonHidden
              ? bgColorSwitches
                  .evaluate(
                    AlwaysStoppedAnimation(_bgColorController.value),
                  )
                  .withAlpha(120)
              : bgColorSwitches.evaluate(
                  AlwaysStoppedAnimation(_bgColorController.value),
                ),
          secondGradient: moonHidden
              ? bgColorSwitches.evaluate(
                  AlwaysStoppedAnimation(_bgColorController.value),
                )
              : slidingPanelSwitches.evaluate(
                  AlwaysStoppedAnimation(_bgColorController.value),
                ),
          onTap: () {
            logger.i('Tapped $index');
            data.removeAt(index);
            // ignore: omit_local_variable_types
            AnimatedListRemovedItemBuilder builder = (context, animation) {
              if (data.isEmpty && index == 0) {
                return null;
              } else if (index == 0) {
                return buildItem(context, index, animation);
              }
              return buildItem(context, index - 1, animation);
            };

            animatedListKey.currentState.removeItem(index, builder);
          },
        ),
      ),
    );
  }

  void _addAnItem() {
    data.insert(
      0,
      SpookyCard(
        subtitle: faker.lorem.sentence(),
        title:
            '${faker.person.prefix()} ${faker.person.lastName()} the ${faker.person.suffix()}',
        trailingText: faker.date.time(),
      ),
    ); //
    animatedListKey.currentState.insertItem(0); //
  }

  Animatable<Color> slidingPanelSwitches = TweenSequence<Color>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.red,
        end: Colors.black,
      ),
    ),
  ]);

  Animatable<Color> shadowColorSwithces = TweenSequence<Color>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.red.withOpacity(0.7),
        end: Colors.black.withOpacity(0.7),
      ),
    ),
  ]);

  Animatable<Color> textColorSwitches = TweenSequence<Color>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: const Color(0xffC3D4FF),
        end: const Color(0xFF092532),
      ),
    ),
  ]);

  Animatable<Color> bgColorSwitches = TweenSequence<Color>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: const Color(0xFF092532),
        end: const Color(0xFFe5df88),
      ),
    ),
  ]);

  @override
  void dispose() {
    _bgColorController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _bgColorController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: _bgColorController,
        builder: (context, child) => Scaffold(
          backgroundColor: bgColorSwitches.evaluate(
            AlwaysStoppedAnimation(_bgColorController.value),
          ),
          body: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Image(
                  image: Image.asset('./assets/images/stars.png').image,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  transform: moonTransform,
                  child: Image(
                    image: const AssetImage('./assets/images/moon.png'),
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeIn,
                  transform: sunTransform,
                  child: Image(
                    image: const AssetImage('./assets/images/sun.png'),
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Image(
                  image: const AssetImage('./assets/images/spooky-tree.png'),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Image(
                  image: const AssetImage('./assets/images/gravestone3.png'),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Image(
                  image: const AssetImage('./assets/images/ground.png'),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Image(
                  image: Image.asset('./assets/images/webs.png').image,
                  fit: BoxFit.fitHeight,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 14.0,
                  left: 14.0,
                  bottom: 70,
                  top: 255,
                ),
                child: AnimatedList(
                  key: animatedListKey,
                  initialItemCount: data.length,
                  itemBuilder: buildItem,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: FlatButton(
                  onPressed: () {
                    changeTime();
                  },
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.black,
                          offset: Offset(
                            0,
                            5,
                          ),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Text(
                      'Time Travel',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.amaticSc(
                        fontSize: 35,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () {
                    _addAnItem();
                  },
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.black,
                          offset: Offset(
                            0,
                            5,
                          ),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Text(
                      'Add Tiles',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.amaticSc(
                        fontSize: 35,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
