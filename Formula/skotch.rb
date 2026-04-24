class Skotch < Formula
  desc "Command-line interface for skotch — produces the `skotch` binary"
  homepage "https://github.com/skotlang/skotch"
  version "0.13.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/skotlang/skotch/releases/download/v0.13.0/skotch-cli-aarch64-apple-darwin.zip"
      sha256 "cf7e8bcc3ba2c9e5eb67450cb8a4cfd4d4a56b7832388c299eac746773504205"
    end
    if Hardware::CPU.intel?
      url "https://github.com/skotlang/skotch/releases/download/v0.13.0/skotch-cli-x86_64-apple-darwin.zip"
      sha256 "e3c6e2987d678d23638daee86b6cf2e2770be076bc2eb381185198ab724a5854"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/skotlang/skotch/releases/download/v0.13.0/skotch-cli-aarch64-unknown-linux-musl.zip"
      sha256 "d04f82b744f9c70b7dd74bb84e8cf8a922c5950537c06713f4a5b2838290618d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/skotlang/skotch/releases/download/v0.13.0/skotch-cli-x86_64-unknown-linux-musl.zip"
      sha256 "5d39981cd774d89cc16575a623e07b636f9da4c375c0ebbf09bd4f2d0ab50bdd"
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
