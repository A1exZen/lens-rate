// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'converter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConverterState {

 String get from; String get to; double get amount;
/// Create a copy of ConverterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConverterStateCopyWith<ConverterState> get copyWith => _$ConverterStateCopyWithImpl<ConverterState>(this as ConverterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConverterState&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,from,to,amount);

@override
String toString() {
  return 'ConverterState(from: $from, to: $to, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $ConverterStateCopyWith<$Res>  {
  factory $ConverterStateCopyWith(ConverterState value, $Res Function(ConverterState) _then) = _$ConverterStateCopyWithImpl;
@useResult
$Res call({
 String from, String to, double amount
});




}
/// @nodoc
class _$ConverterStateCopyWithImpl<$Res>
    implements $ConverterStateCopyWith<$Res> {
  _$ConverterStateCopyWithImpl(this._self, this._then);

  final ConverterState _self;
  final $Res Function(ConverterState) _then;

/// Create a copy of ConverterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,Object? amount = null,}) {
  return _then(_self.copyWith(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ConverterState].
extension ConverterStatePatterns on ConverterState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConverterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConverterState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConverterState value)  $default,){
final _that = this;
switch (_that) {
case _ConverterState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConverterState value)?  $default,){
final _that = this;
switch (_that) {
case _ConverterState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String from,  String to,  double amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConverterState() when $default != null:
return $default(_that.from,_that.to,_that.amount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String from,  String to,  double amount)  $default,) {final _that = this;
switch (_that) {
case _ConverterState():
return $default(_that.from,_that.to,_that.amount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String from,  String to,  double amount)?  $default,) {final _that = this;
switch (_that) {
case _ConverterState() when $default != null:
return $default(_that.from,_that.to,_that.amount);case _:
  return null;

}
}

}

/// @nodoc


class _ConverterState implements ConverterState {
  const _ConverterState({required this.from, required this.to, this.amount = 0});
  

@override final  String from;
@override final  String to;
@override@JsonKey() final  double amount;

/// Create a copy of ConverterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConverterStateCopyWith<_ConverterState> get copyWith => __$ConverterStateCopyWithImpl<_ConverterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConverterState&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,from,to,amount);

@override
String toString() {
  return 'ConverterState(from: $from, to: $to, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$ConverterStateCopyWith<$Res> implements $ConverterStateCopyWith<$Res> {
  factory _$ConverterStateCopyWith(_ConverterState value, $Res Function(_ConverterState) _then) = __$ConverterStateCopyWithImpl;
@override @useResult
$Res call({
 String from, String to, double amount
});




}
/// @nodoc
class __$ConverterStateCopyWithImpl<$Res>
    implements _$ConverterStateCopyWith<$Res> {
  __$ConverterStateCopyWithImpl(this._self, this._then);

  final _ConverterState _self;
  final $Res Function(_ConverterState) _then;

/// Create a copy of ConverterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? amount = null,}) {
  return _then(_ConverterState(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
