class Krunvm < Formula
  desc "Manage lightweight VMs created from OCI images"
  homepage "https://github.com/slp/krunvm"
  url "https://github.com/containers/krunvm/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "9f13e938a10565cdd0d38bd49f8c7fc5be57245740bad2bb138eec8675d4ee3b"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krun/master/bottles"
    sha256 cellar: :any, arm64_tahoe: "ebb4d07cc32b2f7b0c17dde0db67ae315831877f0a472149ecf058fc536d4195"
    sha256 cellar: :any, arm64_sequoia: "0bb8acfda1dcba4bc8e0fe893b677fd896e223c71f9f366a02f79939962d6700"
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
