const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { execFileSync } = require('node:child_process');

function makeTempRepo() {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'patch-hermes-'));
  const scriptsDir = path.join(root, 'scripts');
  const hermesDir = path.join(root, 'node_modules', 'react-native', 'sdks', 'hermes-engine');
  const hermesCompilerDir = path.join(root, 'node_modules', 'hermes-compiler', 'hermesc', 'osx-bin');
  const xcodeprojDir = path.join(root, 'ios', 'SMPMVP.xcodeproj');
  const localPodspecDir = path.join(root, 'ios', 'Pods', 'Local Podspecs');
  const targetSupportDir = path.join(root, 'ios', 'Pods', 'Target Support Files', 'Pods-SMPMVP');

  fs.mkdirSync(scriptsDir, { recursive: true });
  fs.mkdirSync(hermesDir, { recursive: true });
  fs.mkdirSync(hermesCompilerDir, { recursive: true });
  fs.mkdirSync(xcodeprojDir, { recursive: true });
  fs.mkdirSync(localPodspecDir, { recursive: true });
  fs.mkdirSync(targetSupportDir, { recursive: true });

  const sourceScript = path.join(__dirname, '..', 'patchHermesPodspecEncoding.js');
  const targetScript = path.join(scriptsDir, 'patchHermesPodspecEncoding.js');
  fs.copyFileSync(sourceScript, targetScript);

  fs.writeFileSync(
    path.join(hermesDir, 'hermes-engine.podspec'),
    `rescue => e
  # Fallback to the parent directory if the above command fails (e.g when building locally in OOT Platform)
  react_native_path = File.join(__dir__, "..", "..")
end
      hermes_compiler_path = File.dirname(Pod::Executable.execute_command('node', ['-p',
        "require.resolve(\\"hermes-compiler\\", {paths: [\\"#{react_native_path}\\"]})", __dir__]).strip
      )
`,
    'utf8'
  );
  fs.writeFileSync(path.join(hermesCompilerDir, 'hermesc'), '', 'utf8');

  fs.writeFileSync(
    path.join(hermesDir, 'hermes-utils.rb'),
    `    if force_build_from_main(react_native_path)
        return HermesEngineSourceType::BUILD_FROM_GITHUB_MAIN
    end

    if release_artifact_exists(version)
`,
    'utf8'
  );

  fs.writeFileSync(
    path.join(xcodeprojDir, 'project.pbxproj'),
    `INFOPLIST_FILE = SMPMVP/Info.plist;
ENABLE_USER_SCRIPT_SANDBOXING = YES;
`,
    'utf8'
  );

  const oldHermesPath = '/Users/im_018/Documents/GitHub/Project/🤩 SMP/smp-ios-mvp/node_modules/hermes-compiler/hermesc/osx-bin/hermesc';
  fs.writeFileSync(
    path.join(localPodspecDir, 'hermes-engine.podspec.json'),
    JSON.stringify(
      {
        user_target_xcconfig: {
          HERMES_CLI_PATH: oldHermesPath,
        },
      },
      null,
      2
    ),
    'utf8'
  );
  fs.writeFileSync(
    path.join(targetSupportDir, 'Pods-SMPMVP.release.xcconfig'),
    `HERMES_CLI_PATH = ${oldHermesPath}\n`,
    'utf8'
  );
  fs.writeFileSync(
    path.join(targetSupportDir, 'Pods-SMPMVP.debug.xcconfig'),
    `HERMES_CLI_PATH = ${oldHermesPath}\n`,
    'utf8'
  );

  return {
    root,
    targetScript,
    projectFile: path.join(xcodeprojDir, 'project.pbxproj'),
    localPodspec: path.join(localPodspecDir, 'hermes-engine.podspec.json'),
    releaseXcconfig: path.join(targetSupportDir, 'Pods-SMPMVP.release.xcconfig'),
    debugXcconfig: path.join(targetSupportDir, 'Pods-SMPMVP.debug.xcconfig'),
  };
}

test('patch script disables Xcode user script sandboxing in the project file', () => {
  const temp = makeTempRepo();

  execFileSync(process.execPath, [temp.targetScript], {
    cwd: temp.root,
    stdio: 'pipe',
  });

  const project = fs.readFileSync(temp.projectFile, 'utf8');
  assert.equal(project.includes('ENABLE_USER_SCRIPT_SANDBOXING = YES;'), false);
  assert.equal(project.includes('ENABLE_USER_SCRIPT_SANDBOXING = NO;'), true);
});

test('patch script rewrites generated Hermes CLI paths to the current repo', () => {
  const temp = makeTempRepo();

  execFileSync(process.execPath, [temp.targetScript], {
    cwd: temp.root,
    stdio: 'pipe',
  });

  const expectedHermesPath = path.join(
    temp.root,
    'node_modules',
    'hermes-compiler',
    'hermesc',
    'osx-bin',
    'hermesc'
  );
  const normalizedExpectedHermesPath = fs.realpathSync(path.dirname(expectedHermesPath));
  const resolvedExpectedHermesPath = path.join(normalizedExpectedHermesPath, 'hermesc');

  const podspec = JSON.parse(fs.readFileSync(temp.localPodspec, 'utf8'));
  const releaseConfig = fs.readFileSync(temp.releaseXcconfig, 'utf8');
  const debugConfig = fs.readFileSync(temp.debugXcconfig, 'utf8');

  assert.equal(podspec.user_target_xcconfig.HERMES_CLI_PATH, resolvedExpectedHermesPath);
  assert.match(releaseConfig, new RegExp(resolvedExpectedHermesPath.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')));
  assert.match(debugConfig, new RegExp(resolvedExpectedHermesPath.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')));
});
