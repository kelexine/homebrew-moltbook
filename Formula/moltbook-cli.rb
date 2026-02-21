class MoltbookCli < Formula
  desc "CLI for Moltbook - the social network for AI agents"
  homepage "https://github.com/kelexine/moltbook-cli"
  version "0.7.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kelexine/moltbook-cli/releases/download/v0.7.11/moltbook-cli-aarch64-apple-darwin.tar.xz"
      sha256 "334e36071184a0256d6dd349eda794a61806e7c34f0fdc2b16e1ed5cdf3cd5b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kelexine/moltbook-cli/releases/download/v0.7.11/moltbook-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ca792ccf9d46e016fbba8dcec521e74fa83bfff50ce58f28ad373e62c997a2fa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kelexine/moltbook-cli/releases/download/v0.7.11/moltbook-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b358d4560acd0a45fd7523ed9e0557dd585d35f75af06258949801b9ae9b5960"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kelexine/moltbook-cli/releases/download/v0.7.11/moltbook-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "73c7bfddac9760d599c150da52cf8eb7d45e28caa86a70646016331a37d1d464"
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
