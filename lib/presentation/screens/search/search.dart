// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:todotasks/bloc/task_bloc/task_states.dart';
import 'package:todotasks/presentation/components/shared/shared_components.dart';
import 'package:todotasks/presentation/resources/color_manager.dart';
import 'package:todotasks/presentation/resources/string_manager.dart';

import '../../../bloc/task_bloc/task_cubit.dart';
import '../../resources/assets_manager.dart';
import '../schedule/schedule.dart';

// SEARCH PAGE
class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
              body: SafeArea(
            child: Column(
              children: [
                PagesHeader(
                    leftPadding: 0,
                    rightPadding: 0,
                    icon: Icons.arrow_back_ios,
                    onPressed: () => Navigator.of(context).pop(),
                    isthereBackIcon: true,
                    isthereActionIcon: false,
                    head: StringManager.search),
                CustomDivider(topPadding: 0, bottomPadding: 0),
                SearchInputFeald(
                    cubit: cubit, searchController: searchController),
                BodyOfSearchPage(cubit: cubit),
              ],
            ),
          ));
        });
  }
}

// FIELD OF SEARCH
class SearchInputFeald extends StatelessWidget {
  AppCubit cubit;
  TextEditingController searchController;
  SearchInputFeald(
      {required this.searchController, required this.cubit, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: InputField(
        readOnly: false,
        controller: searchController,
        hintText: StringManager.searchInputHintTxt,
        label: StringManager.search,
        widget: IconButton(
            onPressed: () {
              cubit.setSearchList(searchController.text);
              debugPrint(cubit.searchList.toList().toString());
            },
            icon: const Icon(Icons.search_sharp)),
      ),
    );
  }
}

// BODY OF SEARCH
class BodyOfSearchPage extends StatelessWidget {
  const BodyOfSearchPage({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  final AppCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .7,
        child: ConditionalBuilder(
          builder: (context) => ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
                  SearchItem(cubit: cubit, index: index),
              itemCount: cubit.searchList.length),
          fallback: (BuildContext context) => const CallBackItem(),
          condition: cubit.searchList.isNotEmpty,
        ),
      ),
    );
  }
}

// CALLBACK ITEM
class CallBackItem extends StatelessWidget {
  const CallBackItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Center(
      child: Container(
          decoration: BoxDecoration(
              color: ColorManager.lightGrey,
              borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.only(bottom: 150),
          height: 300,
          child: Lottie.asset(
            AssetsManaging.searchIcone,
          )),
    ));
  }
}

// SEARCH ITEM
class SearchItem extends StatelessWidget {
  const SearchItem({Key? key, required this.cubit, required this.index})
      : super(key: key);

  final AppCubit cubit;
  final int index;
  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 1500),
      child: SlideAnimation(
        horizontalOffset: 300,
        verticalOffset: 300,
        child: FadeInAnimation(
            curve: Curves.easeInOutCirc,
            child: ScheduleCardItem(cubit.searchList[index], index)),
      ),
    );
  }
}
