import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/backend/schema/structs/index.dart';

import '/auth/base_auth_user_provider.dart';

import '/flutter_flow/flutter_flow_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) => appStateNotifier.loggedIn
          ? LoginRedirectWidget()
          : EntryRedirectWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.loggedIn
              ? LoginRedirectWidget()
              : EntryRedirectWidget(),
        ),
        FFRoute(
          name: AuthentificateWidget.routeName,
          path: AuthentificateWidget.routePath,
          builder: (context, params) => AuthentificateWidget(),
        ),
        FFRoute(
          name: CreateProfileWidget.routeName,
          path: CreateProfileWidget.routePath,
          requireAuth: true,
          builder: (context, params) => CreateProfileWidget(),
        ),
        FFRoute(
          name: GeneralWidget.routeName,
          path: GeneralWidget.routePath,
          requireAuth: true,
          builder: (context, params) => GeneralWidget(
            firstEntry: params.getParam(
              'firstEntry',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: AccountPageWidget.routeName,
          path: AccountPageWidget.routePath,
          builder: (context, params) => AccountPageWidget(),
        ),
        FFRoute(
          name: PlaningWidget.routeName,
          path: PlaningWidget.routePath,
          builder: (context, params) => PlaningWidget(),
        ),
        FFRoute(
          name: CheckoutWidget.routeName,
          path: CheckoutWidget.routePath,
          requireAuth: true,
          builder: (context, params) => CheckoutWidget(),
        ),
        FFRoute(
          name: AddAddressWidget.routeName,
          path: AddAddressWidget.routePath,
          builder: (context, params) => AddAddressWidget(),
        ),
        FFRoute(
          name: PickOnMapWidget.routeName,
          path: PickOnMapWidget.routePath,
          builder: (context, params) => PickOnMapWidget(),
        ),
        FFRoute(
          name: OrderHistoryWidget.routeName,
          path: OrderHistoryWidget.routePath,
          builder: (context, params) => OrderHistoryWidget(),
        ),
        FFRoute(
          name: OrderHelpWidget.routeName,
          path: OrderHelpWidget.routePath,
          builder: (context, params) => OrderHelpWidget(),
        ),
        FFRoute(
          name: PaymentMethodWidget.routeName,
          path: PaymentMethodWidget.routePath,
          builder: (context, params) => PaymentMethodWidget(),
        ),
        FFRoute(
          name: EditProfileWidget.routeName,
          path: EditProfileWidget.routePath,
          builder: (context, params) => EditProfileWidget(
            page: params.getParam(
              'page',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: AddressesWidget.routeName,
          path: AddressesWidget.routePath,
          builder: (context, params) => AddressesWidget(),
        ),
        FFRoute(
          name: OtpWidget.routeName,
          path: OtpWidget.routePath,
          builder: (context, params) => OtpWidget(),
        ),
        FFRoute(
          name: EmailAUTHWidget.routeName,
          path: EmailAUTHWidget.routePath,
          builder: (context, params) => EmailAUTHWidget(),
        ),
        FFRoute(
          name: AddPropertyWidget.routeName,
          path: AddPropertyWidget.routePath,
          builder: (context, params) => AddPropertyWidget(),
        ),
        FFRoute(
          name: SupportWidget.routeName,
          path: SupportWidget.routePath,
          builder: (context, params) => SupportWidget(),
        ),
        FFRoute(
          name: SupportChatWidget.routeName,
          path: SupportChatWidget.routePath,
          builder: (context, params) => SupportChatWidget(),
        ),
        FFRoute(
          name: NotificationsWidget.routeName,
          path: NotificationsWidget.routePath,
          builder: (context, params) => NotificationsWidget(),
        ),
        FFRoute(
          name: SearchWidget.routeName,
          path: SearchWidget.routePath,
          builder: (context, params) => SearchWidget(),
        ),
        FFRoute(
          name: CustomizeStepWidget.routeName,
          path: CustomizeStepWidget.routePath,
          requireAuth: true,
          builder: (context, params) => CustomizeStepWidget(),
        ),
        FFRoute(
          name: MasterFinderMapBoxWidget.routeName,
          path: MasterFinderMapBoxWidget.routePath,
          builder: (context, params) => MasterFinderMapBoxWidget(
            orderId: params.getParam(
              'orderId',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: CompeteRegistrationWidget.routeName,
          path: CompeteRegistrationWidget.routePath,
          requireAuth: true,
          builder: (context, params) => CompeteRegistrationWidget(),
        ),
        FFRoute(
          name: Promo2Widget.routeName,
          path: Promo2Widget.routePath,
          builder: (context, params) => Promo2Widget(),
        ),
        FFRoute(
          name: Promo1Widget.routeName,
          path: Promo1Widget.routePath,
          builder: (context, params) => Promo1Widget(),
        ),
        FFRoute(
          name: Promo3Widget.routeName,
          path: Promo3Widget.routePath,
          builder: (context, params) => Promo3Widget(),
        ),
        FFRoute(
          name: GeneralEntryFirstWidget.routeName,
          path: GeneralEntryFirstWidget.routePath,
          requireAuth: true,
          builder: (context, params) => GeneralEntryFirstWidget(),
        ),
        FFRoute(
          name: AddOnsWidget.routeName,
          path: AddOnsWidget.routePath,
          requireAuth: true,
          builder: (context, params) => AddOnsWidget(),
        ),
        FFRoute(
          name: EntryRedirectWidget.routeName,
          path: EntryRedirectWidget.routePath,
          builder: (context, params) => EntryRedirectWidget(),
        ),
        FFRoute(
          name: LoginRedirectWidget.routeName,
          path: LoginRedirectWidget.routePath,
          builder: (context, params) => LoginRedirectWidget(),
        ),
        FFRoute(
          name: ServicePageWidget.routeName,
          path: ServicePageWidget.routePath,
          builder: (context, params) => ServicePageWidget(
            category: params.getParam(
              'category',
              ParamType.DataStruct,
              isList: false,
              structBuilder: ServiceCategoryStruct.fromSerializableMap,
            ),
          ),
        ),
        FFRoute(
          name: TipsWidget.routeName,
          path: TipsWidget.routePath,
          builder: (context, params) => TipsWidget(),
        ),
        FFRoute(
          name: CheckoutFlowWidget.routeName,
          path: CheckoutFlowWidget.routePath,
          builder: (context, params) => CheckoutFlowWidget(),
        ),
        FFRoute(
          name: SettingsMainWidget.routeName,
          path: SettingsMainWidget.routePath,
          builder: (context, params) => SettingsMainWidget(),
        ),
        FFRoute(
          name: AccountCenterWidget.routeName,
          path: AccountCenterWidget.routePath,
          builder: (context, params) => AccountCenterWidget(),
        ),
        FFRoute(
          name: CompletedEntriesWidget.routeName,
          path: CompletedEntriesWidget.routePath,
          builder: (context, params) => CompletedEntriesWidget(),
        ),
        FFRoute(
          name: AddToCartAnimationWidget.routeName,
          path: AddToCartAnimationWidget.routePath,
          requireAuth: true,
          builder: (context, params) => AddToCartAnimationWidget(),
        ),
        FFRoute(
          name: ConfidentiallyWidget.routeName,
          path: ConfidentiallyWidget.routePath,
          builder: (context, params) => ConfidentiallyWidget(),
        ),
        FFRoute(
          name: SavedAddressesOffPageWidget.routeName,
          path: SavedAddressesOffPageWidget.routePath,
          builder: (context, params) => SavedAddressesOffPageWidget(),
        ),
        FFRoute(
          name: SavedAddressesOnPageWidget.routeName,
          path: SavedAddressesOnPageWidget.routePath,
          builder: (context, params) => SavedAddressesOnPageWidget(),
        ),
        FFRoute(
          name: SpecialFeaturesWidget.routeName,
          path: SpecialFeaturesWidget.routePath,
          builder: (context, params) => SpecialFeaturesWidget(),
        ),
        FFRoute(
          name: CommunicationWidget.routeName,
          path: CommunicationWidget.routePath,
          builder: (context, params) => CommunicationWidget(),
        ),
        FFRoute(
          name: SecuritySettingsWidget.routeName,
          path: SecuritySettingsWidget.routePath,
          builder: (context, params) => SecuritySettingsWidget(),
        ),
        FFRoute(
          name: TrustedContactsOffWidget.routeName,
          path: TrustedContactsOffWidget.routePath,
          builder: (context, params) => TrustedContactsOffWidget(),
        ),
        FFRoute(
          name: TrustedContactsOnWidget.routeName,
          path: TrustedContactsOnWidget.routePath,
          builder: (context, params) => TrustedContactsOnWidget(),
        ),
        FFRoute(
          name: ContactInfoWidget.routeName,
          path: ContactInfoWidget.routePath,
          builder: (context, params) => ContactInfoWidget(),
        ),
        FFRoute(
          name: PasskeyWidget.routeName,
          path: PasskeyWidget.routePath,
          builder: (context, params) => PasskeyWidget(),
        ),
        FFRoute(
          name: ChangeNameWidget.routeName,
          path: ChangeNameWidget.routePath,
          builder: (context, params) => ChangeNameWidget(),
        ),
        FFRoute(
          name: PushNot2Widget.routeName,
          path: PushNot2Widget.routePath,
          builder: (context, params) => PushNot2Widget(),
        ),
        FFRoute(
          name: EmailMailingWidget.routeName,
          path: EmailMailingWidget.routePath,
          builder: (context, params) => EmailMailingWidget(),
        ),
        FFRoute(
          name: SMSMailingWidget.routeName,
          path: SMSMailingWidget.routePath,
          builder: (context, params) => SMSMailingWidget(),
        ),
        FFRoute(
          name: IndividualOffersWidget.routeName,
          path: IndividualOffersWidget.routePath,
          builder: (context, params) => IndividualOffersWidget(),
        ),
        FFRoute(
          name: GenderWidget.routeName,
          path: GenderWidget.routePath,
          builder: (context, params) => GenderWidget(),
        ),
        FFRoute(
          name: YourSuggestionsWidget.routeName,
          path: YourSuggestionsWidget.routePath,
          builder: (context, params) => YourSuggestionsWidget(),
        ),
        FFRoute(
          name: EmailWidget.routeName,
          path: EmailWidget.routePath,
          builder: (context, params) => EmailWidget(),
        ),
        FFRoute(
          name: PartnersAdvertisingWidget.routeName,
          path: PartnersAdvertisingWidget.routePath,
          builder: (context, params) => PartnersAdvertisingWidget(),
        ),
        FFRoute(
          name: PaymentSuccessPageWidget.routeName,
          path: PaymentSuccessPageWidget.routePath,
          builder: (context, params) => PaymentSuccessPageWidget(),
        ),
        FFRoute(
          name: VoucherscopyyWidget.routeName,
          path: VoucherscopyyWidget.routePath,
          builder: (context, params) => VoucherscopyyWidget(),
        ),
        FFRoute(
          name: VouchersWidget.routeName,
          path: VouchersWidget.routePath,
          builder: (context, params) => VouchersWidget(),
        ),
        FFRoute(
          name: ActiveOrderTrackingWidget.routeName,
          path: ActiveOrderTrackingWidget.routePath,
          builder: (context, params) => ActiveOrderTrackingWidget(
            orderId: params.getParam(
              'orderId',
              ParamType.int,
            ),
          ),
        ),
        FFRoute(
          name: HowDoIBookAServiceWidget.routeName,
          path: HowDoIBookAServiceWidget.routePath,
          builder: (context, params) => HowDoIBookAServiceWidget(),
        ),
        FFRoute(
          name: CanICancelOrRescheduleMyBookingWidget.routeName,
          path: CanICancelOrRescheduleMyBookingWidget.routePath,
          builder: (context, params) => CanICancelOrRescheduleMyBookingWidget(),
        ),
        FFRoute(
          name: FaqWidget.routeName,
          path: FaqWidget.routePath,
          builder: (context, params) => FaqWidget(),
        ),
        FFRoute(
          name: BookingWidget.routeName,
          path: BookingWidget.routePath,
          builder: (context, params) => BookingWidget(),
        ),
        FFRoute(
          name: WhatHappensAfterIPlaceABookingWidget.routeName,
          path: WhatHappensAfterIPlaceABookingWidget.routePath,
          builder: (context, params) => WhatHappensAfterIPlaceABookingWidget(),
        ),
        FFRoute(
          name: WhichAreasDoesHelperoCurrentlyServeWidget.routeName,
          path: WhichAreasDoesHelperoCurrentlyServeWidget.routePath,
          builder: (context, params) =>
              WhichAreasDoesHelperoCurrentlyServeWidget(),
        ),
        FFRoute(
          name: CanIBookMultipleServicesAtOnceWidget.routeName,
          path: CanIBookMultipleServicesAtOnceWidget.routePath,
          builder: (context, params) => CanIBookMultipleServicesAtOnceWidget(),
        ),
        FFRoute(
          name: PaymentWidget.routeName,
          path: PaymentWidget.routePath,
          builder: (context, params) => PaymentWidget(),
        ),
        FFRoute(
          name: WhatPaymentMethodsAreAcceptedWidget.routeName,
          path: WhatPaymentMethodsAreAcceptedWidget.routePath,
          builder: (context, params) => WhatPaymentMethodsAreAcceptedWidget(),
        ),
        FFRoute(
          name: WhenDoesThePaymentGetChargedWidget.routeName,
          path: WhenDoesThePaymentGetChargedWidget.routePath,
          builder: (context, params) => WhenDoesThePaymentGetChargedWidget(),
        ),
        FFRoute(
          name: WhatIsTheRefundPolicyWidget.routeName,
          path: WhatIsTheRefundPolicyWidget.routePath,
          builder: (context, params) => WhatIsTheRefundPolicyWidget(),
        ),
        FFRoute(
          name: HowDoIUseAPromoCodeOrDiscountWidget.routeName,
          path: HowDoIUseAPromoCodeOrDiscountWidget.routePath,
          builder: (context, params) => HowDoIUseAPromoCodeOrDiscountWidget(),
        ),
        FFRoute(
          name: SafetyAndTrustWidget.routeName,
          path: SafetyAndTrustWidget.routePath,
          builder: (context, params) => SafetyAndTrustWidget(),
        ),
        FFRoute(
          name: WhoAreTheHelperoProfessionalsWidget.routeName,
          path: WhoAreTheHelperoProfessionalsWidget.routePath,
          builder: (context, params) => WhoAreTheHelperoProfessionalsWidget(),
        ),
        FFRoute(
          name: AmICoveredIfSomethingIsDamagedWidget.routeName,
          path: AmICoveredIfSomethingIsDamagedWidget.routePath,
          builder: (context, params) => AmICoveredIfSomethingIsDamagedWidget(),
        ),
        FFRoute(
          name: IsItSafeToGiveAccessToMyHomeWidget.routeName,
          path: IsItSafeToGiveAccessToMyHomeWidget.routePath,
          builder: (context, params) => IsItSafeToGiveAccessToMyHomeWidget(),
        ),
        FFRoute(
          name: SubscriptionWidget.routeName,
          path: SubscriptionWidget.routePath,
          builder: (context, params) => SubscriptionWidget(),
        ),
        FFRoute(
          name: HowDoICancelMyHelperoPlusPlanWidget.routeName,
          path: HowDoICancelMyHelperoPlusPlanWidget.routePath,
          builder: (context, params) => HowDoICancelMyHelperoPlusPlanWidget(),
        ),
        FFRoute(
          name: HowDoPlusDiscountsApplyAtCheckoutWidget.routeName,
          path: HowDoPlusDiscountsApplyAtCheckoutWidget.routePath,
          builder: (context, params) =>
              HowDoPlusDiscountsApplyAtCheckoutWidget(),
        ),
        FFRoute(
          name: MyOrdersWidget.routeName,
          path: MyOrdersWidget.routePath,
          builder: (context, params) => MyOrdersWidget(),
        ),
        FFRoute(
          name: HowDoITrackMyProfessionalInRealTimeWidget.routeName,
          path: HowDoITrackMyProfessionalInRealTimeWidget.routePath,
          builder: (context, params) =>
              HowDoITrackMyProfessionalInRealTimeWidget(),
        ),
        FFRoute(
          name: HowDoIRateMyProfessionalWidget.routeName,
          path: HowDoIRateMyProfessionalWidget.routePath,
          builder: (context, params) => HowDoIRateMyProfessionalWidget(),
        ),
        FFRoute(
          name: WhereCanISeeMyPastOrdersWidget.routeName,
          path: WhereCanISeeMyPastOrdersWidget.routePath,
          builder: (context, params) => WhereCanISeeMyPastOrdersWidget(),
        ),
        FFRoute(
          name: MyAccountWidget.routeName,
          path: MyAccountWidget.routePath,
          builder: (context, params) => MyAccountWidget(),
        ),
        FFRoute(
          name: HowDoICreateAHelperoAccountWidget.routeName,
          path: HowDoICreateAHelperoAccountWidget.routePath,
          builder: (context, params) => HowDoICreateAHelperoAccountWidget(),
        ),
        FFRoute(
          name: HowDoIUpdateMyProfileOrAddressWidget.routeName,
          path: HowDoIUpdateMyProfileOrAddressWidget.routePath,
          builder: (context, params) => HowDoIUpdateMyProfileOrAddressWidget(),
        ),
        FFRoute(
          name: WhatIsHelperoPlusWidget.routeName,
          path: WhatIsHelperoPlusWidget.routePath,
          builder: (context, params) => WhatIsHelperoPlusWidget(),
        ),
        FFRoute(
          name: HowDoIDeleteMyAccountWidget.routeName,
          path: HowDoIDeleteMyAccountWidget.routePath,
          builder: (context, params) => HowDoIDeleteMyAccountWidget(),
        ),
        FFRoute(
          name: ConsultantChatWidget.routeName,
          path: ConsultantChatWidget.routePath,
          builder: (context, params) => ConsultantChatWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
      observers: [routeObserver],
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/entryRedirect';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? Center(
                  child: SizedBox(
                    width: 10.0,
                    height: 10.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.transparent,
                      ),
                    ),
                  ),
                )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  name: state.name,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(
                  key: state.pageKey, name: state.name, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 0),
      );
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
