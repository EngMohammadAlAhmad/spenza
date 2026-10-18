import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
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
        borderRadius: BorderRadius.circular(18.0),
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
                        borderRadius: BorderRadius.circular(4.0),
                        child: Row(
                          children: List.generate(stepCount - 1, (index) {
                            final isLineReached =
                                stages[index + 1].isReached || stages[index + 1].isCurrent;
                            return Expanded(
                              child: _buildLineSegment(isLineReached),
                            );
                          }),
                        ),
                      ),
                    ),

                    // Foreground Nodes Row
                    Row(
                      children: stages.map((stage) {
                        return Expanded(
                          child: Center(
                            child: _buildStepNode(stage),
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
                children: stages.map((stage) {
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
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLineSegment(bool isReached) {
    if (isReached) {
      return Container(
        height: 8.0,
        decoration: const BoxDecoration(
          color: Color(0xFFC74436),
        ),
        child: Image.asset(
          'assets/images/stripes.png',
          repeat: ImageRepeat.repeat,
          fit: BoxFit.cover,
          opacity: const AlwaysStoppedAnimation(0.35),
        ),
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
      return Container(
        width: 52.0,
        height: 52.0,
        decoration: BoxDecoration(
          color: const Color(0xFFC74436).withValues(alpha: 0.22),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          width: 38.0,
          height: 38.0,
          decoration: const BoxDecoration(
            color: Color(0xFFC74436),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            _getStageIcon(stage.key),
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      );
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
        return 'assets/icons/check_icon.svg';
      case 'preparing':
      case 'processing':
        return 'assets/icons/preparing_icon.svg';
      case 'with_courier':
      case 'out_for_delivery':
        return 'assets/icons/truck_icon.svg';
      case 'delivered':
        return 'assets/icons/packageCheck_icon.svg';
      default:
        return 'assets/icons/packageCheck_icon.svg';
    }
  }
}
