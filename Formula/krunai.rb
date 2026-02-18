class Krunai < Formula
  desc "An easy to use, fast and powerful tool for running AI agents inside microVM sandboxes."
  homepage "https://github.com/slp/krunai"
  url "https://github.com/slp/krunai/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "692371c6e813b785f85a445aff758fd53c7094d278de1f3ad7fdab1fe84c6fec"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krun/master/bottles"
    sha256 cellar: :any, arm64_tahoe: "aa15c9038f86ffd92828fb32b42486a3be27caf62272d14bc8b77f7c2bf7efcc"
    sha256 cellar: :any, arm64_sequoia: "8a1523493feeeb39ee2b2bedacc34c713da2be98f965b7277d6f01340eea5909"
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
