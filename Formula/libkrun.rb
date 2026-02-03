class Libkrun < Formula
  desc "Dynamic library providing KVM-based process isolation capabilities"
  homepage "https://github.com/containers/libkrun"
  version "1.17.1"
  url "https://github.com/containers/libkrun/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "82e14eafe558824e1477131d02274e8508f6d9a96e9e5f81a45c3e41ee7d833a"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krun/master/bottles"
    sha256 cellar: :any, arm64_tahoe: "c62bd91c1bf53f98643fce8a7e45290330c02d417ea24a04a6b58dae332677eb"
    sha256 cellar: :any, arm64_sequoia: "1d630c5cf68b04838e9d087fc9a12fb575ba8a6c2027f717882e37b6bd60d465"
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
