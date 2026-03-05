import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'category_card_model.dart';
export 'category_card_model.dart';

class CategoryCardWidget extends StatefulWidget {
  const CategoryCardWidget({
    super.key,
    required this.category,
  });

  final ServiceCategoryStruct? category;

  @override
  State<CategoryCardWidget> createState() => _CategoryCardWidgetState();
}

class _CategoryCardWidgetState extends State<CategoryCardWidget> {
  late CategoryCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CategoryCardModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        context.pushNamed(
          ServicePageWidget.routeName,
          queryParameters: {
            'category': serializeParam(
              widget.category,
              ParamType.DataStruct,
            ),
          }.withoutNulls,
          extra: <String, dynamic>{
            '__transition_info__': TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade,
              duration: Duration(milliseconds: 0),
            ),
          },
        );
      },
      child: Container(
        width: 80.0,
        height: 110.0,
        decoration: BoxDecoration(
          color: Color(0xFFF5F7FB),
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              color: FlutterFlowTheme.of(context).primaryBackground,
              offset: Offset(
                0.0,
                2.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                valueOrDefault<String>(
                  widget.category?.imageUrl,
                  'https://hwgmjlsoeebgounmthmr.supabase.co/storage/v1/object/public/icons/bucket.png',
                ),
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
              child: Text(
                valueOrDefault<String>(
                  widget.category?.name,
                  'Cleaning',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.outfit(
                        fontWeight: FontWeight.w500,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.w500,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]
              .divide(SizedBox(height: 4.0))
              .addToStart(SizedBox(height: 8.0))
              .addToEnd(SizedBox(height: 8.0)),
        ),
      ),
    );
  }
}
