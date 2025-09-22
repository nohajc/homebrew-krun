class Libkrun < Formula
  desc "Dynamic library providing KVM-based process isolation capabilities"
  homepage "https://github.com/containers/libkrun"
  version "1.15.1"
  url "https://github.com/containers/libkrun/releases/download/v1.15.1/libkrun-1.15.1-prebuilt-aarch64.tar.gz"
  sha256 "0ca2999968dbc469e9949d5a61f4399e339a51f3db7ff356aba3b8f13fc4c075"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krun/master/bottles"
    sha256 cellar: :any, arm64_sequoia: "e4eb00e58f84e95caef93d36c403b4dd134fa140f2b884bea4c0d62c076afa2d"
  end

  patch do
    url "https://raw.githubusercontent.com/slp/homebrew-krun/refs/heads/master/patches/libkrun-disable-display.diff"
    sha256 "3e11baec017c6dc7bc5c92731b7db19cd597f74c20b4e41497aaa82ea68bfa0e"
  end

  depends_on "rust" => :build
  # Upstream only supports Hypervisor.framework on arm64
  depends_on arch: :arm64
  depends_on "dtc"
  depends_on "libkrunfw"

  def install
    system "make", "BLK=1", "NET=1"
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
