import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AddBillActions extends StatelessWidget {
  const AddBillActions({
    super.key,
    required this.enabled,
    this.scansEnabled = true,
    required this.onManual,
    required this.onGallery,
    required this.onCamera,
  });

  final bool enabled;

  /// False once the device has used all its free AI scans. Manual entry stays
  /// available.
  final bool scansEnabled;
  final VoidCallback onManual;
  final VoidCallback onGallery;
  final VoidCallback onCamera;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _BillAction(
        icon: Icons.edit_note,
        label: 'Manual',
        semanticsLabel: 'Add a bill manually',
        onTap: enabled ? onManual : null,
      ),
      _BillAction(
        icon: Icons.photo_library_outlined,
        label: 'Gallery',
        semanticsLabel: 'Upload a bill from the gallery',
        onTap: enabled && scansEnabled ? onGallery : null,
      ),
      _BillAction(
        icon: Icons.photo_camera_outlined,
        label: 'Camera',
        semanticsLabel: 'Photograph a bill',
        onTap: enabled && scansEnabled ? onCamera : null,
      ),
    ];

    return Row(
      children: [
        for (var index = 0; index < actions.length; index++) ...[
          if (index > 0) const SizedBox(width: 10),
          Expanded(
            child: actions[index]
                .animate()
                .fadeIn(delay: (index * 70).ms, duration: 350.ms)
                .slideY(
                  begin: 0.12,
                  end: 0,
                  delay: (index * 70).ms,
                  duration: 350.ms,
                ),
          ),
        ],
      ],
    );
  }
}

class _BillAction extends StatelessWidget {
  const _BillAction({
    required this.icon,
    required this.label,
    required this.semanticsLabel,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String semanticsLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.45 : 1,
      child: Semantics(
        button: true,
        label: semanticsLabel,
        child: Material(
          color: AppColors.pageBackground,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                children: [
                  Icon(icon, color: AppColors.coinGold),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
