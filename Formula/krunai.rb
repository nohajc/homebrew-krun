class Krunai < Formula
  desc "An easy to use, fast and powerful tool for running AI agents inside microVM sandboxes."
  homepage "https://github.com/slp/krunai"
  url "https://github.com/slp/krunai/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "9ce8419cbc6b0e7d9f893cefe8763eeeb62fcff2aac2250123fde9797f842939"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krun/master/bottles"
    sha256 cellar: :any, arm64_tahoe: "dac8689d0a99970b8bce978056e98fbc8570326576ee0867bf7f660e14b9fa96"
    sha256 cellar: :any, arm64_sequoia: "ac48a6f69f00794a942151bcff1782a7d0a11fae4cfed8b2d4fd509463a9a1c2"
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
