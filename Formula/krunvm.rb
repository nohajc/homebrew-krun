class Krunvm < Formula
  desc "Manage lightweight VMs created from OCI images"
  homepage "https://github.com/slp/krunvm"
  url "https://github.com/containers/krunvm/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "9b09bd38b9beb134d2842bca74d0ef7b160408f0e583d31173a007e893cf504a"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krun/master/bottles"
    sha256 cellar: :any, arm64_tahoe: "cb295f8d3103383eef425e86f2578f13952712f301471f85ed8f003b9d9e4266"
    sha256 cellar: :any, arm64_sequoia: "cfc87085676d5c43e9974455f5e9a77a86afbd012b39d78be6942bcac97dcdf6"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build
  # We depend on libkrun, which only supports Hypervisor.framework on arm64
  depends_on arch: :arm64
  depends_on "buildah"
  depends_on "libkrun"

  def install
    system "make"
    bin.install "target/release/krunvm"
    man1.install Dir["target/release/build/krunvm-*/out/*.1"]
  end

  test do
    system "krunvm", "--version"
  end
end
