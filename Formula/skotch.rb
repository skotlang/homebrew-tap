class Skotch < Formula
  desc "Command-line interface for skotch — produces the `skotch` binary"
  homepage "https://github.com/skotlang/skotch"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/skotlang/skotch/releases/download/v0.7.1/skotch-cli-aarch64-apple-darwin.zip"
      sha256 "9f9cc4a9991c5ba8b972e3ee61b0fd1abe816ef94d34c4a8c28e74a98c4a58e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/skotlang/skotch/releases/download/v0.7.1/skotch-cli-x86_64-apple-darwin.zip"
      sha256 "f068dc1ca7c8e79bcac07e723f57b8c8e6e5286176382d25c85d15aa3694fc7d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/skotlang/skotch/releases/download/v0.7.1/skotch-cli-aarch64-unknown-linux-musl.zip"
      sha256 "8a7c4d7ce02c5c7ab5d6e179c93c4061df49f54250bce574685e29d22461dadf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/skotlang/skotch/releases/download/v0.7.1/skotch-cli-x86_64-unknown-linux-musl.zip"
      sha256 "07f0512b20cbfa097ef3e2f9af07a4f053e31bfbed53948290a64acc901035c9"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
