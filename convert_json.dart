import 'dart:convert';
import 'dart:io';

void main() {
  // Read the JSON file
  final jsonFile = File('sign_template.json');
  final jsonString = jsonFile.readAsStringSync();
  final jsonData = json.decode(jsonString);

  final templates = jsonData['templates'] as List;

  print('TemplateCategory(');
  print('  name: \'Sign\',');
  print('  templates: [');

  for (var i = 0; i < templates.length; i++) {
    final t = templates[i];

    print('    Template(');
    print('      text: \'${t['text']}\',');
    print('      fontFamily: \'${t['fontFamily']}\',');
    print('      fontSize: ${t['fontSize']},');

    // Text color
    if (t['textGradientColors'] != null) {
      final colors = t['textGradientColors'] as List;
      print(
        '      textGradientColors: [${colors.map((c) => 'Color($c)').join(', ')}],',
      );
      print('      textGradientRotation: ${t['textGradientRotation']},');
    }
    print('      textColor: Color(${t['textColor']}),');

    // Stroke
    if (t['enableStroke']) {
      print('      enableStroke: true,');
      print('      strokeWidth: ${t['strokeWidth']},');
      if (t['strokeGradientColors'] != null) {
        final colors = t['strokeGradientColors'] as List;
        print(
          '      strokeGradientColors: [${colors.map((c) => 'Color($c)').join(', ')}],',
        );
      }
      print('      strokeColor: Color(${t['strokeColor']}),');
    }

    // Outline
    if (t['enableOutline']) {
      print('      enableOutline: true,');
      print('      outlineWidth: ${t['outlineWidth']},');
      print('      outlineBlur: ${t['outlineBlur']},');
      if (t['outlineGradientColors'] != null) {
        final colors = t['outlineGradientColors'] as List;
        print(
          '      outlineGradientColors: [${colors.map((c) => 'Color($c)').join(', ')}],',
        );
      }
      print('      outlineColor: Color(${t['outlineColor']}),');
    }

    // Shadow
    if (t['enableShadow']) {
      print('      enableShadow: true,');
      print('      shadowOffsetX: ${t['shadowOffsetX']},');
      print('      shadowOffsetY: ${t['shadowOffsetY']},');
      print('      shadowBlur: ${t['shadowBlur']},');
      print('      shadowColor: Color(${t['shadowColor']}),');
    }

    // Effects
    if (t['enableScroll']) {
      print('      enableScroll: true,');
      print('      scrollSpeed: ${t['scrollSpeed']},');
    }
    if (t['enableBounceZoom']) {
      print('      enableBounceZoom: true,');
      print('      zoomLevel: ${t['zoomLevel']},');
      print('      zoomSpeed: ${t['zoomSpeed']},');
    }
    if (t['enableBounce']) {
      print('      enableBounce: true,');
      print(
        '      bounceDirection: BounceDirection.values[${t['bounceDirection']}],',
      );
      print('      bounceLevel: ${t['bounceLevel']},');
      print('      bounceSpeed: ${t['bounceSpeed']},');
    }
    if (t['enableBlink']) {
      print('      enableBlink: true,');
      print('      blinkDuration: ${t['blinkDuration']},');
    }
    if (t['enableRotationBounce']) {
      print('      enableRotationBounce: true,');
      print('      rotationStart: ${t['rotationStart']},');
      print('      rotationEnd: ${t['rotationEnd']},');
      print('      rotationSpeed: ${t['rotationSpeed']},');
    }

    // Background
    if (t['backgroundImage'] != null) {
      print('      backgroundImage: \'${t['backgroundImage']}\',');
    }

    // Frame
    if (t['enableFrame']) {
      print('      enableFrame: true,');
      print('      frameImage: \'${t['frameImage']}\',');
    }

    print('    ),');
  }

  print('  ],');
  print('),');
}
