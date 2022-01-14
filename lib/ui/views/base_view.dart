import 'package:flutter/material.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';
import 'package:provider/provider.dart';

class BaseView<T extends BaseModel> extends StatefulWidget {
  const BaseView({
    required this.builder,
    this.onModelReady,
    this.onModelDestroy,
    this.model,
    Key? key,
  }) : super(key: key);

  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final Function(T)? onModelReady;
  final Function(T)? onModelDestroy;
  final T? model;

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
  late T model;

  @override
  void initState() {
    model = widget.model ?? locator<T>();
    if (widget.onModelReady != null) {
      widget.onModelReady!(model);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.onModelDestroy != null) {
      widget.onModelDestroy!(model);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer<T>(
        builder: widget.builder,
      ),
    );
  }
}
