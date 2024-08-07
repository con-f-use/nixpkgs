{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  rustPlatform,
  cffi,

  # native dependencies
  libiconv,

  # tests
  numpy,
  psutil,
  pytestCheckHook,
  python-dateutil,
  pytz,
  xxhash,
  python,

  # for passthru.tests
  falcon,
  fastapi,
  gradio,
  mashumaro,
  ufolib2,
}:

buildPythonPackage rec {
  pname = "orjson";
  version = "3.10.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ijl";
    repo = "orjson";
    rev = "refs/tags/${version}";
    hash = "sha256-Q2zi3mNgCFrg7Ucana0+lmR9C9kkuUidEJj8GneR2W4=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-yhLKw4BhdIHgcu4iVlXQlHk/8J+3NK6LlmSWbm/5y4Q=";
  };

  maturinBuildFlags = [ "--interpreter ${python.executable}" ];

  nativeBuildInputs =
    [ cffi ]
    ++ (with rustPlatform; [
      cargoSetupHook
      maturinBuildHook
    ]);

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  nativeCheckInputs = [
    numpy
    psutil
    pytestCheckHook
    python-dateutil
    pytz
    xxhash
  ];

  pythonImportsCheck = [ "orjson" ];

  passthru.tests = {
    inherit
      falcon
      fastapi
      gradio
      mashumaro
      ufolib2
      ;
  };

  meta = with lib; {
    description = "Fast, correct Python JSON library supporting dataclasses, datetimes, and numpy";
    homepage = "https://github.com/ijl/orjson";
    changelog = "https://github.com/ijl/orjson/blob/${version}/CHANGELOG.md";
    license = with licenses; [
      asl20
      mit
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ misuzu ];
  };
}
