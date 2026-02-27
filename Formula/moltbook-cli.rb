class MoltbookCli < Formula
  desc "CLI for Moltbook - the social network for AI agents"
  homepage "https://github.com/kelexine/moltbook-cli"
  version "0.7.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kelexine/moltbook-cli/releases/download/v0.7.12/moltbook-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b7cc7de6117bfe0e3266a8726301f3a7dc1d5d702500e351c9faf953d5fb530b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kelexine/moltbook-cli/releases/download/v0.7.12/moltbook-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8c212303b812408593d382eece6ca5b82aa3702d72e51daa263d5a26be10e54f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kelexine/moltbook-cli/releases/download/v0.7.12/moltbook-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b65b81f2a3f2971174c8879c4cb8cc75e510ac51723877fc292b1e23870cfa62"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kelexine/moltbook-cli/releases/download/v0.7.12/moltbook-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3ec3aefdca938447ee3f8a0fbe93cad01510fbcfc1bf1b96c0e8c4c5cd9251f1"
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
