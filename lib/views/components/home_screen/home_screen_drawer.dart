import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Drawer(
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Container(
                height: size.height * 0.25,
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.teal),
                child: const Center(child: FlutterLogo(size: 42.0)),
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                decoration: const BoxDecoration(),
                child: Row(
                  children: [
                    const Icon(MdiIcons.themeLightDark, size: 16.0),
                    SizedBox(width: size.width * 0.06),
                    const Text('Dark Mode', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
                    const Spacer(),
                    Switch(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const LanguageScreen(),
                    //   ),
                    // );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                    decoration: const BoxDecoration(),
                    child: Row(
                      children: [
                        const Icon(Icons.language, size: 16.0),
                        SizedBox(width: size.width * 0.06),
                        const Text('Language', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const Divider(),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                    decoration: const BoxDecoration(),
                    child: Row(
                      children: [
                        const Icon(MdiIcons.help, size: 16.0),
                        SizedBox(width: size.width * 0.06),
                        const Text('Help', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                    decoration: const BoxDecoration(),
                    child: Row(
                      children: [
                        const Icon(MdiIcons.share, size: 16.0),
                        SizedBox(width: size.width * 0.06),
                        const Text('Tell a Friend', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
                      ],
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
