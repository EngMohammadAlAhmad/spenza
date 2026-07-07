import 'package:flutter/material.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/core/widgets/general_error_widget.dart';

class BlocStateHandler<T> extends StatelessWidget {
  const BlocStateHandler({
    super.key,
    required this.state,
    required this.onSuccess,
    this.onRetry,
    this.loadingWidget,
    this.errorWidget,
  });

  final BaseState<T> state;
  final Widget Function(T data) onSuccess;
  final VoidCallback? onRetry;
  final Widget? loadingWidget;
  final Widget Function(String? message)? errorWidget;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return loadingWidget ??
          const Center(child: CircularProgressIndicator());
    }

    if (state.isError) {
      if (errorWidget != null) {
        return errorWidget!(state.errorMessage);
      }

      return GeneralErrorWidget(
        message: state.errorMessage,
        onRetry: onRetry,
      );
    }

    if (state.data == null) {
      return const SizedBox.shrink();
    }

    return onSuccess(state.data as T);
  }
}
