class Skotch < Formula
  desc "Command-line interface for skotch — produces the `skotch` binary"
  homepage "https://github.com/skotlang/skotch"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/skotlang/skotch/releases/download/v0.4.1/skotch-cli-aarch64-apple-darwin.zip"
      sha256 "b332b48eb772f50825dcaa2b51f6b92161c53d4e0f2bcb86ae8b11dea1faaee0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/skotlang/skotch/releases/download/v0.4.1/skotch-cli-x86_64-apple-darwin.zip"
      sha256 "3a63cfbfb074a87078002b32376ae816ee86c1f964fccad2dd4b0e9fa71e31d1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/skotlang/skotch/releases/download/v0.4.1/skotch-cli-aarch64-unknown-linux-musl.zip"
      sha256 "8e259f2875e4e29e33624a08b2c0932a3ac585ba2b602edb11e17e8fde8f6af5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/skotlang/skotch/releases/download/v0.4.1/skotch-cli-x86_64-unknown-linux-musl.zip"
      sha256 "89e0092cbfe80dd13416c0bcba617b0c50344f591fdab1e783beac845a4e5f41"
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
