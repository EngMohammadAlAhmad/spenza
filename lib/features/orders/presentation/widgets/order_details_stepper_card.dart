import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/features/orders/domain/entities/order_tracking_entity.dart';
import 'package:spenza/features/orders/domain/entities/order_tracking_stage_entity.dart';

class OrderDetailsStepperCard extends StatelessWidget {
  final OrderTrackingEntity? tracking;

  const OrderDetailsStepperCard({
    super.key,
    required this.tracking,
  });

  @override
  Widget build(BuildContext context) {
    final stages = _getTrackingStages(tracking);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.upMedium,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final stepCount = stages.length;
          final slotWidth = totalWidth / stepCount;
          final halfSlotWidth = slotWidth / 2;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Stepper Nodes & Lines Stack
              SizedBox(
                height: 52.0,
                child: Stack(
                  children: [
                    // Background Connecting Lines Track
                    Positioned(
                      top: 22.0,
                      left: halfSlotWidth,
                      right: halfSlotWidth,
                      height: 8.0,
                      child: ClipRRect(
                        borderRadius: AppRadius.mini,
                        child: Row(
                          children: List.generate(stepCount - 1, (index) {
                            final isLineReached = stages[index + 1].isReached || stages[index + 1].isCurrent;
                            return Expanded(
                              child: _buildLineSegment(context, isLineReached, index),
                            );
                          }),
                        ),
                      ),
                    ),

                    // Foreground Nodes Row
                    Row(
                      children: stages.asMap().entries.map((entry) {
                        final index = entry.key;
                        final stage = entry.value;
                        return Expanded(
                          child: Center(
                            child: _buildStepNode(stage)
                                .animate(delay: (250 + index * 320).ms)
                                .fadeIn(duration: 400.ms)
                                .scale(
                                  begin: const Offset(0.6, 0.6),
                                  end: const Offset(1.0, 1.0),
                                  duration: 550.ms,
                                  curve: Curves.easeOutBack,
                                ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12.0),

              // Step Titles & Timestamps Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: stages.asMap().entries.map((entry) {
                  final index = entry.key;
                  final stage = entry.value;
                  return Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          stage.title,
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: stage.isCurrent || stage.isReached
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: stage.isCurrent
                                ? const Color(0xFFC74436)
                                : (stage.isReached
                                    ? AppColors.neutral900
                                    : AppColors.textSecondary),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (stage.description.isNotEmpty) ...[
                          const SizedBox(height: 3.0),
                          Text(
                            stage.description,
                            style: const TextStyle(
                              fontSize: 11.0,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ).animate(delay: (250 + index * 320 + 100).ms).fadeIn(duration: 500.ms).slideY(
                          begin: 0.15,
                          end: 0,
                          duration: 500.ms,
                          curve: Curves.easeOutCubic,
                        ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    ).animate().fadeIn(duration: 500.ms, curve: Curves.easeOut).slideY(
          begin: 0.08,
          end: 0,
          duration: 650.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildLineSegment(BuildContext context, bool isReached, int index) {
    if (isReached) {
      final isRtl = Directionality.of(context) == TextDirection.rtl;
      return Container(
        height: 8.0,
        decoration: const BoxDecoration(
          color: Color(0xFFC74436),
        ),
        child: Image.asset(
          AppAssets.stripes,
          repeat: ImageRepeat.repeat,
          fit: BoxFit.cover,
          opacity: const AlwaysStoppedAnimation(0.35),
        ),
      ).animate(delay: (250 + index * 320 + 140).ms).fadeIn(duration: 250.ms).scaleX(
            begin: 0.0,
            end: 1.0,
            duration: 420.ms,
            curve: Curves.easeInOutCubic,
            alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
          );
    } else {
      return Container(
        height: 8.0,
        color: const Color(0xFFEFECE8),
      );
    }
  }

  Widget _buildStepNode(OrderTrackingStageEntity stage) {
    if (stage.isCurrent) {
      return _ActivePulseNode(stageKey: stage.key);
    } else if (stage.isReached) {
      return Container(
        width: 30.0,
        height: 30.0,
        decoration: const BoxDecoration(
          color: Color(0xFFC74436),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.check_rounded,
          size: 18.0,
          color: Colors.white,
        ),
      );
    } else {
      return Container(
        width: 30.0,
        height: 30.0,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFE2DDD8),
            width: 2.0,
          ),
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          _getStageIcon(stage.key),
          width: 18.0,
          height: 18.0,
          colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
        ),
      );
    }
  }

  List<OrderTrackingStageEntity> _getTrackingStages(OrderTrackingEntity? tracking) {
    if (tracking != null && tracking.stages.isNotEmpty) {
      return tracking.stages;
    }

    final currentStep = tracking?.step ?? 1;

    return [
      OrderTrackingStageEntity(
        key: 'received',
        step: 1,
        title: 'استلمنا طلبك',
        description: 'تأكدنا من طلبك',
        isReached: currentStep >= 1,
        isCurrent: currentStep == 1,
      ),
      OrderTrackingStageEntity(
        key: 'preparing',
        step: 2,
        title: 'عم نجهزو',
        description: 'نجهّز منتجاتك',
        isReached: currentStep >= 2,
        isCurrent: currentStep == 2,
      ),
      OrderTrackingStageEntity(
        key: 'with_courier',
        step: 3,
        title: 'مع المندوب',
        description: 'في الطريق إليك',
        isReached: currentStep >= 3,
        isCurrent: currentStep == 3,
      ),
      OrderTrackingStageEntity(
        key: 'delivered',
        step: 4,
        title: 'وصل لسا',
        description: 'تم التسليم',
        isReached: currentStep >= 4,
        isCurrent: currentStep == 4,
      ),
    ];
  }

  String _getStageIcon(String key) {
    switch (key.toLowerCase()) {
      case 'received':
        return AppAssets.checkIcon;
      case 'preparing':
      case 'processing':
        return AppAssets.preparingIcon;
      case 'with_courier':
      case 'out_for_delivery':
        return AppAssets.truckIcon;
      case 'delivered':
        return AppAssets.packageCheckIcon;
      default:
        return AppAssets.packageCheckIcon;
    }
  }
}

class _ActivePulseNode extends StatefulWidget {
  final String stageKey;

  const _ActivePulseNode({required this.stageKey});

  @override
  State<_ActivePulseNode> createState() => _ActivePulseNodeState();
}

class _ActivePulseNodeState extends State<_ActivePulseNode>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale1Animation;
  late Animation<double> _scale2Animation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..repeat(reverse: true);

    _scale1Animation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scale2Animation = Tween<double>(begin: 1.0, end: 1.42).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.35, end: 0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52.0,
      height: 52.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Soft Ambient Glow
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scale2Animation.value,
                child: Container(
                  width: 52.0,
                  height: 52.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC74436).withValues(alpha: _opacityAnimation.value * 0.5),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
          // Inner Breathing Ring
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scale1Animation.value,
                child: Container(
                  width: 52.0,
                  height: 52.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC74436).withValues(alpha: _opacityAnimation.value),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
          // Center Active Stage Node
          Container(
            width: 38.0,
            height: 38.0,
            decoration: const BoxDecoration(
              color: Color(0xFFC74436),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x40C74436),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: _buildStageIcon(widget.stageKey),
          ),
        ],
      ),
    );
  }

  Widget _buildStageIcon(String key) {
    final lowerKey = key.toLowerCase();
    final iconPath = _getStageIcon(lowerKey);

    if (lowerKey == 'preparing' || lowerKey == 'processing') {
      return _RotatingPreparingIcon(
        iconPath: iconPath,
        width: 20.0,
        height: 20.0,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      );
    }

    return SvgPicture.asset(
      iconPath,
      width: 20.0,
      height: 20.0,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    );
  }

  String _getStageIcon(String key) {
    switch (key.toLowerCase()) {
      case 'received':
        return AppAssets.checkIcon;
      case 'preparing':
      case 'processing':
        return AppAssets.preparingIcon;
      case 'with_courier':
      case 'out_for_delivery':
        return AppAssets.truckIcon;
      case 'delivered':
        return AppAssets.packageCheckIcon;
      default:
        return AppAssets.packageCheckIcon;
    }
  }
}

class _RotatingPreparingIcon extends StatefulWidget {
  final String iconPath;
  final double width;
  final double height;
  final ColorFilter? colorFilter;

  const _RotatingPreparingIcon({
    required this.iconPath,
    required this.width,
    required this.height,
    this.colorFilter,
  });

  @override
  State<_RotatingPreparingIcon> createState() => _RotatingPreparingIconState();
}

class _RotatingPreparingIconState extends State<_RotatingPreparingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 2.0).chain(
          CurveTween(curve: Curves.easeInOutCubic),
        ),
        weight: 14,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(2.0),
        weight: 10,
      ),
    ]).animate(_rotationController);

    _rotationController.repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _rotationAnimation,
      child: SvgPicture.asset(
        widget.iconPath,
        width: widget.width,
        height: widget.height,
        colorFilter: widget.colorFilter,
      ),
    );
  }
}

