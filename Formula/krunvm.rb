class Krunvm < Formula
  desc "Manage lightweight VMs created from OCI images"
  homepage "https://github.com/slp/krunvm"
  url "https://github.com/containers/krunvm/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "1309cbffad87c0348a468ed728a0575cf3187cba0d26543a00174a48ac89ec61"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krun/master/bottles"
    sha256 cellar: :any, arm64_tahoe: "56378238b0f7db1c746374f1e6837c9a65279245369d6b393541b4c187f15b57"
    sha256 cellar: :any, arm64_sequoia: "ecbb72c72f7a386d005f995402ee0d052361c543466665013e0cf63aa31c886f"
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
