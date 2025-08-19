// @dart=3.6
// ignore_for_file: directives_ordering
// build_runner >=2.4.16
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:build_runner_core/build_runner_core.dart' as _i1;
import 'package:source_gen/builder.dart' as _i2;
import 'package:objectbox_generator/objectbox_generator.dart' as _i3;
import 'package:build_test/builder.dart' as _i4;
import 'package:build_config/build_config.dart' as _i5;
import 'dart:isolate' as _i6;
import 'package:build_runner/src/build_script_generate/build_process_state.dart'
    as _i7;
import 'package:build_runner/build_runner.dart' as _i8;
import 'dart:io' as _i9;

final _builders = <_i1.BuilderApplication>[
  _i1.apply(
    r'source_gen:combining_builder',
    [_i2.combiningBuilder],
    _i1.toNoneByDefault(),
    hideOutput: false,
    appliesBuilders: const [r'source_gen:part_cleanup'],
  ),
  _i1.apply(
    r'objectbox_generator:resolver',
    [_i3.entityResolverFactory],
    _i1.toDependentsOf(r'objectbox_generator'),
    hideOutput: true,
  ),
  _i1.apply(
    r'objectbox_generator:generator',
    [_i3.codeGeneratorFactory],
    _i1.toDependentsOf(r'objectbox_generator'),
    hideOutput: false,
  ),
  _i1.apply(
    r'build_test:test_bootstrap',
    [
      _i4.debugIndexBuilder,
      _i4.debugTestBuilder,
      _i4.testBootstrapBuilder,
    ],
    _i1.toRoot(),
    hideOutput: true,
    defaultGenerateFor: const _i5.InputSet(include: [
      r'$package$',
      r'test/**',
    ]),
  ),
  _i1.applyPostProcess(
    r'source_gen:part_cleanup',
    _i2.partCleanup,
  ),
];
void main(
  List<String> args, [
  _i6.SendPort? sendPort,
]) async {
  await _i7.buildProcessState.receive(sendPort);
  _i7.buildProcessState.isolateExitCode = await _i8.run(
    args,
    _builders,
  );
  _i9.exitCode = _i7.buildProcessState.isolateExitCode!;
  await _i7.buildProcessState.send(sendPort);
}
