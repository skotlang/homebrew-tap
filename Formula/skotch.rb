class Skotch < Formula
  desc "Command-line interface for skotch — produces the `skotch` binary"
  homepage "https://github.com/skotlang/skotch"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/skotlang/skotch/releases/download/v0.1.5/skotch-cli-aarch64-apple-darwin.zip"
      sha256 "16bb6372e043baf24ca9640305c1b8d59e212789761d3e3672b4127f340a0db2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/skotlang/skotch/releases/download/v0.1.5/skotch-cli-x86_64-apple-darwin.zip"
      sha256 "f8bb067c9871dce21533658f85947738c10bcd765c1287cb1aeede183d8eabd3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/skotlang/skotch/releases/download/v0.1.5/skotch-cli-aarch64-unknown-linux-musl.zip"
      sha256 "daade28edb9694edc68ee90d3b4d0d2b2ce21b457b850b25703dbe6497656c8f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/skotlang/skotch/releases/download/v0.1.5/skotch-cli-x86_64-unknown-linux-musl.zip"
      sha256 "8ab3ea77d548d938f1a205858cae88fdd19062a25cef87c11d922405ef2c4c0a"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {
      "skotch-cli": [
        "skotch",
      ],
    },
    "aarch64-unknown-linux-gnu":          {
      "skotch-cli": [
        "skotch",
      ],
    },
    "aarch64-unknown-linux-musl-dynamic": {
      "skotch-cli": [
        "skotch",
      ],
    },
    "aarch64-unknown-linux-musl-static":  {
      "skotch-cli": [
        "skotch",
      ],
    },
    "x86_64-apple-darwin":                {
      "skotch-cli": [
        "skotch",
      ],
    },
    "x86_64-pc-windows-gnu":              {
      "skotch-cli.exe": [
        "skotch.exe",
      ],
    },
    "x86_64-unknown-linux-gnu":           {
      "skotch-cli": [
        "skotch",
      ],
    },
    "x86_64-unknown-linux-musl-dynamic":  {
      "skotch-cli": [
        "skotch",
      ],
    },
    "x86_64-unknown-linux-musl-static":   {
      "skotch-cli": [
        "skotch",
      ],
    },
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "skotch" if OS.mac? && Hardware::CPU.arm?
    bin.install "skotch" if OS.mac? && Hardware::CPU.intel?
    bin.install "skotch" if OS.linux? && Hardware::CPU.arm?
    bin.install "skotch" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
