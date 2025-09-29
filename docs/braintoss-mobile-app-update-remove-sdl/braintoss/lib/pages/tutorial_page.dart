import 'package:braintoss/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:braintoss/pages/stateful_page.dart';
import 'package:braintoss/stores/tutorial_store.dart';
import 'package:braintoss/widgets/atoms/tutorial_next_button.dart';

class TutorialPage extends StatefulPage<TutorialStore> {
  const TutorialPage({super.key});

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends StatefulPageState<TutorialStore> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
        store.setContext(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _tutorialAppBar(),
        body: _pageContent(),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
    );
  }

  Widget _pageContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _tutorialCarousel()),  // Use Expanded instead of Flexible
        _tutorialNextButton(),
      ],
    );
  }

  PreferredSizeWidget _tutorialAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      iconTheme: const IconThemeData(color: ThemeColors.white),
      centerTitle: true,
      title: Observer(
        builder: (context) => Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            store.headerTitle,
            style: const TextStyle(
              fontSize: 40,
              color: ThemeColors.primaryYellowDarker,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }


  Widget _tutorialCarousel() {
    return Observer(
      builder: (_) => PageView.builder(
        controller: pageController,  // Using PageController to handle page navigation
        physics: store.isCarouselSwipeDisabled
            ? const NeverScrollableScrollPhysics()
            : const ScrollPhysics(),
        itemCount: store.getCarouselWidgets(context).length,
        onPageChanged: (index) {
          store.setCurrentCarouselIndex(index);
        },
        itemBuilder: (context, index) {
          return store.getCarouselWidgets(context)[index];
        },
      ),
    );
  }

  Widget _tutorialNextButton() {
    return Observer(
      builder: (_) => Visibility(
        visible: store.isButtonVisible(context),
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: TutorialNextButton(
            navigationFunction: () => store.handleNextButton(pageController),
          ),
        ),
      ),
    );
  }
  
  }
