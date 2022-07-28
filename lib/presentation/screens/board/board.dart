// ignore_for_file: avoid_unnecessary_containers, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todotasks/bloc/task_bloc/task_cubit.dart';
import 'package:todotasks/presentation/resources/app_values.dart';
import 'package:todotasks/presentation/resources/color_manager.dart';
import 'package:todotasks/presentation/resources/routes_manager.dart';

import '../../../bloc/task_bloc/task_states.dart';
import '../../components/board_components/board_components.dart';
import '../../components/shared/shared_components.dart';

import '../../resources/constants_manager.dart';
import '../../resources/string_manager.dart';

//BOARD SCREEN
class Board extends StatelessWidget {
  const Board({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ConstatsManager.tabListSize,
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (ctx, state) {},
          builder: (ctx, state) {
            AppCubit cubit = AppCubit();
            return Scaffold(
              backgroundColor: ColorManager.mainWight,
              body: Padding(
                padding: PaddingManagment.bodyPaddingForBoardScreen,
                child: Column(
                  children: [
                    // Head of page
                    const BoardPageHeader(),
                    // divider
                    CustomDivider(bottomPadding: 0, topPadding: 0),
                    // tabBar
                    TabBarWidget(cubit),
                    // divider
                    CustomDivider(bottomPadding: 0, topPadding: 0),
                    // body of tabs
                    const BoardPageBody(),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

// BOARD HEADER
class BoardPageHeader extends StatelessWidget {
  const BoardPageHeader({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PagesHeader(
      leftPadding: 0,
      rightPadding: 0,
      icon: Icons.settings_applications,
      onPressed: () {},
      head: StringManager.board,
      isthereBackIcon: false,
      color: ColorManager.mainWight,
      isthereActionIcon: true,
    );
  }
}

// BOARD BODY
class BoardPageBody extends StatelessWidget {
  const BoardPageBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: const [
          SizedBox(
            child: TabBarView(
              physics: BouncingScrollPhysics(),
              children: [
                // all
                AllTasks(),
                // compeleted
                CompletedTasks(),
                // uncompeleted
                UnCompletedTasks(),
                // favorite
                FavoritTasks(),
              ],
            ),
          ),
          // GO TO ADD TASK PAGE
          AddTaskButtonNavigat(),
        ],
      ),
    );
  }
}

// ADD task Button
class AddTaskButtonNavigat extends StatelessWidget {
  const AddTaskButtonNavigat({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit cupetes = AppCubit.get(context);
    return Positioned(
      height: AppHieghtes.height48,
      child: MyButton(
        label: StringManager.addTask,
        onTap: () {
          Navigator.pushNamed(context, Routes.addTaskRoute);
          cupetes.setCreateOrUpdateTask("Add");
        },
      ),
    );
  }
}
