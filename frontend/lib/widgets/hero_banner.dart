import 'package:flutter/material.dart';
import '../constants.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(kDefaultPadding * 2),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage("https://img.freepik.com/free-vector/medical-healthcare-blue-color_1017-26797.jpg?w=1380"),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ваша онлайн аптека",
            style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Купуйте ліки\nне виходячи з дому",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: 20),
          Chip(
            backgroundColor: kAccentColor,
            label: Text("Знижки до -15% для Premium", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}