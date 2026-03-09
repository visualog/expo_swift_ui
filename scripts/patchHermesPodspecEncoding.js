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

if (!changed) {
  console.log('[patchHermesPodspecEncoding] No changes needed.');
}
