import 'package:flutter/material.dart';
import 'package:ledtemplate/widgets/neon_button.dart';
import 'models/template.dart';
import 'play_page.dart';
import 'editor_page.dart';

class ResultPage extends StatelessWidget {
  final Template template;

  const ResultPage({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Success Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.black,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 32),

                // Success Text
                const Text(
                  'Successfully!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your template has been saved.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 48),

                // Play Now Button (Primary Large)
                SizedBox(
                  width: double.infinity,
                  child: NeonButton(
                    size: NeonButtonSize.large,
                    type: NeonButtonType.primary,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => PlayPage(
                                text: template.text,
                                fontFamily: template.fontFamily,
                                fontSize: template.fontSize,
                                textColor: template.textColor,
                                textGradientColors: template.textGradientColors,
                                textGradientRotation:
                                    template.textGradientRotation,
                                enableStroke: template.enableStroke,
                                strokeWidth: template.strokeWidth,
                                strokeColor: template.strokeColor,
                                strokeGradientColors:
                                    template.strokeGradientColors,
                                strokeGradientRotation:
                                    template.strokeGradientRotation,
                                enableOutline: template.enableOutline,
                                outlineWidth: template.outlineWidth,
                                outlineBlur: template.outlineBlur,
                                outlineColor: template.outlineColor,
                                outlineGradientColors:
                                    template.outlineGradientColors,
                                outlineGradientRotation:
                                    template.outlineGradientRotation,
                                enableShadow: template.enableShadow,
                                shadowOffsetX: template.shadowOffsetX,
                                shadowOffsetY: template.shadowOffsetY,
                                shadowBlur: template.shadowBlur,
                                shadowColor: template.shadowColor,
                                shadowGradientColors:
                                    template.shadowGradientColors,
                                shadowGradientRotation:
                                    template.shadowGradientRotation,
                                scrollDirection: template.scrollDirection,
                                scrollSpeed: template.scrollSpeed,
                                enableBlink: template.enableBlink,
                                blinkDuration: template.blinkDuration,
                                backgroundColor: template.backgroundColor,
                                backgroundGradientColors:
                                    template.backgroundGradientColors,
                                backgroundGradientRotation:
                                    template.backgroundGradientRotation,
                                backgroundImage: template.backgroundImage,
                                enableFrame: template.enableFrame,
                                frameImage: template.frameImage,
                                enableFrameGlow: template.enableFrameGlow,
                                frameGlowSize: template.frameGlowSize,
                                frameGlowBlur: template.frameGlowBlur,
                                frameGlowBorderRadius:
                                    template.frameGlowBorderRadius,
                                frameGlowColor: template.frameGlowColor,
                                frameGlowGradientColors:
                                    template.frameGlowGradientColors,
                                frameGlowGradientRotation:
                                    template.frameGlowGradientRotation,
                                fromResultPage: true,
                                enableScroll: template.enableScroll,
                                enableBounceZoom: template.enableBounceZoom,
                                enableBounce: template.enableBounce,
                                bounceDirection: template.bounceDirection,
                                zoomLevel: template.zoomLevel,
                                zoomSpeed: template.zoomSpeed,
                                bounceLevel: template.bounceLevel,
                                bounceSpeed: template.bounceSpeed,
                                enableRotationBounce:
                                    template.enableRotationBounce,
                                rotationStart: template.rotationStart,
                                rotationEnd: template.rotationEnd,
                                rotationSpeed: template.rotationSpeed,
                              ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_circle_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text('Play now'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Create New Button (Tonal Large)
                SizedBox(
                  width: double.infinity,
                  child: NeonButton(
                    size: NeonButtonSize.large,
                    type: NeonButtonType.secondary,
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const EditorPage(),
                        ),
                        (route) => route.isFirst,
                      );
                    },
                    child: const Text('Create new'),
                  ),
                ),
                const SizedBox(height: 80),

                // Home Page Button (Tonal Small)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NeonButton(
                      size: NeonButtonSize.medium,
                      type: NeonButtonType.tonal,
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      child: const Text('Home'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
