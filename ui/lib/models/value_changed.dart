import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ValueChangedVm<T> extends Equatable {
  const ValueChangedVm({
    required this.value,
    required this.onChanged,
  });

  final ValueChanged<T>? onChanged;
  final T? value;

  bool get isEnabled => onChanged != null;

  @override
  List<Object?> get props => [value, isEnabled];
}

typedef StringCallback = ValueChangedWithErrorVm<String>;

class ValueChangedWithErrorVm<T> extends ValueChangedVm<T> {
  const ValueChangedWithErrorVm({
    required this.error,
    super.value,
    super.onChanged,
  });

  final String? error;

  bool get isError => error != null;

  @override
  List<Object?> get props => [...super.props, error];
}
