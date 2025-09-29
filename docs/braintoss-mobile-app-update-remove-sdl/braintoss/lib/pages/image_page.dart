import 'dart:ui';

import 'package:braintoss/constants/colors.dart';
import 'package:braintoss/pages/stateless_page.dart';
import 'package:braintoss/services/interfaces/capture_service.dart';
import 'package:braintoss/stores/image_store.dart';
import 'package:braintoss/widgets/molecules/actions_popup.dart';
import 'package:braintoss/widgets/molecules/send_popup.dart';
import 'package:braintoss/widgets/atoms/textual_multiple_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:seafarer/seafarer.dart';
import '../config/theme.dart';
import '../constants/app_constants.dart';
import '../routes.dart';
import '../widgets/atoms/bubble_button.dart';
import '../widgets/molecules/main_header.dart';

class ImagePageArgs extends BaseStoreArguments {
  List<String> filePaths;
  ImageSource source;
  ImagePageArgs(this.filePaths, this.source);
}

class ImagePage extends StatelessPage<ImageStore> {
  ImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainHeader(
        action: store.onGoBack,
        headingText: AppLocalizations.of(context)!.imagesHeader,
        actionIcon: ButtonImages.closeScreen,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _buildPageContent(context),
    );
  }

  Widget _buildPageContent(BuildContext context) {
    final args = Seafarer.args<ImagePageArgs>(context);
    store.setImages(args!.filePaths, args.source);
    store.setContext(context);
    return Stack(
      children: [
        //Image
        store.images.length > 1
            ? GridView.count(
                scrollDirection: Axis.vertical,
                crossAxisCount: store.images.length > 2 ? 3 : 2,
                children: store.images.map((image) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Observer(
                        builder: (_) {
                          switch (args.source) {
                            case ImageSource.camera:
                              break;
                            case ImageSource.album:
                              return Image.file(image);
                            case ImageSource.share:
                              return Image.file(image);
                            case ImageSource.download:
                              return Image.network(image.path);
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                  );
                }).toList(),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Observer(
                    builder: (_) {
                      switch (args.source) {
                        case ImageSource.camera:
                          break;
                        case ImageSource.album:
                          return Image.file(store.images.first);
                        case ImageSource.share:
                          return Image.file(store.images.first);
                        case ImageSource.download:
                          return Image.network(store.images.first.path);
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
        //Send button
        Align(
          alignment: Alignment.bottomCenter,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                  child: Observer(
                    builder: (_) {
                      return AnimatedOpacity(
                        opacity: store.actionPopupVisible ? 0 : 1,
                        duration: quickTransition,
                        child: BubbleButton(
                          imagePath: ButtonImages.send,
                          diameter: 85,
                          onLongPress: store.onLongPressSend,
                          onTap: store.onTapSend,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
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
                    onOutsideTap: store.closeActionPopup,
                    backgroundColor: ThemeColors.white.withOpacity(0.85),
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
                    onTapOutside: store.closeLongPressSendList,
                    child: _buildEmailList(
                      store.onEmailSelectionFromLongPressSend,
                    )),
              ),
            );
          },
        ),
        //Action button
        if (store.emails.length > 1)
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
              child: SizedBox(
                width: 85,
                height: 85,
                child: Center(
                  child: Observer(builder: (_) {
                    return AnimatedCrossFade(
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
                        imageColor: Theme.of(context).colorScheme.onSecondary,
                      ),
                      duration: quickTransition,
                    );
                  }),
                ),
              ),
            ),
          ),
        //Success overlay
        Observer(builder: (_) {
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
                              child: Image.asset(MiscImages.success,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          );
        })
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
      ],
    );
  }
}
