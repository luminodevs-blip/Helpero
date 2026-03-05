import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';
import 'add_to_cart_animation_model.dart';
export 'add_to_cart_animation_model.dart';

class AddToCartAnimationWidget extends StatefulWidget {
  const AddToCartAnimationWidget({super.key});

  static String routeName = 'AddToCartAnimation';
  static String routePath = '/addToCartAnimation';

  @override
  State<AddToCartAnimationWidget> createState() =>
      _AddToCartAnimationWidgetState();
}

class _AddToCartAnimationWidgetState extends State<AddToCartAnimationWidget> {
  late AddToCartAnimationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddToCartAnimationModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        Duration(
          milliseconds: 1050,
        ),
      );

      context.goNamed(
        CustomizeStepWidget.routeName,
        extra: <String, dynamic>{
          '__transition_info__': TransitionInfo(
            hasTransition: true,
            transitionType: PageTransitionType.fade,
            duration: Duration(milliseconds: 0),
          ),
        },
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 0.0, 84.0),
                  child: Lottie.asset(
                    'assets/jsons/Untitled_file.json',
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    height: 400.0,
                    fit: BoxFit.fitWidth,
                    animate: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
