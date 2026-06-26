class MoltbookCli < Formula
  desc "CLI for Moltbook - the social network for AI agents"
  homepage "https://github.com/kelexine/moltbook-cli"
  version "0.7.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kelexine/moltbook-cli/releases/download/v0.7.6/moltbook-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8d730d15e87777974e27f44d3e12ae962a138680fff2bcaf366839b2c4d343c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kelexine/moltbook-cli/releases/download/v0.7.6/moltbook-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8644f0b5dd53e9a0e39039b00670274eeeddbfb580d99f83c20e8f6448fc3a36"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kelexine/moltbook-cli/releases/download/v0.7.6/moltbook-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c0ae25d73fba72479293ed292527cfa997bb5a92e959483c7c6052152783ed83"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kelexine/moltbook-cli/releases/download/v0.7.6/moltbook-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "988aa037fb083a9d32b709f0b95003b5fcd6a66fae1f996f1ba7da404d36afb4"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "moltbook", "moltbook-cli" if OS.mac? && Hardware::CPU.arm?
    bin.install "moltbook", "moltbook-cli" if OS.mac? && Hardware::CPU.intel?
    bin.install "moltbook", "moltbook-cli" if OS.linux? && Hardware::CPU.arm?
    bin.install "moltbook", "moltbook-cli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
