class Krunai < Formula
  desc "An easy to use, fast and powerful tool for running AI agents inside microVM sandboxes."
  homepage "https://github.com/slp/krunai"
  url "https://github.com/slp/krunai/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "39eb3da006c024b0724874fc69390d91c4a976525956ea59e57c3b643c0231ff"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krun/master/bottles"
    sha256 cellar: :any, arm64_tahoe: "591952548fec76ccb953a9d223681b84c2812f7beb1edecb5b222f7934083778"
    sha256 cellar: :any, arm64_sequoia: "d99a396390e2e64c2872fa9bfeac5f566628c02d9b6857d53838abd981cbaa6a"
  end

  depends_on "rust" => :build
  # We depend on libkrun, which only supports Hypervisor.framework on arm64
  depends_on arch: :arm64
  depends_on "libkrun"
  # We just need qemu-img, but it's not packaged independently
  depends_on "qemu"
  depends_on "gvproxy"

  def install
    homebrew_lib = ENV["HOMEBREW_PREFIX"] + "/lib"
    system "make"
    system "install_name_tool", "-add_rpath", homebrew_lib, "target/release/krunai"
    system "codesign", "--entitlements", "krunai.entitlements", "--force", "-s", "-", "target/release/krunai"
    bin.install "target/release/krunai"
  end

  test do
    system "krunai", "--version"
  end
end
