import 'dart:io';
import 'dart:ui';

import 'package:braintoss/pages/stateful_page.dart';
import 'package:braintoss/stores/photo_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../config/theme.dart';
import '../constants/app_constants.dart';
import '../constants/colors.dart';
import '../widgets/atoms/bubble_button.dart';
import '../widgets/atoms/fittable_camera_preview.dart';
import '../widgets/atoms/labeled_icon_button.dart';
import '../widgets/atoms/textual_multiple_choice.dart';
import '../widgets/molecules/actions_popup.dart';
import '../widgets/molecules/main_header.dart';
import '../widgets/molecules/send_popup.dart';

class PhotoPage extends StatefulPage<PhotoStore> {
  const PhotoPage({super.key});

  @override
  StatefulPageState<PhotoStore> createState() => _PhotoPageState();
}

class _PhotoPageState extends StatefulPageState<PhotoStore>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    store.initializeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    store.lifecycle(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainHeader(
        action: store.onGoBack,
        headingText: AppLocalizations.of(context)!.headerTextPhoto,
        actionIcon: ButtonImages.closeScreen,
      ),
      backgroundColor: ThemeColors.black,
      body: _buildPageContent(context),
    );
  }

  static const double _photoControlsOffset = 57.5;

  Widget _buildPageContent(BuildContext context) {
    store.setContext(context);
    return Stack(
      children: [
        //Camera preview
        Observer(
          builder: (_) {
            return FittableCameraPreview(
              fit: BoxFit.cover,
              cameraController: store.cameraController,
              error: " ",
            );
          },
        ),
        //Zoom slider
        Observer(
          builder: (_) {
            return IgnorePointer(
              ignoring: store.actionPopupVisible,
              child: AnimatedOpacity(
                opacity:
                    !store.actionPopupVisible && store.cameraRunning ? 1 : 0,
                duration: quickTransition,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 60, 40),
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: Slider(
                          onChanged: (double value) {
                            store.setZoomLevel(value);
                          },
                          value: store.zoomLevel,
                          min: 1,
                          max: store.maxZoomLevel,
                          activeColor: ThemeColors.primaryYellow,
                          thumbColor: ThemeColors.primaryYellow,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        //Send button
        Observer(
          builder: (_) {
            return AnimatedOpacity(
              opacity: store.cameraRunning ? 1 : 0,
              duration: mediumQuickTransition,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            40, 0, 40, 40 + _photoControlsOffset),
                        child: AnimatedOpacity(
                          opacity: store.actionPopupVisible ? 0 : 1,
                          duration: quickTransition,
                          child: BubbleButton(
                            imagePath: ButtonImages.send,
                            diameter: 85,
                            onLongPress: store.onLongPressSend,
                            onTap: () {
                              store.onTapSend(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        //Actions popup
        Observer(
          builder: (_) {
            return AnimatedOpacity(
              opacity: store.actionPopupVisible ? 1 : 0,
              duration: quickTransition,
              onEnd: store.onActionPopupAnimationEnd,
              child: Visibility(
                visible: store.actionPopupInteractable,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ActionsPopup(
                    bottomOffset: 90 + _photoControlsOffset,
                    onOutsideTap: store.closeActionPopup,
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.light
                            ? ThemeColors.white.withOpacity(.70)
                            : ThemeColors.grayDark.withOpacity(.85),
                    child: _buildActionPopupContent(context),
                  ),
                ),
              ),
            );
          },
        ),
        //Long-press email popup
        Observer(
          builder: (_) {
            return AnimatedOpacity(
              opacity: store.longPressSendListVisible ? 1 : 0,
              duration: quickTransition,
              onEnd: store.onLongPressSendAnimationEnd,
              child: Visibility(
                visible: store.longPressSendListInteractable,
                child: SendPopup(
                  bottomOffset: 130 + _photoControlsOffset,
                  onTapOutside: store.closeLongPressSendList,
                  child: _buildEmailList(
                    store.onEmailSelectionFromLongPressSend,
                  ),
                ),
              ),
            );
          },
        ),
        //Action button
        Observer(
          builder: (_) {
            return Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    40, 0, 40, 40 + _photoControlsOffset),
                child: SizedBox(
                  width: 85,
                  height: 85,
                  child: Center(
                    child: AnimatedCrossFade(
                      crossFadeState: store.actionPopupVisible
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: BubbleButton(
                        imagePath: ButtonImages.plus,
                        diameter: 40,
                        onTap: store.openActionPopup,
                      ),
                      secondChild: BubbleButton(
                        imagePath: ButtonImages.closePopup,
                        diameter: 40,
                        onTap: store.closeActionPopup,
                        imageColor: Theme.of(context).colorScheme.brightness ==
                                Brightness.light
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onSecondary,
                      ),
                      duration: quickTransition,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        //Success overlay
        Observer(
          builder: (_) {
            return AnimatedOpacity(
              opacity: store.successOverlayVisible ? 1 : 0,
              duration: quickTransition,
              onEnd: store.showSuccessIcon,
              child: Stack(
                children: [
                  AbsorbPointer(
                    absorbing: store.successOverlayVisible,
                  ),
                  Visibility(
                    visible: store.successOverlayVisible,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Container(
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.40),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: AnimatedOpacity(
                              opacity: store.successIconVisible ? 1.0 : 0.0,
                              duration: mediumQuickTransition,
                              onEnd: store.onSuccessIconAnimationEnd,
                              child: Stack(
                                children: [
                                  if (store.successImage != null)
                                    Center(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: ThemeColors.white,
                                              style: BorderStyle.solid,
                                              width: 5),
                                          borderRadius: BorderRadius.zero,
                                          shape: BoxShape.rectangle,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: ThemeColors.grayDarker,
                                              blurRadius: 10,
                                              spreadRadius: 5,
                                            )
                                          ],
                                        ),
                                        child: FractionallySizedBox(
                                          widthFactor: 0.75,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Image.file(
                                              File(store.successImage!),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    Container(),
                                  Center(
                                    child: Image.asset(
                                      MiscImages.success,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }

  Widget _buildEmailList(void Function(dynamic) onSelection) {
    if (store.emails.length > 1) {
      return TextualMultipleChoice(
        initialSelectionValue: store.selectedEmail.getAliasOrEmail(),
        onValueChanged: onSelection,
        items: store.emails
            .map(
              (email) => TextualMultipleChoiceItem(
                labelText: email.getAliasOrEmail(),
                value: email,
              ),
            )
            .toList(),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildActionPopupContent(BuildContext context) {
    return Column(
      children: [
        _buildEmailList(store.onEmailSelectionChangeFromPopup),
        Row(
          children: [
            Expanded(
              child: LabeledIconButton(
                label: AppLocalizations.of(context)!.photoAlbum,
                icon: ButtonImages.album,
                iconSize: 30,
                iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
                separation: 5,
                labelStyle: TextStyles.actionPopupButtonLabel.merge(
                    TextStyle(color: Theme.of(context).colorScheme.secondary)),
                onTap: store.onAlbum,
              ),
            ),
            Expanded(
              child: LabeledIconButton(
                label: AppLocalizations.of(context)!.photoFlip,
                icon: ButtonImages.flipCamera,
                iconSize: 30,
                iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
                separation: 5,
                labelStyle: TextStyles.actionPopupButtonLabel.merge(
                  TextStyle(
                      color: store.cameraRunning
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.tertiary),
                ),
                onTap: store.onFlip,
              ),
            ),
            Expanded(
              child: LabeledIconButton(
                label: AppLocalizations.of(context)!.photoPaste,
                icon: ButtonImages.paste,
                iconSize: 30,
                iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
                separation: 5,
                labelStyle: TextStyles.actionPopupButtonLabel.merge(
                    TextStyle(color: Theme.of(context).colorScheme.secondary)),
                onTap: store.onPaste,
              ),
            ),
            Expanded(
              child: LabeledIconButton(
                label: store.flashModeName(store.flashMode, context),
                icon: store.flashModeIcon(store.flashMode),
                iconSize: 30,
                iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
                separation: 5,
                labelStyle: TextStyles.actionPopupButtonLabel.merge(
                  TextStyle(
                      color: store.cameraRunning
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.tertiary),
                ),
                onTap: store.onFlash,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    store.disposeCamera();
    super.dispose();
  }
}
