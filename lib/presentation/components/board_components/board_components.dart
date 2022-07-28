// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/task_bloc/task_cubit.dart';
import '../../../bloc/task_bloc/task_states.dart';
import '../../../data/models/tasks_model.dart';
import '../../resources/color_manager.dart';
import '../../resources/styles_manager.dart';
import '../shared/shared_components.dart';


// all tasks
class AllTasks extends StatelessWidget {
  const AllTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<Task> tasks = AppCubit.get(context).allTasks;
        debugPrint("all tasks is here ======> $tasks ");
        return TaskBuilder(tasks: tasks);
      },
    );
  }
}

// completed tasks
class CompletedTasks extends StatelessWidget {
  const CompletedTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          List<Task> tasks = AppCubit.get(context).completed;
          debugPrint("completed tasks ======> $tasks");
          return TaskBuilder(tasks:tasks);
        });
  }
}

// uncompleted tasks
class UnCompletedTasks extends StatelessWidget {
  const UnCompletedTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          List<Task> tasks = AppCubit.get(context).unCompleted;
          debugPrint("un completed tasks ====> $tasks");
          return TaskBuilder(tasks: tasks);
        });
  }
}

// favorite tasks
class FavoritTasks extends StatelessWidget {
  const FavoritTasks({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          List<Task> tasks = AppCubit.get(context).favorite;
          debugPrint("favorite tasks ====> $tasks");
          return TaskBuilder(tasks: tasks);
        });
  }
}

// tab bar
class TabBarWidget extends StatelessWidget {
  TabBarWidget(this.cubit, {Key? key}) : super(key: key);
  AppCubit cubit;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 53,
      child: TabBar(
        labelColor: Colors.black,
        isScrollable: true,
        physics: const ScrollPhysics(),
        unselectedLabelColor: ColorManager.lightGrey,
        unselectedLabelStyle: CustomTextStyles.tabLabesTextStyles,
        tabs: cubit.tabsTitle,
      ),
    );
  }
}
