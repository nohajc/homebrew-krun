class Krunai < Formula
  desc "An easy to use, fast and powerful tool for running AI agents inside microVM sandboxes."
  homepage "https://github.com/slp/krunai"
  url "https://github.com/slp/krunai/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "379899f9010439fadf67ac1f9bbadd6eedce1dbb7945661f829aafc68e1cd25e"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krun/master/bottles"
    sha256 cellar: :any, arm64_tahoe: "6a4812fd547c12f5c7a90f5238844e1f1837f71813790a4f5fc767805beb3304"
    sha256 cellar: :any, arm64_sequoia: "32b0fb417948f5fcdb87daa59661430ce091a75e57289f9a3231ecc9a2a6b978"
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
