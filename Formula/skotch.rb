class Skotch < Formula
  desc "Command-line interface for skotch — produces the `skotch` binary"
  homepage "https://github.com/skotlang/skotch"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/skotlang/skotch/releases/download/v0.3.0/skotch-cli-aarch64-apple-darwin.zip"
      sha256 "ff83e7af6a55a7ff5e9b9c3a6f4a9d5ba1797d5708b0def63cd0026227c0264a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/skotlang/skotch/releases/download/v0.3.0/skotch-cli-x86_64-apple-darwin.zip"
      sha256 "11fd6aae1b56f1d29e0a55c8a30b95082e1738fc6eada4b2def6c091d24e65c7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/skotlang/skotch/releases/download/v0.3.0/skotch-cli-aarch64-unknown-linux-musl.zip"
      sha256 "71ca34c2de16f22a8cd9449852e0ab1cc14ddefeb6eb3d9359349a128d5c49e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/skotlang/skotch/releases/download/v0.3.0/skotch-cli-x86_64-unknown-linux-musl.zip"
      sha256 "ba8465b2d386ccb3bfdd9533bb59dee4af99d38f32039b8ea4ffade1c5ba8a2c"
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
