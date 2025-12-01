class Libkrun < Formula
  desc "Dynamic library providing KVM-based process isolation capabilities"
  homepage "https://github.com/containers/libkrun"
  version "1.16.0"
  url "https://github.com/containers/libkrun/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "04b6f01f44e263d168757ebcd9bc037d7c5836c1987a547c6b2fa5837abe1ab1"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krun/master/bottles"
    sha256 cellar: :any, arm64_tahoe: "e4b2f084e931035d9c8420d16021fdd44ca2472f937ce56a15cdcc8531a7e982"
  end

  patch do
    url "https://raw.githubusercontent.com/slp/homebrew-krun/refs/heads/master/patches/libkrun-makefile-add-cross-compilation-support.diff"
    sha256 "2d98e025255a0498d069cd7e585ecfdb98277dec9e229102b5c875ac3024567d"
  end

  depends_on "rust" => :build
  # Upstream only supports Hypervisor.framework on arm64
  depends_on arch: :arm64
  depends_on "dtc"
  depends_on "lld"
  depends_on "libkrunfw"
  depends_on "virglrenderer"
  depends_on "xz"

  def install
    system "make", "BLK=1", "NET=1", "GPU=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libkrun.h>
      int main()
      {
         int c = krun_create_ctx();
         return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lkrun", "-o", "test"
    system "./test"
  end
end
