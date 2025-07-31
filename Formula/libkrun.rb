class Libkrun < Formula
  desc "Dynamic library providing KVM-based process isolation capabilities"
  homepage "https://github.com/containers/libkrun"
  version "1.14.0"
  url "https://github.com/containers/libkrun/releases/download/v1.14.0/libkrun-1.14.0-prebuilt-aarch64.tar.gz"
  sha256 "c84c72701950d11e3183b3bb58d79c09716d2ced628158d6f0b62a2c6bd1e8de"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krun/master/bottles"
    sha256 cellar: :any, arm64_sequoia: "3ab5da8c23c627e157424f178c02324e232a8b4f783949ba42ab60e90da2a236"
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
