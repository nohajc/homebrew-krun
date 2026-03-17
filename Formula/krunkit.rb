class Krunkit < Formula
  desc "A CLI tool to start Linux KVM or macOS Hypervisor framework virtual machines using the libkrun platform."
  homepage "https://github.com/containers/krunkit"
  url "https://github.com/containers/krunkit/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "660d67d93d5c25caa996561b42ddca55848799673080bf5640ec1fba63d6260e"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krunkit/master/bottles"
    sha256 cellar: :any, arm64_tahoe: "fe04ffe1da4a41264734a9b730fef6ec386d5d87c105c2bea49ae04693447e9a"
    sha256 cellar: :any, arm64_sequoia: "295e725a384fe593507b528b2c3583e2ba5e78bb439ac3d15afe60111b93c62f"
  end

  depends_on "rust" => :build
  # We depend on libkrun, which only supports Hypervisor.framework on arm64
  depends_on arch: :arm64
  depends_on "libkrun"
  depends_on "gvproxy"

  def install
    homebrew_lib = ENV["HOMEBREW_PREFIX"] + "/lib"
    system "make"
    system "install_name_tool", "-add_rpath", homebrew_lib, "target/release/krunkit"
    system "codesign", "--entitlements", "krunkit.entitlements", "--force", "-s", "-", "target/release/krunkit"
    bin.install "target/release/krunkit"
    pkgshare.install "edk2/KRUN_EFI.silent.fd"
  end

  test do
    system "krunkit", "--version"
  end
end
