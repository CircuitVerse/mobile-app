import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SwitchLightWidget extends StatefulWidget {
  @Preview(name: 'Switch Light')
  const SwitchLightWidget({super.key});

  @override
  State<SwitchLightWidget> createState() => _SwitchLightState();
}

class _SwitchLightState extends State<SwitchLightWidget> {
  bool light1On = false;
  bool light2On = false;
  bool isBulbOn = false;
  String gateType = 'OR';
  String gateIcon = 'assets/icons/IB/OR_GATE.svg';

  List<Object> Gates = [
    {'name': 'AND', 'icon': 'assets/icons/IB/AND_GATE.svg'},
    {'name': 'OR', 'icon': 'assets/icons/IB/OR_GATE.svg'},
    {'name': 'NOT', 'icon': 'assets/icons/IB/NOT_GATE.svg'},
    {'name': 'XOR', 'icon': 'assets/icons/IB/XOR_GATE.svg'},
    {'name': 'NAND', 'icon': 'assets/icons/IB/NAND_GATE.svg'},
    {'name': 'NOR', 'icon': 'assets/icons/IB/NOR_GATE.svg'},
    {'name': 'XNOR', 'icon': 'assets/icons/IB/XNOR_GATE.svg'},
  ];

  void updateBulbState() {
    bool temp = false;
    if (gateType == 'AND') {
      temp = light1On && light2On;
    } else if (gateType == 'OR') {
      temp = light1On || light2On;
    } else if (gateType == 'NOT') {
      temp = !light1On;
    } else if (gateType == 'XOR') {
      temp = light1On ^ light2On;
    } else if (gateType == 'NAND') {
      temp = !(light1On && light2On);
    } else if (gateType == 'NOR') {
      temp = !(light1On || light2On);
    } else if (gateType == 'XNOR') {
      temp = !(light1On ^ light2On);
    }
    setState(() {
      isBulbOn = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: Gates.length,
              itemBuilder: (context, index) {
                final gate = Gates[index] as Map<String, String>;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      gateType = gate['name']!;
                      gateIcon = gate['icon']!;
                      updateBulbState();
                    });
                  },
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        gate['icon']!,
                        width: 50,
                        height: 50,
                        colorFilter: ColorFilter.mode(
                          gateType == gate['name'] ? Colors.green : Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                      Text(gate['name']!),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  if (gateType != 'NOT')
                    Switch(
                      value: light1On,
                      onChanged: (value) {
                        setState(() {
                          light1On = value;
                          updateBulbState();
                        });
                      },
                      activeThumbColor: Colors.yellow[900],
                      activeTrackColor: Colors.yellow,
                    ),
                  Switch(
                    value: light2On,
                    onChanged: (value) {
                      setState(() {
                        light2On = value;
                        updateBulbState();
                      });
                    },
                    activeThumbColor: Colors.yellow[900],
                    activeTrackColor: Colors.yellow,
                  ),
                ],
              ),

              SizedBox(width: 20),
              // Inline SVG string so previews that don't load asset bundles can still show it.
              SvgPicture.asset(
                gateIcon,
                width: 100,
                height: 100,
                colorFilter: ColorFilter.mode(Colors.blue, BlendMode.srcIn),
              ),

              Icon(
                Icons.lightbulb,
                size: 100,
                color: isBulbOn ? Colors.yellow[500] : Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
