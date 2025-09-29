import 'package:braintoss/stores/history_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:braintoss/pages/stateful_page.dart';
import 'package:braintoss/models/capture_model.dart';
import 'package:braintoss/widgets/molecules/main_header.dart';
import 'package:braintoss/widgets/molecules/capture_list_item.dart';
import 'package:braintoss/constants/app_constants.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HistoryPage extends StatefulPage<HistoryStore> {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends StatefulPageState<HistoryStore> {
  @override
  void initState() {
    super.initState();
    store.setContext(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: MainHeader(
          action: store.onGoBack,
          headingText: AppLocalizations.of(context)!.history,
          actionIcon: ButtonImages.back),
      body: _buildPageContent(context),
    );
  }

  Widget _buildPageContent(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Observer(
              builder: (_) => Visibility(
                    visible: store.updating,
                    child: const LinearProgressIndicator(),
                  )),
          _captureList(),
          _bottomBar()
        ],
      ),
    );
  }

  Widget _captureList() {
    return Observer(
      builder: (_) {
        return Flexible(
          child: Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            child: RefreshIndicator(
              onRefresh: store.updateHistoryOnRefresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  ...store.captureList.map(_captureListItem),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _captureListItem(Capture captureModel) {
    return CaptureListItem(
      captureModel: captureModel,
      onPress: () => store.navigateTo(captureModel),
      dividerType: DividerType.history,
    );
  }

  Widget _bottomBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          const Divider(),
          _deleteHistory(),
          const Divider(),
          _bottomLegend()
        ],
      ),
    );
  }

  Widget _deleteHistory() {
    return GestureDetector(
      onTap: store.showDeleteHistoryPopup,
      child: SizedBox(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.deleteHistory),
            const Icon(Icons.chevron_right)
          ],
        ),
      ),
    );
  }

  Widget _bottomLegend() {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _bottomLegendItem(AppLocalizations.of(context)!.historyLegendSent,
              HistoryIcons.check),
          _bottomLegendItem(AppLocalizations.of(context)!.historyLegendQueued,
              HistoryIcons.queued),
          _bottomLegendItem(AppLocalizations.of(context)!.historyHistoryFailed,
              HistoryIcons.failed),
          _bottomLegendItem(AppLocalizations.of(context)!.historyLegendShared,
              HistoryIcons.shared),
        ],
      ),
    );
  }

  Widget _bottomLegendItem(String text, String imageAsset) {
    return Row(
      children: [
        Text(text),
        const SizedBox(width: 5),
        Image.asset(imageAsset),
      ],
    );
  }
}
