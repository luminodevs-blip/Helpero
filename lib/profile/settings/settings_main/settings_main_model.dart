import '/flutter_flow/flutter_flow_util.dart';
import '/profile/settings/settings0/settings0_widget.dart';
import '/profile/settings/settings2/settings2_widget.dart';
import '/index.dart';
import 'settings_main_widget.dart' show SettingsMainWidget;
import 'package:flutter/material.dart';

class SettingsMainModel extends FlutterFlowModel<SettingsMainWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Settings2 component.
  late Settings2Model settings2Model1;
  // Model for Settings2 component.
  late Settings2Model settings2Model2;
  // Model for Settings2 component.
  late Settings2Model settings2Model3;
  // Model for Settings2 component.
  late Settings2Model settings2Model4;
  // Model for Settings2 component.
  late Settings2Model settings2Model5;
  // Model for Settings2 component.
  late Settings2Model settings2Model6;
  // Model for Settings0 component.
  late Settings0Model settings0Model1;
  // Model for Settings0 component.
  late Settings0Model settings0Model2;
  // Model for Settings0 component.
  late Settings0Model settings0Model3;
  // Model for Settings2 component.
  late Settings2Model settings2Model7;

  @override
  void initState(BuildContext context) {
    settings2Model1 = createModel(context, () => Settings2Model());
    settings2Model2 = createModel(context, () => Settings2Model());
    settings2Model3 = createModel(context, () => Settings2Model());
    settings2Model4 = createModel(context, () => Settings2Model());
    settings2Model5 = createModel(context, () => Settings2Model());
    settings2Model6 = createModel(context, () => Settings2Model());
    settings0Model1 = createModel(context, () => Settings0Model());
    settings0Model2 = createModel(context, () => Settings0Model());
    settings0Model3 = createModel(context, () => Settings0Model());
    settings2Model7 = createModel(context, () => Settings2Model());
  }

  @override
  void dispose() {
    settings2Model1.dispose();
    settings2Model2.dispose();
    settings2Model3.dispose();
    settings2Model4.dispose();
    settings2Model5.dispose();
    settings2Model6.dispose();
    settings0Model1.dispose();
    settings0Model2.dispose();
    settings0Model3.dispose();
    settings2Model7.dispose();
  }
}
