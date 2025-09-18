import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeNavBarTapped extends HomeEvent {
  final int index;
  const HomeNavBarTapped(this.index);

  @override
  List<Object?> get props => [index];
}

class HomeShowRiskEventsSection extends HomeEvent {}

class HomeCheckAndShowTutorial extends HomeEvent {}