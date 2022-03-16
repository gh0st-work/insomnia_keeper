import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sa3_liquid/liquid/plasma/plasma.dart';



 Container lockScreenPlasma = Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      tileMode: TileMode.mirror,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xfff44336),
        Color(0xff2196f3),
      ],
      stops: [
        0,
        1,
      ],
    ),
    backgroundBlendMode: BlendMode.srcOver,
  ),
  child: PlasmaRenderer(
    type: PlasmaType.infinity,
    particles: 20,
    color: Color(0xafd4c81f),
    blur: 0.4,
    size: 0.58,
    speed: 6.01,
    offset: 2.79,
    blendMode: BlendMode.plus,
    particleType: ParticleType.atlas,
    variation1: 0,
    variation2: 0,
    variation3: 0.9,
    rotation: 0.87,
    child: Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.6),
        backgroundBlendMode: BlendMode.srcOver,
      ),
    ),
  ),
// PlasmaRenderer(
//     type: PlasmaType.infinity,
//     particles: 20,
//     color: Color(0xafd4c81f),
//     blur: 0.45,
//     size: 0.5830834600660535,
//     speed: 6.01,
//     offset: 2.79,
//     blendMode: BlendMode.plus,
//     particleType: ParticleType.atlas,
//     variation1: 0,
//     variation2: 0,
//     variation3: 0.85,
//     rotation: 0.87,
//   ),
);