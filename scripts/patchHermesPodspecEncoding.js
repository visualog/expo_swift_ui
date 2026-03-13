const fs = require('fs');
const path = require('path');

const podspecTarget = path.join(
  __dirname,
  '..',
  'node_modules',
  'react-native',
  'sdks',
  'hermes-engine',
  'hermes-engine.podspec'
);

const utilsTarget = path.join(
  __dirname,
  '..',
  'node_modules',
  'react-native',
  'sdks',
  'hermes-engine',
  'hermes-utils.rb'
);

const xcodeProjectTarget = path.join(
  __dirname,
  '..',
  'ios',
  'SMPMVP.xcodeproj',
  'project.pbxproj'
);
const generatedHermesPodspecTarget = path.join(
  __dirname,
  '..',
  'ios',
  'Pods',
  'Local Podspecs',
  'hermes-engine.podspec.json'
);
const generatedPodsConfigTargets = [
  path.join(
    __dirname,
    '..',
    'ios',
    'Pods',
    'Target Support Files',
    'Pods-SMPMVP',
    'Pods-SMPMVP.debug.xcconfig'
  ),
  path.join(
    __dirname,
    '..',
    'ios',
    'Pods',
    'Target Support Files',
    'Pods-SMPMVP',
    'Pods-SMPMVP.release.xcconfig'
  ),
];

const expectedHermesCliPath = path.join(
  __dirname,
  '..',
  'node_modules',
  'hermes-compiler',
  'hermesc',
  'osx-bin',
  'hermesc'
);

let changed = false;

if (fs.existsSync(podspecTarget)) {
  let content = fs.readFileSync(podspecTarget, 'utf8');
  const reactNativePathNeedle = `rescue => e
  # Fallback to the parent directory if the above command fails (e.g when building locally in OOT Platform)
  react_native_path = File.join(__dir__, "..", "..")
end`;

  const reactNativePathPatch = `${reactNativePathNeedle}
react_native_path = react_native_path.to_s.dup.force_encoding(Encoding::UTF_8)
react_native_path = react_native_path.encode(Encoding::UTF_8, invalid: :replace, undef: :replace) unless react_native_path.valid_encoding?`;

  const compilerPathNeedle = `      hermes_compiler_path = File.dirname(Pod::Executable.execute_command('node', ['-p',
        "require.resolve(\\"hermes-compiler\\", {paths: [\\"#{react_native_path}\\"]})", __dir__]).strip
      )`;

  const compilerPathPatch = `${compilerPathNeedle}
      hermes_compiler_path = hermes_compiler_path.to_s.dup.force_encoding(Encoding::UTF_8)
      hermes_compiler_path = hermes_compiler_path.encode(Encoding::UTF_8, invalid: :replace, undef: :replace) unless hermes_compiler_path.valid_encoding?`;

  if (
    !content.includes('react_native_path = react_native_path.to_s.dup.force_encoding(Encoding::UTF_8)') &&
    content.includes(reactNativePathNeedle) &&
    content.includes(compilerPathNeedle)
  ) {
    content = content.replace(reactNativePathNeedle, reactNativePathPatch);
    content = content.replace(compilerPathNeedle, compilerPathPatch);
    fs.writeFileSync(podspecTarget, content, 'utf8');
    changed = true;
    console.log('[patchHermesPodspecEncoding] Patched hermes-engine.podspec.');
  } else {
    console.log('[patchHermesPodspecEncoding] hermes-engine.podspec already patched or not patchable.');
  }
} else {
  console.log('[patchHermesPodspecEncoding] hermes-engine.podspec not found.');
}

if (fs.existsSync(utilsTarget)) {
  let utils = fs.readFileSync(utilsTarget, 'utf8');
  const sourceTypeNeedle = `    if force_build_from_main(react_native_path)
        return HermesEngineSourceType::BUILD_FROM_GITHUB_MAIN
    end

    if release_artifact_exists(version)`;
  const sourceTypePatch = `    if force_build_from_main(react_native_path)
        return HermesEngineSourceType::BUILD_FROM_GITHUB_MAIN
    end

    if ENV['HERMES_FORCE_RELEASE_PREBUILT'] == '1'
        return HermesEngineSourceType::DOWNLOAD_PREBUILD_RELEASE_TARBALL
    end

    if release_artifact_exists(version)`;

  if (
    !utils.includes("ENV['HERMES_FORCE_RELEASE_PREBUILT'] == '1'") &&
    utils.includes(sourceTypeNeedle)
  ) {
    utils = utils.replace(sourceTypeNeedle, sourceTypePatch);
    fs.writeFileSync(utilsTarget, utils, 'utf8');
    changed = true;
    console.log('[patchHermesPodspecEncoding] Patched hermes-utils.rb.');
  } else {
    console.log('[patchHermesPodspecEncoding] hermes-utils.rb already patched or not patchable.');
  }
} else {
  console.log('[patchHermesPodspecEncoding] hermes-utils.rb not found.');
}

if (fs.existsSync(xcodeProjectTarget)) {
  let project = fs.readFileSync(xcodeProjectTarget, 'utf8');
  const sandboxNeedle = 'ENABLE_USER_SCRIPT_SANDBOXING = YES;';
  const sandboxPatch = 'ENABLE_USER_SCRIPT_SANDBOXING = NO;';
  const infoPlistNeedle = 'INFOPLIST_FILE = SMPMVP/Info.plist;';
  const infoPlistPatch = `${infoPlistNeedle}
\t\t\t\tENABLE_USER_SCRIPT_SANDBOXING = NO;`;

  if (project.includes(sandboxNeedle)) {
    project = project.replaceAll(sandboxNeedle, sandboxPatch);
    fs.writeFileSync(xcodeProjectTarget, project, 'utf8');
    changed = true;
    console.log('[patchHermesPodspecEncoding] Disabled user script sandboxing in Xcode project.');
  } else if (!project.includes(sandboxPatch) && project.includes(infoPlistNeedle)) {
    project = project.replaceAll(infoPlistNeedle, infoPlistPatch);
    fs.writeFileSync(xcodeProjectTarget, project, 'utf8');
    changed = true;
    console.log('[patchHermesPodspecEncoding] Added user script sandboxing override to Xcode project.');
  } else {
    console.log('[patchHermesPodspecEncoding] Xcode project sandboxing already patched or not patchable.');
  }
} else {
  console.log('[patchHermesPodspecEncoding] Xcode project not found.');
}

if (fs.existsSync(generatedHermesPodspecTarget)) {
  const podspec = JSON.parse(fs.readFileSync(generatedHermesPodspecTarget, 'utf8'));
  const currentPath = podspec.user_target_xcconfig?.HERMES_CLI_PATH;

  if (currentPath && currentPath !== expectedHermesCliPath) {
    podspec.user_target_xcconfig.HERMES_CLI_PATH = expectedHermesCliPath;
    fs.writeFileSync(generatedHermesPodspecTarget, JSON.stringify(podspec, null, 2) + '\n', 'utf8');
    changed = true;
    console.log('[patchHermesPodspecEncoding] Rewrote generated hermes-engine.podspec.json HERMES_CLI_PATH.');
  } else {
    console.log('[patchHermesPodspecEncoding] Generated hermes-engine.podspec.json already uses the current HERMES_CLI_PATH or is missing it.');
  }
} else {
  console.log('[patchHermesPodspecEncoding] Generated hermes-engine.podspec.json not found.');
}

for (const configTarget of generatedPodsConfigTargets) {
  if (!fs.existsSync(configTarget)) {
    console.log(`[patchHermesPodspecEncoding] Generated Pods xcconfig not found: ${path.basename(configTarget)}`);
    continue;
  }

  let config = fs.readFileSync(configTarget, 'utf8');
  const nextConfig = config.replace(
    /^HERMES_CLI_PATH = .+$/m,
    `HERMES_CLI_PATH = ${expectedHermesCliPath}`
  );

  if (nextConfig !== config) {
    fs.writeFileSync(configTarget, nextConfig, 'utf8');
    changed = true;
    console.log(`[patchHermesPodspecEncoding] Rewrote ${path.basename(configTarget)} HERMES_CLI_PATH.`);
  } else {
    console.log(`[patchHermesPodspecEncoding] ${path.basename(configTarget)} already uses the current HERMES_CLI_PATH or is missing it.`);
  }
}

if (!changed) {
  console.log('[patchHermesPodspecEncoding] No changes needed.');
}
