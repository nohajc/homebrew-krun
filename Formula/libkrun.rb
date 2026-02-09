class Libkrun < Formula
  desc "Dynamic library providing KVM-based process isolation capabilities"
  homepage "https://github.com/containers/libkrun"
  version "1.17.3"
  url "https://github.com/containers/libkrun/archive/refs/tags/v1.17.3.tar.gz"
  sha256 "8fb85ec8342c1fd85781736ef7259f42f0036336bdb348b388603cca36301914"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krun/master/bottles"
    sha256 cellar: :any, arm64_tahoe: "6ae11c2bcf3fede9005d08e76e3e39df7b86c024374d8adf47c2510afc00cf06"
    sha256 cellar: :any, arm64_sequoia: "6ce4dfb526671af42faabed8909e7e0a030c36d8f8244f168baefc41410854bf"
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
