class Skotch < Formula
  desc "Command-line interface for skotch — produces the `skotch` binary"
  homepage "https://github.com/skotlang/skotch"
  version "0.8.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/skotlang/skotch/releases/download/v0.8.4/skotch-cli-aarch64-apple-darwin.zip"
      sha256 "f8b8c2c74f811cede61b809770a4fcd46f05e7a7e7e44a08c593e0b1f086a839"
    end
    if Hardware::CPU.intel?
      url "https://github.com/skotlang/skotch/releases/download/v0.8.4/skotch-cli-x86_64-apple-darwin.zip"
      sha256 "634b80da83d580dbaadd1244236a54f54ca639a29bf24afba635f58f23944b4f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/skotlang/skotch/releases/download/v0.8.4/skotch-cli-aarch64-unknown-linux-musl.zip"
      sha256 "2c38ca5f78161542ebd9884b18e23540d0ab61bad7e49ffc91d29b33b3656e6b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/skotlang/skotch/releases/download/v0.8.4/skotch-cli-x86_64-unknown-linux-musl.zip"
      sha256 "0b3665e6f7819457badfb942e6e449755204ed74ffe689bd85a90442cf89fed4"
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
