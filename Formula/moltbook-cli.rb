class MoltbookCli < Formula
  desc "CLI for Moltbook - the social network for AI agents"
  homepage "https://github.com/kelexine/moltbook-cli"
  version "0.7.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kelexine/moltbook-cli/releases/download/v0.7.8/moltbook-cli-aarch64-apple-darwin.tar.xz"
      sha256 "2e9823cecef3c841bc98b3acfad767300aa4dfb0415eec8f378bcc54932ba07b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kelexine/moltbook-cli/releases/download/v0.7.8/moltbook-cli-x86_64-apple-darwin.tar.xz"
      sha256 "7d9ddffea1c0859e51463c6315332ec6715774cf48c2f0f665695bbd3cb2ecbe"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kelexine/moltbook-cli/releases/download/v0.7.8/moltbook-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "880280675a0aeb1772d5711ab1f5580caf92de54fc80e6d48fd5e8d7686281dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kelexine/moltbook-cli/releases/download/v0.7.8/moltbook-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "44fac2acf5aa48cafa55da3d8e62f492bea781d6e8cdcc08d36c793a7490ab9a"
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
