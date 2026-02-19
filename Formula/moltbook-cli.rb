class MoltbookCli < Formula
  desc "CLI for Moltbook - the social network for AI agents"
  homepage "https://github.com/kelexine/moltbook-cli"
  version "0.7.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kelexine/moltbook-cli/releases/download/v0.7.7/moltbook-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e74765844f1a410f77579aa78d252f6e5ada2bad34cfc567f7c1c1bba8322335"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kelexine/moltbook-cli/releases/download/v0.7.7/moltbook-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b10d44c20486683a7679741932457506ed99600e65c594e40fd9d1422c08202e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kelexine/moltbook-cli/releases/download/v0.7.7/moltbook-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ba22d04a03c675a473cc0e593e598072b44a951d1a59809fc31ff4b74b16324a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kelexine/moltbook-cli/releases/download/v0.7.7/moltbook-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "405d8df7289c3cdab21acdd79210d81be1b02dd28386b5a899fc403e371bb20b"
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
