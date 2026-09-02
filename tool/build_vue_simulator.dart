// Builds the Vue simulator from the vue/ submodule into vue/dist/, which
// pubspec.yaml ships as an asset directory. Run it once after cloning, and
// again after updating the submodule.
//
// Usage:  dart run tool/build_vue_simulator.dart [path-to-cv-frontend-vue]

import 'dart:io';

const simVersion = 'v0';

void main(List<String> args) async {
  final appRoot = File.fromUri(Platform.script).parent.parent.path;
  final vueDir = args.isNotEmpty ? args.first : p(appRoot, 'vue');

  if (!File(p(vueDir, 'package.json')).existsSync()) {
    fail(
      'cv-frontend-vue submodule is not checked out at $vueDir\n'
      'run: git submodule update --init --recursive',
    );
  }

  if (!Directory(p(vueDir, 'node_modules')).existsSync()) {
    stdout.writeln('==> installing npm dependencies');
    await run('npm', ['ci', '--no-audit', '--no-fund'], vueDir);
  }

  // VITE_BASE=/ because we serve the bundle from the server root. The upstream
  // default points at /simulatorvue/v1/, and a relative base breaks the fonts:
  // the CSS is injected into <style> tags, where url(./font) resolves against
  // the page instead of /assets.
  stdout.writeln('==> building simulator $simVersion');
  await run(
    'npx',
    ['vite', 'build'],
    vueDir,
    {'VITE_SIM_VERSION': simVersion, 'VITE_BASE': '/'},
  );

  final buildOut = p(vueDir, 'dist/simulatorvue/$simVersion');

  // v0 has no bundled yosys: it synthesises Verilog through
  // /api/v1/simulator/verilogcv, which the app's server proxies.

  // index.html loads jQuery from a CDN, which is no use offline. Dropping the
  // tag is not an option either: parts of the bundle read the global $ before
  // globalVariables.ts sets it, and the page comes up blank.
  stdout.writeln('==> vendoring jQuery');
  File(
    p(vueDir, 'node_modules/jquery/dist/jquery.min.js'),
  ).copySync(p(buildOut, 'jquery.min.js'));

  stdout.writeln('==> patching index.html');
  final indexFile = File(p(buildOut, 'index.html'));
  final html = indexFile
      .readAsStringSync()
      .replaceAll(
        RegExp(r'<script src="https://ajax\.googleapis\.com[^"]*"></script>'),
        '<script src="/jquery.min.js"></script>',
      )
      .replaceAll(RegExp(r'\s*<link rel="icon"[^>]*>'), '');
  indexFile.writeAsStringSync(html);

  if (!html.contains('/jquery.min.js')) {
    fail('index.html no longer references jQuery -- upstream changed the tag');
  }

  // Flutter fingerprints the files it resolved last time, so a rebuilt bundle
  // can be ignored. Touching pubspec.yaml forces a rescan.
  File(p(appRoot, 'pubspec.yaml')).setLastModifiedSync(DateTime.now());

  stdout.writeln('==> done: ${sizeOf(buildOut)} in $buildOut');
}

/// Joins a '/'-separated path onto [base] using the platform separator.
String p(String base, String rest) =>
    '$base${Platform.pathSeparator}'
    '${rest.replaceAll('/', Platform.pathSeparator)}';

Future<void> run(
  String cmd,
  List<String> args,
  String cwd, [
  Map<String, String> env = const {},
]) async {
  final result = await Process.run(
    cmd,
    args,
    workingDirectory: cwd,
    environment: env,
    // npm and npx are batch files on Windows.
    runInShell: true,
  );
  stdout.write(result.stdout);
  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    fail('$cmd ${args.join(' ')} failed');
  }
}

String sizeOf(String dir) {
  var bytes = 0;
  for (final f in Directory(dir).listSync(recursive: true)) {
    if (f is File) bytes += f.lengthSync();
  }
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}M';
}

Never fail(String message) {
  stderr.writeln(message);
  exit(1);
}
