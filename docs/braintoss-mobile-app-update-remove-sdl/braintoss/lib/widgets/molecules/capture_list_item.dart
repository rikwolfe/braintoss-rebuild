import 'package:flutter/material.dart';

import 'package:braintoss/models/capture_model.dart';

import 'package:braintoss/constants/colors.dart';
import 'package:braintoss/constants/app_constants.dart';

import 'package:braintoss/utils/functions/date_time_helper.dart';

import '../../models/capture_type.dart';

enum DividerType { history, voicePreview }

class CaptureListItem extends StatefulWidget {
  final Capture captureModel;
  final void Function() onPress;
  final DividerType? dividerType;
  const CaptureListItem(
      {super.key,
      required this.captureModel,
      required this.onPress,
      this.dividerType});

  @override
  CaptureListItemState createState() {
    return CaptureListItemState();
  }
}

class CaptureListItemState extends State<CaptureListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onPress(),
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    height: 30,
                    child: Center(
                      child: Stack(
                        children: [
                          Center(
                            child: Image.asset(
                              getCaptureTypeIcon(
                                  widget.captureModel.captureType),
                              color: Theme.of(context).colorScheme.brightness ==
                                      Brightness.light
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          Visibility(
                            visible: widget.captureModel.shared,
                            child: Center(
                              child: Image.asset(
                                  Theme.of(context).colorScheme.brightness ==
                                          Brightness.light
                                      ? HistoryIcons.sharedOverlay
                                      : HistoryIcons.sharedDarkOverlay),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  getCaptureStatusIcon(widget.captureModel.captureStatus),
                  const SizedBox(width: 15),
                  Visibility(
                    visible: widget.captureModel.statusCode != null &&
                        widget.captureModel.statusCode != 0 &&
                        widget.captureModel.captureStatus != CaptureStatus.sent,
                    child: Text(
                      widget.captureModel.statusCode.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: widget.captureModel.captureStatus ==
                                  CaptureStatus.queue
                              ? ThemeColors.primaryYellowDarker
                              : ThemeColors.error),
                    ),
                  ),
                  const Spacer(),
                  Text(
                      getFormattedDate(
                          widget.captureModel.captureDate, context),
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    alignment: AlignmentDirectional.centerEnd,
                    width: 60,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.center,
                      child: Text(
                        getFormattedTime(
                            widget.captureModel.captureDate, context),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            setDividerType(widget.dividerType),
          ],
        ),
      ),
    );
  }

  Widget setDividerType(DividerType? dividerType) {
    if (dividerType == null) return const SizedBox.shrink();
    switch (dividerType) {
      case DividerType.history:
        return const Divider(
          height: 1,
          color: ThemeColors.grayDarker,
        );

      case DividerType.voicePreview:
        return const Divider(
          height: 1,
          color: ThemeColors.gray,
        );
    }
  }

  String getCaptureTypeIcon(CaptureType type) {
    switch (type) {
      case CaptureType.note:
        return HistoryIcons.note;
      case CaptureType.photo:
        return HistoryIcons.camera;
      case CaptureType.voice:
        return HistoryIcons.microphone;
      case CaptureType.voiceWatch:
        return HistoryIcons.watch;
    }
  }

  Image getCaptureStatusIcon(CaptureStatus status) {
    switch (status) {
      case CaptureStatus.sent:
        return Image.asset(HistoryIcons.check);
      case CaptureStatus.queue:
        return Image.asset(HistoryIcons.queued);
      case CaptureStatus.fail:
        return Image.asset(HistoryIcons.failed);
    }
  }
}
